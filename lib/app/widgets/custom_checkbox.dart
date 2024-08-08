import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/load_image.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

import '../services/AssetsImages.dart';


class CustomCheckbox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomCheckbox(
      {super.key, required this.value, required this.onChanged});

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        widget.onChanged(!widget.value);
      },
      child: Container(
        width: ScreenAdapter.width(24),
        height: ScreenAdapter.width(24),
        // decoration: BoxDecoration(
        //   borderRadius: BorderRadius.circular(4.0),
        //   border: Border.all(
        //     color: Colors.grey,
        //     width: 2.0,
        //   ),
        // ),
        child: widget.value
            ? LoadImage(AssetsImages.checkedPng,fit: BoxFit.none,)
            : LoadImage(AssetsImages.uncheckedPng,
                fit: BoxFit.none,
              ), // 未选中状态为空
      ),
    );
  }
}
