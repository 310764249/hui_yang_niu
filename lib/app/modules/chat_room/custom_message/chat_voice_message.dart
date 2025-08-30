import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:em_chat_uikit/chat_sdk_service/src/chat_sdk_define.dart';
import 'package:flutter/material.dart';

import '../audio_player.dart';

class ChatVoiceMessage extends StatefulWidget {
  const ChatVoiceMessage({
    super.key,
    required this.audioUrl,
    required this.messageId,
    required this.avatarUrl,
    required this.nickname,
    required this.isSelf,
    required this.defaultAvatarAsset,
    this.duration,
    required this.msg,
    this.onLongPress,
  });

  final Function(Message msg)? onLongPress;
  final String audioUrl;
  final String messageId;
  final String avatarUrl;
  final String nickname;
  final bool isSelf;
  final String defaultAvatarAsset;
  final Duration? duration;
  final Message msg;

  @override
  State<ChatVoiceMessage> createState() => _ChatVoiceMessageState();
}

class _ChatVoiceMessageState extends State<ChatVoiceMessage> with SingleTickerProviderStateMixin {
  bool _isPlaying = false;
  late AnimationController _animCtrl;
  late Animation<double> _animScale;
  StreamSubscription? _positionSub;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _animScale = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeInOut));

    // 循环动画
    _animCtrl.addStatusListener((status) {
      if (_isPlaying) {
        if (status == AnimationStatus.completed) {
          _animCtrl.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _animCtrl.forward();
        }
      }
    });
  }

  @override
  void dispose() {
    _stop(true);
    _animCtrl.dispose();
    _positionSub?.cancel();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      _stop();
    } else {
      _start();
    }
  }

  void _start() async {
    // 停止其他播放
    ChatAudioPlayer.instance.stopAll();

    setState(() {
      _isPlaying = true;
      _animCtrl.forward();
    });

    await ChatAudioPlayer.instance.play(
      widget.messageId,
      UrlSource(widget.audioUrl),
      stopAction: _stop,
    );

    _positionSub?.cancel();
    _positionSub = ChatAudioPlayer.instance.players[widget.messageId]?.onPlayerComplete.listen((_) {
      _stop();
    });
  }

  void _stop([bool isDispose = false]) {
    ChatAudioPlayer.instance.stop(widget.messageId);
    _positionSub?.cancel();
    _positionSub = null;

    if (!isDispose) {
      setState(() {
        _isPlaying = false;
        _animCtrl.stop();
        _animCtrl.value = 0.0; // 复位动画
      });
    } else {
      _isPlaying = false;
      _animCtrl.stop();
      _animCtrl.value = 0.0; // 复位动画
    }
  }

  @override
  Widget build(BuildContext context) {
    const bubbleColor = Color(0xFFE0E0E0);
    const textColor = Colors.black87;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: widget.isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!widget.isSelf)
            GestureDetector(
              onLongPress: () => widget.onLongPress?.call(widget.msg),
              child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    widget.avatarUrl.isNotEmpty
                        ? NetworkImage(widget.avatarUrl)
                        : AssetImage(widget.defaultAvatarAsset) as ImageProvider,
              ),
            ),
          if (!widget.isSelf) const SizedBox(width: 8),
          Column(
            crossAxisAlignment: widget.isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(widget.nickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              const SizedBox(height: 2),
              GestureDetector(
                onTap: _playPause,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  constraints: const BoxConstraints(maxWidth: 250),
                  decoration: BoxDecoration(
                    color: bubbleColor,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ScaleTransition(
                        scale: _animScale,
                        child: Icon(
                          _isPlaying ? Icons.volume_up : Icons.play_arrow,
                          color: textColor,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        widget.duration != null ? '${widget.duration!.inSeconds}s' : '',
                        style: const TextStyle(fontSize: 14, color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (widget.isSelf) const SizedBox(width: 8),
          if (widget.isSelf)
            CircleAvatar(
              radius: 16,
              backgroundImage:
                  widget.avatarUrl.isNotEmpty
                      ? NetworkImage(widget.avatarUrl)
                      : AssetImage(widget.defaultAvatarAsset) as ImageProvider,
            ),
        ],
      ),
    );
  }
}
