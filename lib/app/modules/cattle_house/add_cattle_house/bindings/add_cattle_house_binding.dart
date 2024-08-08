import 'package:get/get.dart';

import '../controllers/add_cattle_house_controller.dart';

class AddCattleHouseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCattleHouseController>(
      () => AddCattleHouseController(),
    );
  }
}
