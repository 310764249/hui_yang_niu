import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/take_inventory/controllers/take_inventory_controller.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

class TakeInventoryView extends GetView<TakeInventoryController> {
  const TakeInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('盘存'),
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
