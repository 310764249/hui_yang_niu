import 'package:get/get.dart';

import '../controllers/rut_controller.dart';

class RutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RutController>(
      () => RutController(),
    );
  }
}
