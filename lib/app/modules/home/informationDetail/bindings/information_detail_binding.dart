import 'package:get/get.dart';

import '../controllers/information_detail_controller.dart';

class InformationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InformationDetailController>(
      () => InformationDetailController(),
    );
  }
}
