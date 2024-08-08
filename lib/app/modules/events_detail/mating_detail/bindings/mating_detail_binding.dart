import 'package:get/get.dart';

import '../controllers/mating_detail_controller.dart';

class MatingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MatingDetailController>(
      () => MatingDetailController(),
    );
  }
}
