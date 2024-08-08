import 'package:get/get.dart';

import '../controllers/select_cattle_controller.dart';

class SelectCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCattleController>(
      () => SelectCattleController(),
    );
  }
}
