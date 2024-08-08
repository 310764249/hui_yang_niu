import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

class CellButton extends StatefulWidget {
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
  // 是否显示箭头
  final bool? showArrow;
  // 背景色, 默认透明
  final Color background;
  // 是否显示底部分割线
  final bool? showBottomLine;
  // 点击事件
  final VoidCallback? onPressed;

  const CellButton(
      {super.key,
      required this.isRequired,
      required this.title,
      this.colorTitle,
      this.content,
      this.hint,
      this.background = Colors.transparent,
      this.onPressed,
      this.showArrow = true,
      this.showBottomLine = true});

  @override
  State<CellButton> createState() => _CellButtonState();
}

class _CellButtonState extends State<CellButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: widget.showArrow! ? widget.onPressed : null,
        child: Column(
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
                          color: widget.isRequired
                              ? Colors.red
                              : Colors.transparent)),
                  widget.colorTitle ??
                      Text(widget.title,
                          style: TextStyle(
                              fontSize: ScreenAdapter.fontSize(14),
                              fontWeight: FontWeight.w500,
                              color: SaienteColors.blackE5)),
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
                                color: SaienteColors.black4D,
                                fontSize: ScreenAdapter.fontSize(13),
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.right,
                              overflow: TextOverflow.ellipsis),
                        ),
                  Container(
                      width: ScreenAdapter.width(12),
                      height: ScreenAdapter.height(12),
                      margin: EdgeInsets.only(
                        left: ScreenAdapter.width(4),
                        right: ScreenAdapter.width(12),
                      ),
                      child: widget.showArrow!
                          ? const LoadAssetImage(
                              AssetsImages.rightArrow,
                              fit: BoxFit.fitHeight,
                            )
                          : const SizedBox()),
                ],
              ),
            ),
            widget.showBottomLine ?? true
                ? const DividerLine()
                : const SizedBox()
          ],
        ));
  }
}
