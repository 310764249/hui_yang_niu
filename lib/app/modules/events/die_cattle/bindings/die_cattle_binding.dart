import 'package:get/get.dart';

import '../controllers/die_cattle_controller.dart';

class DieCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DieCattleController>(
      () => DieCattleController(),
    );
  }
}
