import 'package:get/get.dart';

import '../controllers/prevention_detail_controller.dart';

class PreventionDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PreventionDetailController>(
      () => PreventionDetailController(),
    );
  }
}
