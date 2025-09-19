import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/load_image.dart';

/// 大图预览组件
class ImagePreview extends StatelessWidget {
  final List<String> images;
  final int initialIndex;

  const ImagePreview({super.key, required this.images, this.initialIndex = 0});

  /// 打开预览
  static void show(BuildContext context, List<String> images, {int index = 0}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false, // 背景允许透明
        barrierColor: Colors.black54, // 半透明背景
        transitionDuration: const Duration(milliseconds: 250),
        pageBuilder: (_, animation, __) {
          return FadeTransition(
            opacity: animation,
            child: ImagePreview(images: images, initialIndex: index),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent, // 背景透明
        body: SafeArea(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: PageController(initialPage: initialIndex),
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    panEnabled: true,
                    minScale: 1,
                    maxScale: 4,
                    child: Center(child: LoadImage(images[index], fit: BoxFit.contain)),
                  );
                },
              ),
              if (images.length > 1)
                Positioned(
                  bottom: 20,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${initialIndex + 1}/${images.length}',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
