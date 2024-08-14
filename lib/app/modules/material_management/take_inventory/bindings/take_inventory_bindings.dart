import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/take_inventory/controllers/take_inventory_controller.dart';

class TakeInventoryBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<TakeInventoryController>(TakeInventoryController());
  }
}
