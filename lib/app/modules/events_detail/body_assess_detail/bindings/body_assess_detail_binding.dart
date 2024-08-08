import 'package:get/get.dart';

import '../controllers/body_assess_detail_controller.dart';

class BodyAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BodyAssessDetailController>(
      () => BodyAssessDetailController(),
    );
  }
}
