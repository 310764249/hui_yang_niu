import 'package:get/get.dart';

import '../controllers/environment_assess_detail_controller.dart';

class EnvironmentAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EnvironmentAssessDetailController>(
      () => EnvironmentAssessDetailController(),
    );
  }
}
