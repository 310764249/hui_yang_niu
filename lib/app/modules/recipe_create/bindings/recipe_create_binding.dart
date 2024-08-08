import 'package:get/get.dart';

import '../controllers/recipe_create_controller.dart';

class RecipeCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeCreateController>(
      () => RecipeCreateController(),
    );
  }
}
