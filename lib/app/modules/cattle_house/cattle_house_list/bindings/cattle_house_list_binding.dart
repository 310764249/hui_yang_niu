import 'package:get/get.dart';

import '../controllers/cattle_house_list_controller.dart';

class CattleHouseListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CattleHouseListController>(
      () => CattleHouseListController(),
    );
  }
}
