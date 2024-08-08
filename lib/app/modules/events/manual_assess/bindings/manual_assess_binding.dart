import 'package:get/get.dart';

import '../controllers/manual_assess_controller.dart';

class ManualAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualAssessController>(
      () => ManualAssessController(),
    );
  }
}
