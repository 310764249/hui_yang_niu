import 'package:get/get.dart';

import '../controllers/purchase_assess_controller.dart';

class PurchaseAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PurchaseAssessController>(
      () => PurchaseAssessController(),
    );
  }
}
