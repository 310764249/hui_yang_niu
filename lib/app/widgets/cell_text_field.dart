import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/input_formatter_helper.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';
import 'divider_line.dart';

class CellTextField extends StatelessWidget {
  // 是否必填, 来控制是否显示红点
  final bool isRequired;
  // 标题
  final String title;
  // 内容
  final String? content;
  // 提示
  final String? hint;
  // 键盘类型
  final TextInputType? keyboardType;
  // 焦点
  final FocusNode? focusNode;
  // 控制
  TextEditingController? controller;
  // 是否可编辑
  final bool? editable;
  // 编辑事件
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onComplete;

  // 标题后可选项相关参数
  final bool? showTitleOption;
  final String? titleOptionContent;
  final String? titleOptionHint;
  final VoidCallback? onOptionPressed;
  final List<TextInputFormatter>? inputFormatters;

  //是否显示分割线
  final bool showDivider;

  CellTextField({
    super.key,
    required this.isRequired,
    required this.title,
    this.content,
    this.hint,
    this.keyboardType,
    this.focusNode,
    this.controller,
    this.onChanged,
    this.onComplete,
    this.onSubmitted,
    this.showTitleOption = false,
    this.editable = false,
    this.titleOptionContent,
    this.titleOptionHint,
    this.onOptionPressed,
    this.inputFormatters,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    controller ??= TextEditingController();
    //controller.text有值就优先用controller，无值使用content
    if (controller!.text.isEmpty) {
      controller!.text = content ?? '';
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(0, ScreenAdapter.height(12), 0, 0),
      child: Column(children: [
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
                style:
                    TextStyle(fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w500, color: SaienteColors.blackE5)),
            titleOptionContent != null && titleOptionContent!.isNotEmpty
                ? Expanded(
                    child: InkWell(
                    onTap: onOptionPressed,
                    child: Text(titleOptionContent!,
                        style: TextStyle(
                          color: SaienteColors.blackE5,
                          fontSize: ScreenAdapter.fontSize(13),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis),
                  ))
                : Expanded(
                    child: InkWell(
                      onTap: onOptionPressed,
                      child: Text(titleOptionHint ?? '',
                          style: TextStyle(
                            color: SaienteColors.black4D,
                            fontSize: ScreenAdapter.fontSize(13),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis),
                    ),
                  ),
            InkWell(
              onTap: onOptionPressed,
              child: Container(
                  width: ScreenAdapter.width(12),
                  height: ScreenAdapter.height(12),
                  margin: EdgeInsets.only(
                    left: ScreenAdapter.width(4),
                    right: ScreenAdapter.width(12),
                  ),
                  child: showTitleOption ?? false
                      ? const LoadAssetImage(
                          AssetsImages.rightArrow,
                          fit: BoxFit.fitHeight,
                        )
                      : const SizedBox()),
            ),
          ],
        ),
        // 输入框
        Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(18), 0, 0, 0),
          child: TextField(
              maxLines: 1,
              controller: controller,
              focusNode: focusNode,
              keyboardType: keyboardType,
              readOnly: editable!,
              onChanged: onChanged,
              onEditingComplete: onComplete,
              onSubmitted: onSubmitted,
              style: TextStyle(fontSize: ScreenAdapter.fontSize(14), color: SaienteColors.blackB2),
              textAlignVertical: TextAlignVertical.center, // 设置文本垂直居中对齐
              inputFormatters: inputFormatters != null ? inputFormatters : [InputFormattersHelper.getFormatterWith(keyboardType)],
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                ),
                counterText: '', // 禁用默认的计数器文本
                border: InputBorder.none, //移除边框
                // contentPadding:
                //     const EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
                /*
                suffixIcon: IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 22,
                  ),
                  onPressed: () {
                    controller?.clear();
                  },
                ),
                */
              )),
        ),
        if (showDivider) const DividerLine(),
      ]),
    );
  }
}
