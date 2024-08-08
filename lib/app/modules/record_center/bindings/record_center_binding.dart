import 'package:get/get.dart';

import '../controllers/record_center_controller.dart';

class RecordCenterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecordCenterController>(
      () => RecordCenterController(),
    );
  }
}
