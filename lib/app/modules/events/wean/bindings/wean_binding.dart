import 'package:get/get.dart';

import '../controllers/wean_controller.dart';

class WeanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeanController>(
      () => WeanController(),
    );
  }
}
