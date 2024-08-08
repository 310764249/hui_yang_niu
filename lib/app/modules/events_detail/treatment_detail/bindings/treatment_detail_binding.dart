import 'package:get/get.dart';

import '../controllers/treatment_detail_controller.dart';

class TreatmentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TreatmentDetailController>(
      () => TreatmentDetailController(),
    );
  }
}
