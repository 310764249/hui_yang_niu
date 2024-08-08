import 'package:get/get.dart';

import '../controllers/change_group_detail_controller.dart';

class ChangeGroupDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeGroupDetailController>(
      () => ChangeGroupDetailController(),
    );
  }
}
