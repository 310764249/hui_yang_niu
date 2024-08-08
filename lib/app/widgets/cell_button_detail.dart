import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

class CellButtonDetail extends StatefulWidget {
  // 是否必填, 来控制是否显示红点
  final bool isRequired;
  // 标题
  final String title;
  // 可选标题, 可自定义标题Widget
  final Widget? colorTitle;
  // 内容
  final String? content;
  // 提示
  final String? hint;
  // 背景色, 默认透明
  final Color background;
  // 是否显示底部分割线
  final bool? showBottomLine;
  // 点击事件
  final VoidCallback? onPressed;
  const CellButtonDetail(
      {super.key,
      required this.title,
      this.colorTitle,
      this.content,
      this.hint,
      this.background = Colors.transparent,
      this.showBottomLine = true,
      this.onPressed,
      required this.isRequired});

  @override
  State<CellButtonDetail> createState() => _CellButtonDetailState();
}

class _CellButtonDetailState extends State<CellButtonDetail> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: ScreenAdapter.height(52),
          color: widget.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenAdapter.width(12)),
              Text("*",
                  style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color:
                          widget.isRequired ? Colors.red : Colors.transparent)),
              widget.colorTitle ??
                  Text(widget.title,
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          fontWeight: FontWeight.w500,
                          color: SaienteColors.black80)),
              // 内容文字, 如果content不为空, 则显示, 否则显示hint提示文字
              widget.content != null && widget.content!.isNotEmpty
                  ? Expanded(
                      child: Text(widget.content!,
                          style: TextStyle(
                            color: SaienteColors.blackE5,
                            fontSize: ScreenAdapter.fontSize(13),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis))
                  : Expanded(
                      child: Text(widget.hint ?? '',
                          style: TextStyle(
                            color: SaienteColors.blackE5,
                            fontSize: ScreenAdapter.fontSize(13),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis),
                    ),

              SizedBox(width: ScreenAdapter.width(12)),
            ],
          ),
        ),
        widget.showBottomLine ?? true ? const DividerLine() : const SizedBox()
      ],
    );
  }
}
