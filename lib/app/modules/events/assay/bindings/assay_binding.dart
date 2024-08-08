import 'package:get/get.dart';

import '../controllers/assay_controller.dart';

class AssayBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssayController>(
      () => AssayController(),
    );
  }
}
