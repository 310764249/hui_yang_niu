import 'package:get/get.dart';

import '../controllers/assessment_detail_controller.dart';

class AssessmentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssessmentDetailController>(
      () => AssessmentDetailController(),
    );
  }
}
