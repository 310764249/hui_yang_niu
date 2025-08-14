// Copyright (c) 2022 NetEase, Inc. All rights reserved.
// Use of this source code is governed by a MIT license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

/// 可选：如果你有自己的播放器，按需导入/调用；没有就删掉这行
// import 'audio_player.dart';

class RecordPanel extends StatefulWidget {
  const RecordPanel({
    super.key,
    required this.onPressedDown,
    required this.onEnd,
    required this.onCancel,
    required this.onSuccess,
  });

  final VoidCallback onPressedDown; // 开始按下回调（进入录音）
  final VoidCallback onEnd; // 结束回调（松手且未取消）
  final VoidCallback onCancel; // 取消回调（上滑取消或系统中断）
  final Function(File file, int duration) onSuccess; // 成功回调（返回音频文件）

  @override
  State<RecordPanel> createState() => _RecordPanelState();
}

class _RecordPanelState extends State<RecordPanel> with TickerProviderStateMixin {
  /// 录音器
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  /// 状态
  bool _recorderReady = false; // 是否已 openRecorder
  bool _isRecording = false; // 正在录音
  bool _willCancel = false; // 上滑取消态
  bool _isStopping = false; // 防止重复 stop

  /// 时长
  static const int _maxSeconds = 60; // 最大 60 秒
  static const int _minMillis = 1000; // 最小 1s
  late DateTime _startAt; // 开始时间
  Timer? _maxTimer; // 60 秒定时器
  StreamSubscription<RecordingDisposition>? _progressSub;

  /// 文件
  String? _currentPath;

