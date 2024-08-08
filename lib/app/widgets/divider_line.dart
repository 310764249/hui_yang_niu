import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

// Divider(
//   height: 1, // 设置分隔线的高度，默认为 16
//   color: Colors.grey, // 设置分隔线的颜色，默认为当前主题的分隔线颜色
//   thickness: 2, // 设置分隔线的厚度，默认为 0.5
//   indent: 20, // 设置分隔线的缩进，默认为 0
//   endIndent: 20, // 设置分隔线的结束缩进，默认为 0
// )
// 封装分割线, 颜色选填
class DividerLine extends StatelessWidget {
  // 默认颜色
  final Color? color;

  final double? indent;
  final double? endIndent;

  const DividerLine({super.key, this.color, this.indent, this.endIndent});

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color ?? SaienteColors.separateLine,
      height: ScreenAdapter.height(1),
      thickness: ScreenAdapter.height(0.5),
      indent: indent,
      endIndent: endIndent,
    );
  }
}
