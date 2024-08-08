import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

///基础 Button 封装 比如 登录、提交、确认等高度固定，宽度自适应
class MainButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const MainButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      // margin: EdgeInsets.only(top: ScreenAdapter.height(40)),
      height: ScreenAdapter.height(46),
      child: ElevatedButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(SaienteColors.appMain),
            foregroundColor: MaterialStateProperty.all(Colors.white),
            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ScreenAdapter.width(10))))),
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(18),
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
