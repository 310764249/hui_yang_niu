import 'package:get/get.dart';

import '../controllers/breeding_info_controller.dart';

class BreedingInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreedingInfoController>(
      () => BreedingInfoController(),
    );
  }
}
