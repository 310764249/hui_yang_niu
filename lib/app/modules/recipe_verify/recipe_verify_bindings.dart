import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/recipe_verify/recipe_verify_controller.dart';

class RecipeVerifyBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RecipeVerifyController>(() => RecipeVerifyController());
  }
}
