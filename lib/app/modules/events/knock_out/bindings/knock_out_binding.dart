import 'package:get/get.dart';

import '../controllers/knock_out_controller.dart';

class KnockOutBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KnockOutController>(
      () => KnockOutController(),
    );
  }
}
