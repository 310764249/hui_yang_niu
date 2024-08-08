import 'package:get/get.dart';

import '../controllers/health_care_detail_controller.dart';

class HealthCareDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthCareDetailController>(
      () => HealthCareDetailController(),
    );
  }
}
