import 'package:get/get.dart';

import '../controllers/semen_detail_controller.dart';

class SemenDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SemenDetailController>(
      () => SemenDetailController(),
    );
  }
}
