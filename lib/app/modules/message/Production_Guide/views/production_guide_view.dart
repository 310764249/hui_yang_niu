import 'package:flutter/material.dart';
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
            Navigator.of(context).pop();
          },
        ),
        title: const Text('消息详情'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
