import 'package:get/get.dart';

import '../controllers/environment_assess_controller.dart';

class EnvironmentAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnvironmentAssessController>(
      () => EnvironmentAssessController(),
    );
  }
}
