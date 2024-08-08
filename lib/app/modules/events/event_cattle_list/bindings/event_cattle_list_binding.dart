import 'package:get/get.dart';

import '../controllers/event_cattle_list_controller.dart';

class EventCattleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EventCattleListController>(
      () => EventCattleListController(),
    );
  }
}
