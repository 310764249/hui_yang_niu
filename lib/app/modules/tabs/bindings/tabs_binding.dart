import 'package:get/get.dart';

import '../controllers/tabs_controller.dart';
import '../../application/controllers/application_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../message/controllers/message_controller.dart';
import '../../mine/controllers/mine_controller.dart';
import '../../recipe/controllers/recipe_controller.dart';

class TabsBinding extends Bindings {
  //懒加载方式创建实例，只有在使用时才创建
  @override
  void dependencies() {
    Get.lazyPut<TabsController>(
      () => TabsController(),
    );
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<ApplicationController>(
      () => ApplicationController(),
    );
    // Get.lazyPut<MessageController>(
    //   () => MessageController(),
    // );
    //因为这个页面手动绑定的，所以不需要懒加载了
    // Get.lazyPut<MineController>(
    //   () => MineController(),
    // );
    Get.lazyPut<RecipeController>(
      () => RecipeController(),
    );
  }
}
