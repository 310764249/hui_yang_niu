import 'package:get/get.dart';

import '../controllers/buy_in_detail_controller.dart';

class BuyInDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyInDetailController>(
      () => BuyInDetailController(),
    );
  }
}
