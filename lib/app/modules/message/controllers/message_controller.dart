import 'package:common_utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cattle.dart';
import '../../../models/notice.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';

class MessageController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 14;
  //
  bool hasMore = false;
  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //刷新控件
  late EasyRefreshController refreshController;
  //当前列表
  RxList<Notice> items = <Notice>[].obs;

  //生长阶段
  List szjdList = [];
  //公母
  List gmList = [];

  void initCacheList() {
    if (szjdList.isEmpty) {
      szjdList = AppDictList.searchItems('szjd') ?? [];
    }
    if (gmList.isEmpty) {
      gmList = AppDictList.searchItems('gm') ?? [];
    }
  }

  @override
  void onInit() {
    super.onInit();
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('-- Message controller onReady --');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('-- Message controller onClose --');
  }

  //牛只详情
  Cattle? cattle;
  //获取牛只详情
  Future<void> getCattleDataAndGoToEventDetail(int type, String? cowId) async {
    if (ObjectUtil.isEmpty(cowId)) {
      Toast.show('牛只编号不能为空');
      return;
    }
    try {
      Toast.showLoading();
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      cattle = Cattle.fromJson(response);
      Toast.dismiss();
      if (ObjectUtil.isNotEmpty(cattle)) {
        Cattle.redirectToPage(type, cattle!);
      }
    } catch (error) {
      Toast.dismiss();
      Toast.show(error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //请求轮播数据
  Future<void> getMessageList({bool isRefresh = true}) async {
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
          await httpsClient.get("/api/notice", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<Notice> modelList = [];
      for (var item in mapList) {
        Notice model = Notice.fromJson(item);
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
