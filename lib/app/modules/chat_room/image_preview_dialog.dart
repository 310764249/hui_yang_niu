import 'package:flutter/material.dart';

class ImagePreviewDialog extends StatelessWidget {
  final String imageUrl;
  final String? heroTag;

  const ImagePreviewDialog({Key? key, required this.imageUrl, this.heroTag}) : super(key: key);

  static void show(BuildContext context, String imageUrl, {String? heroTag}) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => ImagePreviewDialog(imageUrl: imageUrl, heroTag: heroTag),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Center(
            child: heroTag != null ? Hero(tag: heroTag!, child: _buildImage()) : _buildImage(),
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    return InteractiveViewer(
      child: Image.network(
        imageUrl,
        fit: BoxFit.contain,
        errorBuilder:
            (_, __, ___) => const Icon(Icons.broken_image, size: 100, color: Colors.white70),
      ),
    );
  }
}
