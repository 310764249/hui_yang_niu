import 'package:get/get.dart';

import '../controllers/breed_value_controller.dart';

class BreedValueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreedValueController>(
      () => BreedValueController(),
    );
  }
}
