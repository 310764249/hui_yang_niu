import 'package:get/get.dart';

import '../controllers/descendants_controller.dart';

class DescendantsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DescendantsController>(
      () => DescendantsController(),
    );
  }
}
