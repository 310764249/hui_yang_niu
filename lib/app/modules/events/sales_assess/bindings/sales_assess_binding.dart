import 'package:get/get.dart';

import '../controllers/sales_assess_controller.dart';

class SalesAssessBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAssessController>(
      () => SalesAssessController(),
    );
  }
}
