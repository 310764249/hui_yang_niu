import 'package:get/get.dart';

import '../controllers/un_ban_detail_controller.dart';

class UnBanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UnBanDetailController>(
      () => UnBanDetailController(),
    );
  }
}
