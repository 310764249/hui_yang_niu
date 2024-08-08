import 'package:get/get.dart';

import '../controllers/un_ban_controller.dart';

class UnBanBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnBanController>(
      () => UnBanController(),
    );
  }
}
