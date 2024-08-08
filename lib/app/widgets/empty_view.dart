import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/load_image.dart';

import '../services/AssetsImages.dart';
import '../services/screenAdapter.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          LoadImage(
            AssetsImages.noDataPng,
            fit: BoxFit.cover,
          ),
          Text(
            "暂无数据",
            style: TextStyle(
                color: SaienteColors.black333333,
                fontSize: ScreenAdapter.fontSize(15),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}
