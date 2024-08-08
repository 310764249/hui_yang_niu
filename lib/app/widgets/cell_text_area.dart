import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';
import 'divider_line.dart';

class CellTextArea extends StatelessWidget {
  // 是否必填, 来控制是否显示红点
  final bool isRequired;
  // 标题
  final String title;
  // 内容
  final String? content;
  // 提示
  final String? hint;
  // 是否显示底部分割线
  final bool? showBottomLine;
  // 键盘类型
  final TextInputType? keyboardType;
  // 焦点
  final FocusNode? focusNode;
  // 控制
  final TextEditingController? controller;
  // 编辑事件
  final ValueChanged<String>? onChanged;
  const CellTextArea({
    super.key,
    required this.isRequired,
    required this.title,
    this.content,
    this.hint,
    this.keyboardType,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.showBottomLine = false,
  });

  @override
  Widget build(BuildContext context) {
    // no need to set
    // controller?.text = content ?? '';

    return Column(children: [
      SizedBox(height: ScreenAdapter.height(12)),
      // 标题
      Row(
        children: [
          SizedBox(width: ScreenAdapter.width(12)),
          Text("*",
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: isRequired ? Colors.red : Colors.transparent)),
          Text(title,
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500,
                  color: SaienteColors.blackE5)),
        ],
      ),
      // 输入框
      Container(
        padding: EdgeInsets.only(
            left: ScreenAdapter.width(10), right: ScreenAdapter.width(2)),
        margin: EdgeInsets.fromLTRB(
            ScreenAdapter.width(12),
            ScreenAdapter.height(10),
            ScreenAdapter.width(12),
            ScreenAdapter.height(10)),
        decoration: const BoxDecoration(
            color: SaienteColors.grayFB,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: TextField(
            controller: controller,
            focusNode: focusNode,
            keyboardType: keyboardType,
            onChanged: onChanged,
            maxLines: 3,
            // maxLength: 100,
            style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14),
                color: SaienteColors.blackB2),
            decoration: InputDecoration(
              hintText: hint,
              // counterText: '', // 禁用默认的计数器文本
              border: InputBorder.none, //移除边框
              // contentPadding: const EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
            )),
      ),
      showBottomLine ?? false ? const DividerLine() : const SizedBox(),
    ]);
  }
}
