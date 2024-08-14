import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/warehouse_entry/controllers/warehouse_entry_controller.dart';

class WarehouseEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WarehouseEntryController>(WarehouseEntryController());
  }
}
