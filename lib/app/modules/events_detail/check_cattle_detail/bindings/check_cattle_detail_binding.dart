import 'package:get/get.dart';

import '../controllers/check_cattle_detail_controller.dart';

class CheckCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckCattleDetailController>(
      () => CheckCattleDetailController(),
    );
  }
}
