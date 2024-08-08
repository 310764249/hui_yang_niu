import 'package:get/get.dart';

import '../controllers/assay_detail_controller.dart';

class AssayDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AssayDetailController>(
      () => AssayDetailController(),
    );
  }
}
