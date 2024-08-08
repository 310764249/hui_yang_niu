import 'package:get/get.dart';

import '../controllers/sell_cattle_controller.dart';

class SellCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellCattleController>(
      () => SellCattleController(),
    );
  }
}
