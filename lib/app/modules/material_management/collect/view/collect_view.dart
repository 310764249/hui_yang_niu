import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/collect/controllers/collect_controller.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

class CollectView extends GetView<CollectController> {
  const CollectView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('领用'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {},
              child: Text(
                "新增",
                style: TextStyle(color: SaienteColors.blue275CF3, fontSize: ScreenAdapter.fontSize(16)),
              )),
        ],
      ),
    );
  }
}
