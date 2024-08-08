import 'package:flutter/material.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

/// 牛只列表顶部的 搜索框，自带图标，高度固定
class SearchField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onComplete;
  final ValueChanged<String>? onSubmitted;
  const SearchField(
      {super.key,
      required this.hintText,
      this.keyboardType,
      this.focusNode,
      this.controller,
      this.onChanged,
      this.onComplete,
      this.onSubmitted});

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      height: ScreenAdapter.height(40),
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10), 0, ScreenAdapter.width(0), 0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      child: TextField(
        maxLines: 1,
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.search,
        focusNode: focusNode,
        onChanged: onChanged,
        onEditingComplete: onComplete,
        onSubmitted: onSubmitted,
        style: TextStyle(
            fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.black28),
        decoration: InputDecoration(
          hintText: hintText,
          counterText: '', // 禁用默认的计数器文本
          border: InputBorder.none, //移除边框
          suffixIcon: const LoadAssetImage(
            AssetsImages.searchPng,
            color: SaienteColors.black33,
          ),
        ),
      ),
    ));
  }
}
