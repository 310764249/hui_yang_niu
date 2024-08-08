import 'package:get/get.dart';

import '../controllers/breed_value_detail_controller.dart';

class BreedValueDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BreedValueDetailController>(
      () => BreedValueDetailController(),
    );
  }
}
