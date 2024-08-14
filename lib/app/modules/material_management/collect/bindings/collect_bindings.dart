import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/collect/controllers/collect_controller.dart';

class CollectBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<CollectController>(CollectController());
  }
}
