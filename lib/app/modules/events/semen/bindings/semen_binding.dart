import 'package:get/get.dart';

import '../controllers/semen_controller.dart';

class SemenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SemenController>(
      () => SemenController(),
    );
  }
}
