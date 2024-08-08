import 'package:get/get.dart';

import '../controllers/inbreeding_controller.dart';

class InbreedingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InbreedingController>(
      () => InbreedingController(),
    );
  }
}
