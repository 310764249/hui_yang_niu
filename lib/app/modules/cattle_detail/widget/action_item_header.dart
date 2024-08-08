import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

///
/// 自定义Canvas
/// [生产记录]列表item header
///
class ActionItemHeader extends StatelessWidget {
  final double canvasSize;
  final double circleSize;
  final Color circleColor;
  final Color lineColor;
  final double lineWidth;
  final double dashWidth;
  final double dashSpace;
  final bool? isStart;
  final bool? isLast;

  const ActionItemHeader({
    Key? key,
    this.canvasSize = 20,
    this.circleSize = 20,
    this.circleColor = Colors.red,
    this.lineColor = Colors.black,
    this.lineWidth = 2,
    this.dashWidth = 5,
    this.dashSpace = 5,
    this.isStart = false,
    this.isLast = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ActionItemHeaderPainter(
          circleSize: circleSize,
          circleColor: circleColor,
          lineColor: lineColor,
          lineWidth: lineWidth,
          dashWidth: dashWidth,
          dashSpace: dashSpace,
          isStart: isStart,
          isLast: isLast),
      size: Size(circleSize, canvasSize),
    );
  }
}

class _ActionItemHeaderPainter extends CustomPainter {
  final double circleSize;
  final Color circleColor;
  final Color lineColor;
  final double lineWidth;
  final double dashWidth;
  final double dashSpace;
  bool? isStart;
  bool? isLast;

  _ActionItemHeaderPainter(
      {required this.circleSize,
      required this.circleColor,
      required this.lineColor,
      required this.lineWidth,
      required this.dashWidth,
      required this.dashSpace,
      this.isStart,
      this.isLast});

  @override
  void paint(Canvas canvas, Size size) {
    final circlePaint = Paint()
      ..color = circleColor
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = ScreenAdapter.width(0.5);

    // 画线
    var startPoint =
        Offset(size.width / 2, isStart! ? size.height / 2 : -size.height / 2);
    final endPoint =
        Offset(size.width / 2, isLast! ? size.height / 2 : size.height);
    canvas.drawLine(startPoint, endPoint, linePaint);

    // 画圆点
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), circleSize / 2, circlePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
