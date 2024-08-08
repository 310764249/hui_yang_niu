import 'package:get/get.dart';

import '../controllers/calv_controller.dart';

class CalvBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalvController>(
      () => CalvController(),
    );
  }
}
