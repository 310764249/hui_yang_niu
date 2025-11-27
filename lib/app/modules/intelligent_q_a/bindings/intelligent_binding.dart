import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/intelligent_q_a/controllers/intelligent_controller.dart';

class IntelligentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<IntelligentController>(() => IntelligentController());
  }
}
