import 'package:get/get.dart';

import '../controllers/measurement_detail_controller.dart';

class MeasurementDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeasurementDetailController>(
      () => MeasurementDetailController(),
    );
  }
}
