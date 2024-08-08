import 'package:get/get.dart';

import '../controllers/health_assess_controller.dart';

class HealthAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthAssessController>(
      () => HealthAssessController(),
    );
  }
}
