import 'package:get/get.dart';

import '../controllers/cattle_edit_controller.dart';

class CattleEditBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CattleEditController>(
      () => CattleEditController(),
    );
  }
}
