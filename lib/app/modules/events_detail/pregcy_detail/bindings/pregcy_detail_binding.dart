import 'package:get/get.dart';

import '../controllers/pregcy_detail_controller.dart';

class PregcyDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PregcyDetailController>(
      () => PregcyDetailController(),
    );
  }
}
