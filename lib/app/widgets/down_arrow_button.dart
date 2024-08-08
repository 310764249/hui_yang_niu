import 'package:flutter/material.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

//列表页条件筛选 下拉箭头按钮
class DownArrowButton extends StatelessWidget {
  final String showText; //初始状态
  final VoidCallback tapAction; //tapAction

  const DownArrowButton(this.showText, this.tapAction, {super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: tapAction,
        child: Container(
          height: ScreenAdapter.height(40),
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, ScreenAdapter.width(8), 0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5),
          ),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                showText,
                style: TextStyle(
                    color: SaienteColors.blackE5,
                    fontSize: ScreenAdapter.fontSize(13),
                    fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              const LoadAssetImage(AssetsImages.downArrowPng),
            ],
          ),
        ),
      ),
    );
  }
}
