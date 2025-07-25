import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

enum ImageFormat { png, jpg, gif, webp }

extension ImageFormatExtension on ImageFormat {
  String get value => ['png', 'jpg', 'gif', 'webp'][index];
}

/// 图片加载（支持本地与网络图片）
class LoadImage extends StatelessWidget {
  const LoadImage(
    this.image, {
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.format = ImageFormat.png,
    this.holderImg = 'assets/images/placeholder_cattle.png',
    this.cacheWidth,
    this.cacheHeight,
  });

  final String image;
  final double? width;
  final double? height;
  final BoxFit fit;
  final ImageFormat format;
  final String holderImg;
  final int? cacheWidth;
  final int? cacheHeight;

  @override
  Widget build(BuildContext context) {
    if (image.isEmpty || image.startsWith('http')) {
      final Widget holder =
          LoadAssetImage(holderImg, height: height, width: width, fit: fit);
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (_, __) => holder,
        errorWidget: (_, __, dynamic error) => holder,
        width: width,
        height: height,
        fit: fit,
        memCacheWidth: cacheWidth,
        memCacheHeight: cacheHeight,
      );
    } else {
      return LoadAssetImage(
        image,
        height: height,
        width: width,
        fit: fit,
        format: format,
        cacheWidth: cacheWidth,
        cacheHeight: cacheHeight,
      );
    }
  }
}

/// 加载本地资源图片
class LoadAssetImage extends StatelessWidget {
  const LoadAssetImage(this.image,
      {super.key,
      this.width,
      this.height,
      this.cacheWidth,
      this.cacheHeight,
      this.fit,
      this.format = ImageFormat.png,
      this.color});

  final String image;
  final double? width;
  final double? height;
  final int? cacheWidth;
  final int? cacheHeight;
  final BoxFit? fit;
  final ImageFormat format;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    //
    Image img = Image.asset(
      image,
      height: height,
      width: width,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
      fit: fit,
      color: color,

      /// 忽略图片语义
      excludeFromSemantics: true,
    );
    //安卓需特殊处理
    if (Platform.isAndroid) {
      if (!image.contains('assets')) {
        img = Image.file(
          File(image),
          width: width,
          height: height,
          cacheWidth: cacheWidth,
          cacheHeight: cacheHeight,
          fit: fit,
          color: color,

          /// 忽略图片语义
          excludeFromSemantics: true,
        );
      }
    }

    return img;
  }
}
