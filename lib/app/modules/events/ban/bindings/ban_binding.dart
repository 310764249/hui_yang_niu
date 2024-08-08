import 'package:get/get.dart';

import '../controllers/ban_controller.dart';

class BanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BanController>(
      () => BanController(),
    );
  }
}
