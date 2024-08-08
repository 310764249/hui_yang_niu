import 'package:get/get.dart';

import '../controllers/manual_assess_detail_controller.dart';

class ManualAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManualAssessDetailController>(
      () => ManualAssessDetailController(),
    );
  }
}
