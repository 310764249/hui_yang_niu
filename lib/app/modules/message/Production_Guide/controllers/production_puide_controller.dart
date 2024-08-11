import 'dart:convert';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article_guide_model.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';

class ProductionGuideController extends GetxController {
  RxList<ArticleGuideModel> articleGuideList = <ArticleGuideModel>[].obs;

  final HttpsClient httpsClient = HttpsClient();

  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    //请求生产指南列表
    requestGuideList();
  }

  Future requestGuideList() async {
    try {
      var response = await httpsClient.get('/api/article/guidelist');

      Log.d(response.toString());
      List<Map<String, dynamic>> parsedJson = response.cast<Map<String, dynamic>>();

      for (var item in parsedJson) {
        ArticleGuideModel model = ArticleGuideModel.fromJson(item);
        articleGuideList.add(model);
      }
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
    }
    update();
  }
}
