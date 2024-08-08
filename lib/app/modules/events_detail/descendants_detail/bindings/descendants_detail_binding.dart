import 'package:get/get.dart';

import '../controllers/descendants_detail_controller.dart';

class DescendantsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DescendantsDetailController>(
      () => DescendantsDetailController(),
    );
  }
}
