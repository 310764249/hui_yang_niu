import 'package:get/get.dart';

import '../controllers/change_group_controller.dart';

class ChangeGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChangeGroupController>(
      () => ChangeGroupController(),
    );
  }
}
