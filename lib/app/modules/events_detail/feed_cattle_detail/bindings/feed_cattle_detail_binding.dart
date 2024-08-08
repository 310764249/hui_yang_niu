import 'package:get/get.dart';

import '../controllers/feed_cattle_detail_controller.dart';

class FeedCattleDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FeedCattleDetailController>(
      () => FeedCattleDetailController(),
    );
  }
}
