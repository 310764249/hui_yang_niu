import 'package:get/get.dart';

import '../controllers/inherent_controller.dart';

class InherentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InherentController>(
      () => InherentController(),
    );
  }
}
