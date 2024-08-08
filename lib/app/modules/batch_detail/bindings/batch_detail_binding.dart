import 'package:get/get.dart';

import '../controllers/batch_detail_controller.dart';

class BatchDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatchDetailController>(
      () => BatchDetailController(),
    );
  }
}
