import 'package:get/get.dart';

import '../controllers/health_assess_detail_controller.dart';

class HealthAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthAssessDetailController>(
      () => HealthAssessDetailController(),
    );
  }
}
