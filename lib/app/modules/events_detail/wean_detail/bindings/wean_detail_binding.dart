import 'package:get/get.dart';

import '../controllers/wean_detail_controller.dart';

class WeanDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WeanDetailController>(
      () => WeanDetailController(),
    );
  }
}
