import 'package:get/get.dart';

import '../controllers/health_care_controller.dart';

class HealthCareBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HealthCareController>(
      () => HealthCareController(),
    );
  }
}
