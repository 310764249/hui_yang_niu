import 'package:get/get.dart';

import '../controllers/knock_out_detail_controller.dart';

class KnockOutDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KnockOutDetailController>(
      () => KnockOutDetailController(),
    );
  }
}
