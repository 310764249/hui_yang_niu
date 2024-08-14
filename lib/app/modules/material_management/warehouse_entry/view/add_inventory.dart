import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/keyboard_actions_helper.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

class AddInventoryView extends StatefulWidget {
  const AddInventoryView({super.key});

  static Future push(BuildContext context) async {
    return await Get.toNamed(Routes.AddInventory);
  }

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('入库'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
