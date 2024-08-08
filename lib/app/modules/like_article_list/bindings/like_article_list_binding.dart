import 'package:get/get.dart';

import '../controllers/like_article_list_controller.dart';

class LikeArticleListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LikeArticleListController>(
      () => LikeArticleListController(),
    );
  }
}
