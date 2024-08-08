import 'package:get/get.dart';

import '../controllers/purchase_assess_detail_controller.dart';

class PurchaseAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseAssessDetailController>(
      () => PurchaseAssessDetailController(),
    );
  }
}
