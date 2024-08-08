import 'package:get/get.dart';

import '../controllers/pregcy_controller.dart';

class PregcyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PregcyController>(
      () => PregcyController(),
    );
  }
}
