import 'package:get/get.dart';

import '../controllers/batch_list_controller.dart';

class BatchListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BatchListController>(
      () => BatchListController(),
    );
  }
}
