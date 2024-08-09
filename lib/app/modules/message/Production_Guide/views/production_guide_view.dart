import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/production_puide_controller.dart';

/**
 * 生产指南
 */
class ProductionGuideView extends GetView<ProductionGuideController> {
  const ProductionGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pop();
            Get.back();
          },
        ),
        title: const Text('消息详情'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //任务
          Column(
            children: [
              Container(
                padding: const EdgeInsets.all(8).r,
                color: Colors.grey.withOpacity(0.5),
                child: const Text('任  务'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
