import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';

import '../../../../models/cow_house.dart';
import '../../../../models/page_info.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/constant.dart';
import '../../../../services/storage.dart';
import '../../../../widgets/dict_list.dart';

class CattleHouseListController extends GetxController {
  //传入的参数 类别1：犊牛栋舍	；2：后备母牛栋舍	；3：公牛栋舍；
  int? type = Get.arguments;

  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 10;
  //
  bool hasMore = false;
  // 搜索参数-栋舍名称
  String houseName = '';

  //刷新控件
  late EasyRefreshController refreshController;

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //当前批次列表
  RxList<CowHouse> items = <CowHouse>[].obs;
  //已选批次数组
  RxList<CowHouse> selectItems = <CowHouse>[].obs;
  //上次选择的位置，单选模式
  int lastSelectIndex = -1;

  //类型
  List typeList = [];

  @override
  void onInit() {
    super.onInit();
    //
    // ssjdList = AppDictList.searchItems('pclb') ?? [];
    typeList = AppDictList.searchItems('dslx') ?? [];
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    searchCowHouse();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

// 点击更新index
  void selectIndex(index) {
    var tempList = <CowHouse>[];
    var tempSelList = selectItems.value;

    //单选
    for (int i = 0; i < items.length; i++) {
      if (i == index) {
        if (items[i].isSelected) {
          items[i].isSelected = false;
          //
          lastSelectIndex = -1;
          tempSelList.clear();
        } else {
          items[i].isSelected = true;
          lastSelectIndex = index;
          tempSelList.clear();
          tempSelList.add(items[i]);
        }
      } else {
        items[i].isSelected = false;
      }
      tempList.add(items[i]);
    }

    // print(tempList);
    //统一更新数据
    items.value = tempList;
    selectItems.value = tempSelList;
    update();
  }

  //请求轮播数据
  Future<void> searchCowHouse({bool isRefresh = true}) async {
    // Toast.showLoading();
    try {
      //使用临时的页码，防止请求失败
      int tempPageIndex = pageIndex;
      if (isRefresh) {
        tempPageIndex = pageIndex = 1;
      } else {
        tempPageIndex++;
      }

      String farmId = '';
      //获取当前选中养殖场的 farmId
      var res = await Storage.getData(Constant.selectFarmData);
      if (!ObjectUtil.isEmpty(res)) {
        farmId = res['id'] ?? '';
      }

      //接口参数
      Map<String, dynamic> para = {
        'Type': type ?? '',
        'FarmId': farmId,
        'Name': houseName,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response =
          await httpsClient.get("/api/cowhouse", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<CowHouse> modelList = [];
      for (var item in mapList) {
        CowHouse model = CowHouse.fromJson(item);
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
