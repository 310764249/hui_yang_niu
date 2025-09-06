import 'dart:io';
import 'package:em_chat_uikit/chat_sdk_service/src/chat_sdk_define.dart';
import 'package:em_chat_uikit/chat_uikit/src/chat_uikit_service/chat_uikit_service.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// 缓存控制器，避免重复加载
class VideoPlayerControllerCache {
  static final Map<String, VideoPlayerController> _cache = {};

  static VideoPlayerController getController(String id, String url) {
    if (_cache.containsKey(id)) {
      return _cache[id]!;
    }
    final isNetUrl = url.startsWith('http');
    final controller =
        isNetUrl
            ? VideoPlayerController.networkUrl(Uri.parse(url))
            : VideoPlayerController.file(File(url));
    _cache[id] = controller;
    return controller;
  }

  static void disposeController(String id) {
    _cache[id]?.dispose();
    _cache.remove(id);
  }

  static void disposeAll() {
    for (final c in _cache.values) {
      c.dispose();
    }
    _cache.clear();
  }
}

class ChatVideoMessage extends StatefulWidget {
  final String videoUrl; // 视频链接
  final String avatarUrl;
  final String nickname;
  final bool isSelf;
  final Message msg;
  final Function(Message msg)? onLongPress;

  const ChatVideoMessage({
    super.key,
    required this.videoUrl,
    required this.avatarUrl,
    required this.nickname,
    required this.isSelf,
    required this.msg,
    this.onLongPress,
  });

  @override
  State<ChatVideoMessage> createState() => _ChatVideoMessageState();
}

class _ChatVideoMessageState extends State<ChatVideoMessage> with AutomaticKeepAliveClientMixin {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _initVideo();
    ChatUIKit.instance.downloadThumbnail(message: widget.msg);
  }

  Future<void> _initVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      _controller = VideoPlayerControllerCache.getController(widget.msg.msgId, widget.videoUrl);

      if (_controller!.value.isInitialized) {
        setState(() => _isLoading = false);
      } else {
        await _controller!.initialize();
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isError = true;
          _isLoading = false;
        });
      }
    }
  }

  void _onTapVideo() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => FullScreenVideoPlayer(
              controller: _controller!,
              nickname: widget.nickname,
              avatarUrl: widget.avatarUrl,
            ),
      ),
    );
  }

  Widget _buildAvatar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: GestureDetector(
        onLongPress: () => widget.onLongPress?.call(widget.msg),
        child: Image.network(
          widget.avatarUrl,
          width: 40,
          height: 40,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const CircleAvatar(radius: 20, child: Icon(Icons.person)),
        ),
      ),
    );
  }

  Widget _buildNickname() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(widget.nickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );
  }

  Widget _buildVideoPlayer() {
    if (_isLoading) {
      return Container(
        width: 180,
        height: 240,
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const CircularProgressIndicator(),
      );
    }
    if (_isError || _controller == null || !_controller!.value.isInitialized) {
      return Container(
        width: 180,
        height: 240,
        color: Colors.grey.shade300,
        alignment: Alignment.center,
        child: const Icon(Icons.error_outline, size: 40, color: Colors.redAccent),
      );
    }

    return GestureDetector(
      onTap: _onTapVideo,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 180, maxHeight: 240),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: Colors.black),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            alignment: Alignment.center,
            children: [
              AspectRatio(
                aspectRatio: _controller!.value.aspectRatio,
                child: VideoPlayer(_controller!),
              ),
              if (!_controller!.value.isPlaying)
                const Icon(Icons.play_circle_outline, size: 60, color: Colors.white70),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final avatar = _buildAvatar();
    final videoPlayer = _buildVideoPlayer();
    final nicknameWidget = _buildNickname();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: widget.isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            widget.isSelf
                ? [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [nicknameWidget, videoPlayer],
                  ),
                  const SizedBox(width: 8),
                  avatar,
                ]
                : [
                  avatar,
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [nicknameWidget, videoPlayer],
                  ),
                ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class FullScreenVideoPlayer extends StatefulWidget {
  final VideoPlayerController controller;
  final String avatarUrl;
  final String nickname;

  const FullScreenVideoPlayer({
    super.key,
    required this.controller,
    required this.avatarUrl,
    required this.nickname,
  });

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {
  late VideoPlayerController _controller;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller;
    _controller.addListener(_onVideoPlayerChanged);

    if (_controller.value.isInitialized) {
      _controller.play();
      _isPlaying = true;
    } else {
      _controller.initialize().then((_) {
        if (mounted) {
          setState(() {
            _controller.play();
            _isPlaying = true;
          });
        }
      });
    }
  }

  void _onVideoPlayerChanged() {
    if (!mounted) return;
    setState(() {}); // 刷新UI
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoPlayerChanged);
    _controller.pause(); // 离开页面暂停
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isPlaying = false);
    } else {
      _controller.play();
      setState(() => _isPlaying = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(title: Text(widget.nickname), backgroundColor: Colors.black),
      body: GestureDetector(
        onTap: _togglePlayPause,
        child: Center(
          child:
              _controller.value.isInitialized
                  ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  )
                  : const CircularProgressIndicator(),
        ),
      ),
    );
  }
}
