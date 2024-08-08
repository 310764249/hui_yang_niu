import 'package:get/get.dart';

import '../controllers/die_cattle_detail_controller.dart';

class DieCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DieCattleDetailController>(
      () => DieCattleDetailController(),
    );
  }
}
