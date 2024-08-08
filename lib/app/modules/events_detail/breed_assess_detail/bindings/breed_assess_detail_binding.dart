import 'package:get/get.dart';

import '../controllers/breed_assess_detail_controller.dart';

class BreedAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreedAssessDetailController>(
      () => BreedAssessDetailController(),
    );
  }
}
