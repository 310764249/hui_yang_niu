import 'package:get/get.dart';

import '../controllers/breed_assess_controller.dart';

class BreedAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreedAssessController>(
      () => BreedAssessController(),
    );
  }
}
