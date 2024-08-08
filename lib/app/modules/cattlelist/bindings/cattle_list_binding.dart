import 'package:get/get.dart';

import '../controllers/cattle_list_controller.dart';

class CattleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CattleListController>(
      () => CattleListController(),
    );
  }
}
