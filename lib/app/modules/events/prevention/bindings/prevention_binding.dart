import 'package:get/get.dart';

import '../controllers/prevention_controller.dart';

class PreventionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreventionController>(
      () => PreventionController(),
    );
  }
}
