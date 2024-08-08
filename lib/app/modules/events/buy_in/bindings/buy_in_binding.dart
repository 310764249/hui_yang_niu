import 'package:get/get.dart';

import '../controllers/buy_in_controller.dart';

class BuyInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BuyInController>(
      () => BuyInController(),
    );
  }
}
