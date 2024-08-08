import 'package:get/get.dart';

import '../controllers/information_list_controller.dart';

class InformationListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationListController>(
      () => InformationListController(),
    );
  }
}
