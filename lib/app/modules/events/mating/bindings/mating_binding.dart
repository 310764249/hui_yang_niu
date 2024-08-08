import 'package:get/get.dart';

import '../controllers/mating_controller.dart';

class MatingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatingController>(
      () => MatingController(),
    );
  }
}
