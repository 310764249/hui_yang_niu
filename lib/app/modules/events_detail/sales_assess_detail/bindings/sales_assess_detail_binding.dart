import 'package:get/get.dart';

import '../controllers/sales_assess_detail_controller.dart';

class SalesAssessDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SalesAssessDetailController>(
      () => SalesAssessDetailController(),
    );
  }
}
