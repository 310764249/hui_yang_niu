import 'package:get/get.dart';

import '../controllers/ban_detail_controller.dart';

class BanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BanDetailController>(
      () => BanDetailController(),
    );
  }
}
