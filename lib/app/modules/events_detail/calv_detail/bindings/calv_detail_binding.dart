import 'package:get/get.dart';

import '../controllers/calv_detail_controller.dart';

class CalvDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalvDetailController>(
      () => CalvDetailController(),
    );
  }
}