  /// UI 动画（波纹）
  late final AnimationController _waveCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  )..repeat();
  late final Animation<double> _waveScale = CurvedAnimation(
    parent: _waveCtrl,
    curve: Curves.ease,
  ).drive(Tween(begin: 1.0, end: 1.5));

  @override
  void initState() {
    super.initState();
    _ensureReady(); // 预热（异步）
  }

  Future<void> _ensureReady() async {
    try {
      // 先不请求权限，只 openRecorder；真正开始录音时再校验权限
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
      _recorderReady = true;
    } catch (e) {
      _recorderReady = false;
      debugPrint('openRecorder error: $e');
    }
  }

  @override
  void dispose() {
    _cancelTimers();
    _cancelProgress();
    _waveCtrl.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  // ========== 手势入口 ==========

  /// 长按开始
  void _onLongPressStart(LongPressStartDetails d) async {
    HapticFeedback.mediumImpact();

    // 停掉你自己 App 的音频（如果有）
    // try { ChatAudioPlayer.instance.stopAll(); } catch (_) {}

    // 权限
    final ok = await _ensureMicPermission();
    if (!ok) {
      Toast.show('需要麦克风权限');
      return;
    }

    if (!_recorderReady) {
      await _ensureReady();
      if (!_recorderReady) {
        Toast.show('录音初始化失败');
        return;
      }
    }

    // 开始
    await _startRecord();
    widget.onPressedDown();
    setState(() {});
  }

  /// 长按移动（上滑取消）
  void _onLongPressMove(LongPressMoveUpdateDetails d) {
    // 向上滑超过 60 像素判定为取消区（可按需调整）
    final cancel = d.offsetFromOrigin.dy < -60;
    if (cancel != _willCancel) {
      _willCancel = cancel;
      setState(() {});
    }
  }

  /// 长按结束（松手完成或取消）
  void _onLongPressEnd(LongPressEndDetails d) async {
    if (!_isRecording) return;

    if (_willCancel) {
      await _cancelRecord(); // 不做时长判断
      widget.onCancel();
    } else {
      final ok = await _stopRecord(); // 做时长判断
      if (ok) {
        widget.onEnd();
      }
    }

    _resetFlags();
    setState(() {});
  }

  /// 系统打断/手势被取消
  void _onLongPressCancel() async {
    if (!_isRecording) return;
    await _cancelRecord();
    widget.onCancel();
    _resetFlags();
    setState(() {});
  }

  // ========== 录音核心 ==========

  Future<bool> _ensureMicPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  Future<void> _startRecord() async {
    if (_isRecording) return;
    _isStopping = false;

    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    _currentPath = '${dir.path}/$ts${ext[Codec.aacADTS.index]}';

    try {
      // 部分设备不支持 aacADTS，可以降级为 aacMP4
      Codec codec = Codec.aacADTS;
      final support = await _recorder.isEncoderSupported(codec);
      if (support != true) {
        codec = Codec.aacMP4;
      }

      _startAt = DateTime.now();

      await _recorder.startRecorder(
        toFile: _currentPath!,
        codec: codec,
        bitRate: 16000,
        numChannels: 1,
        sampleRate: 16000,
      );

      _progressSub = _recorder.onProgress?.listen((e) {
        // 这里可以根据 e.decibels/e.duration 做 UI
        // 超时强停
        if (e.duration.inSeconds >= _maxSeconds) {
          _onReachMax();
        }
      });

      // 兜底计时器（防极端机型 onProgress 不触发）
      _maxTimer?.cancel();
      _maxTimer = Timer(const Duration(seconds: _maxSeconds), _onReachMax);

      _isRecording = true;
    } catch (e) {
      debugPrint('startRecorder error: $e');
      _isRecording = false;
      Toast.show('无法开始录音');
    }
  }

  Future<bool> _stopRecord() async {
    if (!_isRecording || _isStopping) return false;
    _isStopping = true;

    _cancelTimers();
    _cancelProgress();

    try {
      final path = await _recorder.stopRecorder(); // 返回实际文件路径
      _isRecording = false;

      final actual = DateTime.now().difference(_startAt).inMilliseconds;
      if (actual < _minMillis) {
        Toast.show('录制时间过短');
        return false;
      }

      final filePath = path ?? _currentPath;
      if (filePath == null) {
        Toast.show('录音失败');
        return false;
      }

      final file = File(filePath);
      if (await file.exists()) {
        widget.onSuccess(file, actual);
        return true;
      } else {
        Toast.show('录音文件不存在');
        return false;
      }
    } catch (e) {
      debugPrint('stopRecorder error: $e');
      Toast.show('停止录音失败');
      return false;
    }
  }

  Future<void> _cancelRecord() async {
    if (!_isRecording || _isStopping) return;
    _isStopping = true;

    _cancelTimers();
    _cancelProgress();

    try {
      await _recorder.stopRecorder();
    } catch (_) {}
    _isRecording = false;

    // 删除无效文件
    if (_currentPath != null) {
      final f = File(_currentPath!);
      if (await f.exists()) {
        try {
          await f.delete();
        } catch (_) {}
      }
    }
  }

  void _onReachMax() async {
    if (!_isRecording) return;
    await _stopRecord();
    widget.onEnd();
    _resetFlags();
    setState(() {});
  }

  void _cancelTimers() {
    _maxTimer?.cancel();
    _maxTimer = null;
  }

  void _cancelProgress() {
    _progressSub?.cancel();
    _progressSub = null;
  }

  void _resetFlags() {
    _willCancel = false;
    _isStopping = false;
  }

  // ========== UI ==========

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // 波纹
        Positioned(
          top: 30,
          child: IgnorePointer(
            ignoring: true,
            child: AnimatedOpacity(
              opacity: _isRecording ? 1 : 0,
              duration: const Duration(milliseconds: 150),
              child: ScaleTransition(
                scale: _waveScale,
                child: Container(
                  height: 103,
                  width: 103,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(51.5),
                    color: const Color(0x4d518ef8),
                  ),
                ),
              ),
            ),
          ),
        ),

        // 中心按钮 + 提示
        Positioned(
          top: 30,
          child: Column(
            children: [
              GestureDetector(
                onLongPressStart: _onLongPressStart,
                onLongPressMoveUpdate: _onLongPressMove,
                onLongPressEnd: _onLongPressEnd,
                onLongPressCancel: _onLongPressCancel,
                child: Container(
                  padding: const EdgeInsets.all(33.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(51.5),
                    gradient: LinearGradient(
                      colors:
                          _willCancel
                              ? const [Color(0xfff56c6c), Color(0xfff56c6c)]
                              : const [Color(0xff6aa1ff), Color(0xff3479ee)],
                    ),
                  ),
                  child: Icon(
                    _willCancel ? Icons.delete_forever : Icons.keyboard_voice,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                _isRecording ? (_willCancel ? '松手取消' : '上滑取消') : '按住 说话',
                style: TextStyle(
                  fontSize: 12,
                  color: _willCancel ? const Color(0xfff56c6c) : const Color(0xff999999),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 可单独抽出去复用：波纹（如果你更喜欢上面的内置实现，可以删除这个类）
class RecordButtonWave extends StatelessWidget {
  const RecordButtonWave({super.key});
  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

/// 录音状态
enum RecordPlayState { init, recording, stop, canceled }
