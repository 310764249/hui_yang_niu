import 'package:get/get.dart';

import '../controllers/check_cattle_controller.dart';

class CheckCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CheckCattleController>(
      () => CheckCattleController(),
    );
  }
}
