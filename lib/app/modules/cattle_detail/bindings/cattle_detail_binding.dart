import 'package:get/get.dart';

import '../controllers/cattle_detail_controller.dart';

class CattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CattleDetailController>(
      () => CattleDetailController(),
    );
  }
}
