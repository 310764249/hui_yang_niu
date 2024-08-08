import 'package:get/get.dart';

import '../controllers/new_batch_controller.dart';

class NewBatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewBatchController>(
      () => NewBatchController(),
    );
  }
}
