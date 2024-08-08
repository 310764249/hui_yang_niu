import 'package:get/get.dart';

import '../controllers/select_cattle_detail_controller.dart';

class SelectCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectCattleDetailController>(
      () => SelectCattleDetailController(),
    );
  }
}
