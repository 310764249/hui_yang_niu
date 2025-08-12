import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:video_player/video_player.dart';

class ChatVideoMessage extends StatefulWidget {
  final String videoUrl; // 远程视频链接
  final String avatarUrl;
  final String nickname;
  final bool isSelf;

  const ChatVideoMessage({
    super.key,
    required this.videoUrl,
    required this.avatarUrl,
    required this.nickname,
    required this.isSelf,
  });

  @override
  State<ChatVideoMessage> createState() => _ChatVideoMessageState();
}

class _ChatVideoMessageState extends State<ChatVideoMessage> {
  VideoPlayerController? _controller;
  bool _isLoading = true;
  bool _isError = false;
  File? _localFile;

  @override
  void initState() {
    super.initState();
    _initVideo();
  }

  Future<void> _initVideo() async {
    try {
      setState(() {
        _isLoading = true;
        _isError = false;
      });

      // 先尝试从缓存取文件
      final cacheManager = DefaultCacheManager();
      final fileInfo = await cacheManager.getFileFromCache(widget.videoUrl);

      File file;
      if (fileInfo != null && fileInfo.file.existsSync()) {
        // 缓存文件存在，使用本地路径
        file = fileInfo.file;
      } else {
        // 缓存不存在，下载缓存
        file = await cacheManager.getSingleFile(widget.videoUrl);
      }

      _localFile = file;

      _controller = VideoPlayerController.file(file)
        ..initialize()
            .then((_) {
              if (!mounted) return;
              setState(() {
                _isLoading = false;
                _isError = false;
              });
            })
            .catchError((e) {
              setState(() {
                _isLoading = false;
                _isError = true;
              });
            });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isError = true;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _onTapVideo() {
    if (_controller == null || !_controller!.value.isInitialized) return;

    // 这里你可以跳转到一个全屏播放器页面，也可以弹窗播放
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
      child: Image.network(
        widget.avatarUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const CircleAvatar(radius: 20, child: Icon(Icons.person)),
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

    // 监听播放状态改变
    _controller.addListener(_onVideoPlayerChanged);

    if (_controller.value.isInitialized) {
      _controller.play();
      _isPlaying = true;
    } else {
      // 如果还没初始化，等待初始化完成后自动播放
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
    setState(() {}); // 更新UI，比如播放状态和缓冲状态
  }

  @override
  void dispose() {
    _controller.removeListener(_onVideoPlayerChanged);
    // 这里不dispose控制器，外面传进来的控制器应该由外部管理
    _controller.pause();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      _controller.play();
      setState(() {
        _isPlaying = true;
      });
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
