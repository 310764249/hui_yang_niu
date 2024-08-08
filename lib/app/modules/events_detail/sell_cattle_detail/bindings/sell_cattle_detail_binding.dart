import 'package:get/get.dart';

import '../controllers/sell_cattle_detail_controller.dart';

class SellCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SellCattleDetailController>(
      () => SellCattleDetailController(),
    );
  }
}
