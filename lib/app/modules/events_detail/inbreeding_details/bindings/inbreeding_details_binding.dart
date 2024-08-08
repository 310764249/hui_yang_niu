import 'package:get/get.dart';

import '../controllers/inbreeding_details_controller.dart';

class InbreedingDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InbreedingDetailsController>(
      () => InbreedingDetailsController(),
    );
  }
}
