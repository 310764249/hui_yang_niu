import 'package:get/get.dart';

import '../controllers/allot_cattle_detail_controller.dart';

class AllotCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AllotCattleDetailController>(
      () => AllotCattleDetailController(),
    );
  }
}
