import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

import '../services/AssetsImages.dart';
import '../services/input_formatter_helper.dart';
import '../services/load_image.dart';

class MainTextField extends StatefulWidget {
  final Widget? prefixIcon;
  final String hintText;
  final int? maxLength;
  final bool? isPassword;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final ValueChanged<String> onChanged;

  const MainTextField(
      {super.key,
      this.prefixIcon,
      required this.hintText,
      this.maxLength = 15,
      this.isPassword = false,
      this.keyboardType = TextInputType.text,
      required this.onChanged,
      this.controller,
      this.focusNode});

  @override
  State<MainTextField> createState() => _MainTextFieldState();
}

class _MainTextFieldState extends State<MainTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.all(0),
          decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(
                    width: ScreenAdapter.height(0.5),
                    color: SaienteColors.separateLine)),
          ),
          child: Row(
            children: <Widget>[
              SizedBox(width: ScreenAdapter.width(5)),
              widget.prefixIcon != null ? widget.prefixIcon! : const SizedBox(),
              SizedBox(width: ScreenAdapter.width(10)),
              Expanded(
                child: TextField(
                  maxLength: widget.maxLength,
                  maxLines: 1,
                  keyboardType: widget.keyboardType,
                  onChanged: widget.onChanged,
                  inputFormatters: [InputFormattersHelper.getFormatterWith(widget.keyboardType!)],
                  focusNode: widget.focusNode,
                  controller: widget.controller,
                  obscureText: widget.isPassword! && _obscureText,
                  style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(19),
                      color: SaienteColors.black28),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    counterText: '', // 禁用默认的计数器文本
                    border: InputBorder.none, //移除边框
                    contentPadding: EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
                  ),
                ),
              ),
              widget.isPassword!
                  ? IconButton(
                      icon: _obscureText
                          ? const LoadImage(AssetsImages.eyeOpenPng)
                          : const LoadImage(AssetsImages.eyeClosePng),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : const SizedBox(),
            ],
          ),
        ),
      ],
    );
  }
}
