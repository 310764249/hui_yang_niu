import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/material_scrap/controllers/material_scrap_controller.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

class MaterialScrapView extends GetView<MaterialScrapController> {
  const MaterialScrapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报废'),
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
