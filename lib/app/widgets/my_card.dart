import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

class MyCard extends StatelessWidget {
  final List<Widget> children;
  const MyCard({super.key, required this.children});
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(ScreenAdapter.width(10), ScreenAdapter.width(10), ScreenAdapter.width(10), 0),
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.all(Radius.circular(ScreenAdapter.width(10)))),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class CardTitle extends StatelessWidget {
  // 标题
  final String title;
  const CardTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenAdapter.height(52),
      margin: EdgeInsets.only(left: ScreenAdapter.width(12)),
      color: Colors.transparent,
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
            color: SaienteColors.blackE5,
            fontSize: ScreenAdapter.fontSize(16),
            fontWeight: FontWeight.w500),
      ),
    );
  }
}
