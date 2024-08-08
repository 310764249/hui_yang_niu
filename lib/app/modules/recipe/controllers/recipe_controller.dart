import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/formula.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/dict_list.dart';

class RecipeController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 8;
  //
  bool hasMore = false;
  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //刷新控件
  late EasyRefreshController refreshController;
  //当前列表
  RxList<FormulaModel> items = <FormulaModel>[].obs;

  //配方目标
  List pfmbList = [];

  @override
  void onInit() {
    super.onInit();
    //初始化
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  // 刷新配方列表数据
  void refreshList() {
    searchFormula(isRefresh: true);
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('--onReady--');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('--onClose--');
  }

  //请求数据
  Future<void> searchFormula({bool isRefresh = true}) async {
    //配方目标
    pfmbList = AppDictList.searchItems('pfmb') ?? [];

    // Toast.showLoading();
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
      var response =
          await httpsClient.get("/api/formula", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<FormulaModel> modelList = [];
      for (var item in mapList) {
        FormulaModel model = FormulaModel.fromJson(item);
        modelList.add(model);
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
      // Toast.dismiss();
    } catch (error) {
      isLoading.value = false;
      // Toast.dismiss();
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
