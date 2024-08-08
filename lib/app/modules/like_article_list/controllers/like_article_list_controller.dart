import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:intellectual_breed/app/models/article.dart';

import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/dict_list.dart';

class LikeArticleListController extends GetxController {
  //TODO: Implement LikeArticleListController
  //传入的参数 类别1：点赞  2：收藏
  int? type = Get.arguments;
  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 10;
  //
  bool hasMore = false;
  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //刷新控件
  late EasyRefreshController refreshController;
  //当前列表
  RxList items = [].obs;

  //接口地址
  String url = '/api/tsan';
  //页面标题
  RxString title = '点赞'.obs;

  @override
  void onInit() {
    super.onInit();
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    //处理类型
    if (type == 1) {
      //点赞
      url = "/api/tsan";
      title.value = '点赞';
    } else if (type == 2) {
      //收藏
      url = "/api/favorites";
      title.value = '收藏';
    }
    //
    searchArticle();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //请数据
  Future<void> searchArticle({bool isRefresh = true}) async {
    try {
      //使用临时的页码，防止请求失败
      int tempPageIndex = pageIndex;
      if (isRefresh) {
        tempPageIndex = pageIndex = 1;
      } else {
        tempPageIndex++;
      }

      //接口参数
      Map<String, dynamic> para = {
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response = await httpsClient.get(url, queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List modelList = [];
      if (title == '点赞') {
        for (var item in mapList) {
          TsanModel model = TsanModel.fromJson(item);
          modelList.add(model);
        }
      } else {
        for (var item in mapList) {
          FavoriteModel model = FavoriteModel.fromJson(item);
          modelList.add(model);
        }
      }

      //更新页面数据
      if (isRefresh) {
        items.value = modelList; //下拉刷新
      } else {
        pageIndex++; //上拉加载请求成功后,真实的页码+1
        items.addAll(modelList); //上拉加载
      }
      //是否可以加载更多
      hasMore = items.length < model.itemsCount;
      isLoading.value = false;
      update();
    } catch (error) {
      isLoading.value = false;
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
