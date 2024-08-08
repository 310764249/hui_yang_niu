import 'package:get/get.dart';

import '../controllers/body_assess_controller.dart';

class BodyAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BodyAssessController>(
      () => BodyAssessController(),
    );
  }
}
