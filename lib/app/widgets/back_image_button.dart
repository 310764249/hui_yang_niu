import 'package:flutter/material.dart';

class BackImageButton extends StatelessWidget {
  // final String? text;
  final Widget text;
  final String imagePath;
  final double? width;
  final double? height;

  final VoidCallback? onPressed;

  const BackImageButton(
      {super.key,
      required this.text,
      required this.imagePath,
      this.width,
      this.height,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: text,
        ),
      ),
    );
  }
}
