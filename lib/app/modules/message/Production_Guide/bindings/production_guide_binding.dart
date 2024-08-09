import 'package:get/get.dart';

import '../controllers/production_puide_controller.dart';

class ProductionGuideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProductionGuideController>(
      () => ProductionGuideController(),
    );
  }
}
