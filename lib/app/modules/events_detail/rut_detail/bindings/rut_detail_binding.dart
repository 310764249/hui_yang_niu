import 'package:get/get.dart';

import '../controllers/rut_detail_controller.dart';

class RutDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RutDetailController>(
      () => RutDetailController(),
    );
  }
}
