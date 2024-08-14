import 'package:get/get.dart';

import '../controllers/material_records_controllers.dart';

class MaterialRecordsBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<MaterialRecordsController>(MaterialRecordsController());
  }
}
