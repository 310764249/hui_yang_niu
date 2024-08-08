import 'package:get/get.dart';

import '../controllers/feed_cattle_controller.dart';

class FeedCattleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedCattleController>(
      () => FeedCattleController(),
    );
  }
}
