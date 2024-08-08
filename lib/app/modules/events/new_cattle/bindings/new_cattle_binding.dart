import 'package:get/get.dart';

import '../controllers/new_cattle_controller.dart';

class NewCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewCattleController>(
      () => NewCattleController(),
    );
  }
}
