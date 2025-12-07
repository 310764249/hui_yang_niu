import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

/// 你自己的 toast，可自由替换
void showToast(String msg) {
  Toast.show(msg);
}

class VoiceRecordButton extends StatefulWidget {
  /// 开始录音（按下）
  final VoidCallback? onStart;

  /// 松开（但未判断成功或取消）
  final VoidCallback? onRelease;

  /// 用户取消（上滑取消）
  final VoidCallback? onCancel;

  /// 录制成功 -> 返回 File + 时长（毫秒）
  final Function(File file, int duration) onSuccess;

  const VoiceRecordButton({
    Key? key,
    required this.onSuccess,
    this.onStart,
    this.onRelease,
    this.onCancel,
  }) : super(key: key);

  @override
  State<VoiceRecordButton> createState() => _VoiceRecordButtonState();
}

class _VoiceRecordButtonState extends State<VoiceRecordButton> with TickerProviderStateMixin {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();

  bool _ready = false;
  bool _isRec = false;
  bool _willCancel = false;
  bool _isStopHandling = false;

  late DateTime _startAt;
  String? _path;
  Timer? _maxTimer;
  StreamSubscription<RecordingDisposition>? _progressSub;

  /// 最短 800ms，最长 60 秒
  static const int _minMillis = 800;
  static const int _maxSeconds = 60;

  /// 波纹动画
  late final AnimationController _waveCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();
  late final Animation<double> _wave = Tween(
    begin: 1.0,
    end: 1.45,
  ).animate(CurvedAnimation(parent: _waveCtrl, curve: Curves.easeInOut));

  @override
  void initState() {
    super.initState();
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    try {
      await _recorder.openRecorder();
      await _recorder.setSubscriptionDuration(const Duration(milliseconds: 50));
      _ready = true;
    } catch (_) {
      _ready = false;
    }
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    _maxTimer?.cancel();
    _waveCtrl.dispose();
    _recorder.closeRecorder();
    super.dispose();
  }

  // 🔐 权限检测
  Future<bool> _checkMic() async {
    final s = await Permission.microphone.request();
    if (!s.isGranted) showToast("请授予麦克风权限");
    return s.isGranted;
  }

  // 🎬 开始录音
  Future<void> _start() async {
    if (!await _checkMic()) return;
    if (!_ready) await _initRecorder();
    if (!_ready) {
      showToast("录音初始化失败");
      return;
    }
    if (_isRec) return;

    HapticFeedback.mediumImpact();
    widget.onStart?.call();

    final dir = await getTemporaryDirectory();
    final ts = DateTime.now().millisecondsSinceEpoch;
    final directory = await getTemporaryDirectory();
    final folder = Directory("${directory.path}/voice_cache");
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    _path = "${folder.path}/$ts.aac";

    Codec codec = Codec.aacADTS;
    if (await _recorder.isEncoderSupported(codec) != true) {
      codec = Codec.aacMP4;
    }

    _startAt = DateTime.now();
    try {
      await _recorder.startRecorder(
        toFile: _path!,
        codec: codec,
        numChannels: 1,
        sampleRate: 16000,
        bitRate: 16000,
      );
      _listenProgress();
      _timerMax();
      _isRec = true;
      setState(() {});
    } catch (e) {
      showToast("无法开始录音");
      _isRec = false;
    }
  }

  // 📊 监听音量/超时
  void _listenProgress() {
    _progressSub?.cancel();
    _progressSub = _recorder.onProgress?.listen((p) {
      if (p.duration.inSeconds >= _maxSeconds) _reachMax();
    });
  }

  void _timerMax() {
    _maxTimer?.cancel();
    _maxTimer = Timer(const Duration(seconds: _maxSeconds), _reachMax);
  }

  Future<void> _reachMax() async {
    if (!_isRec) return;
    await _stop(doSuccess: true);
  }

  // 🛑 停止录音（判断是否成功）
  Future<void> _stop({required bool doSuccess}) async {
    if (!_isRec || _isStopHandling) return;
    _isStopHandling = true;

    widget.onRelease?.call();

    _maxTimer?.cancel();
    _progressSub?.cancel();

    String? path;
    try {
      path = await _recorder.stopRecorder();
    } catch (_) {}

    _isRec = false;

    final used = DateTime.now().difference(_startAt).inMilliseconds;
    if (!doSuccess || used < _minMillis) {
      if (used < _minMillis) showToast("录音太短");
      _deleteFile(path ?? _path);
      _afterEnd();
      return;
    }

    final f = File(path ?? _path!);
    if (await f.exists()) {
      widget.onSuccess(f, used);
    } else {
      showToast("录音失败");
    }
    _afterEnd();
  }

  // ❌ 取消 + 删除文件
  Future<void> _cancel() async {
    if (!_isRec || _isStopHandling) return;
    widget.onCancel?.call();
    _isStopHandling = true;

    try {
      await _recorder.stopRecorder();
    } catch (_) {}

    _deleteFile(_path);
    _afterEnd();
  }

  Future<void> _deleteFile(String? p) async {
    if (p == null) return;
    final f = File(p);
    if (await f.exists())
      try {
        await f.delete();
      } catch (_) {}
  }

  void _afterEnd() {
    _isStopHandling = false;
    _willCancel = false;
    setState(() {});
  }

  // 🎨 UI
  @override
  Widget build(BuildContext context) {
    final icon = _willCancel ? Icons.delete_forever : Icons.keyboard_voice;
    final tip = _isRec ? (_willCancel ? "松手取消" : "上滑取消") : "按住 说话";

    return Column(
      children: [
        // 波纹
        AnimatedOpacity(
          opacity: _isRec ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          child: ScaleTransition(
            scale: _wave,
            child: Container(
              decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0x40518ef8)),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onLongPressStart: (_) => _start(),
          onLongPressMoveUpdate: (d) {
            final cancel = d.offsetFromOrigin.dy < -60;
            if (cancel != _willCancel) {
              _willCancel = cancel;
              setState(() {});
            }
          },
          onLongPressEnd: (_) => _willCancel ? _cancel() : _stop(doSuccess: true),
          onLongPressCancel: () => _cancel(),
          child: Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors:
                    _willCancel
                        ? [Colors.red, Colors.red]
                        : [const Color(0xff6aa1ff), const Color(0xff3479ee)],
              ),
            ),
            child: Icon(icon, size: 32, color: Colors.white),
          ),
        ),
        const SizedBox(height: 8),
        Text(tip, style: TextStyle(fontSize: 13, color: _willCancel ? Colors.red : Colors.grey)),
      ],
    );
  }
}
