import 'package:get/get.dart';

import '../controllers/action_message_list_controller.dart';

class ActionMessageListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ActionMessageListController>(
      () => ActionMessageListController(),
    );
  }
}
