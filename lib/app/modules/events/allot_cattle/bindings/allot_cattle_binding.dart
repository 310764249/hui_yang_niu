import 'package:get/get.dart';

import '../controllers/allot_cattle_controller.dart';

class AllotCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllotCattleController>(
      () => AllotCattleController(),
    );
  }
}
