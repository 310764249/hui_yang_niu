import 'package:get/get.dart';

import '../controllers/inherent_detail_controller.dart';

class InherentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InherentDetailController>(
      () => InherentDetailController(),
    );
  }
}
