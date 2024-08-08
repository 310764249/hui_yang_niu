import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';
import 'divider_line.dart';

class CellTextAreaDetail extends StatelessWidget {
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
  const CellTextAreaDetail(
      {super.key,
      required this.isRequired,
      required this.title,
      this.content,
      this.hint,
      this.showBottomLine = true});

  @override
  Widget build(BuildContext context) {
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
                  color: SaienteColors.black80)),
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
            alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
            // color: SaienteColors.grayFB,
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Text(content ?? " ",
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13))),
      ),
      showBottomLine ?? false ? const DividerLine() : const SizedBox(),
    ]);
  }
}
