import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/material_scrap/controllers/material_scrap_controller.dart';

class MaterialScrapBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MaterialScrapController>(MaterialScrapController());
  }
}
