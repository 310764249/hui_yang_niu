import 'package:get/get.dart';

import '../controllers/characters_detail_controller.dart';

class CharactersDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CharactersDetailController>(
      () => CharactersDetailController(),
    );
  }
}
