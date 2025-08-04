import 'package:common_utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../route_utils/business_logger.dart';
import '../../../../models/cattle.dart';
import '../../../../models/notice.dart';
import '../../../../models/page_info.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class ActionMessageListController extends GetxController {
  final int typeParam = Get.arguments;

  /// 搜索类型:
  /// 201：未发情；202：发情未配；203：未孕检；204：未产犊；205：未淘汰；
  /// 401：待查情；402：待配种；403：待孕检；404：待产犊；405：待断奶；406：待淘汰；407：待销售；408：待防疫；409：待保健；
  var searchType = -1;

  List typeNameList = [];
  int selectedTypeIndex = 0;
  RxString selectedTypeName = '全部'.obs;

  /// 设置搜索类型
  void setSearchType(int typeParam) {
    // 初始化picker数据, 判断是从[生产任务]or[预警提醒]
    typeParam == 400 ? typeList.addAll(subtypeList1) : typeList.addAll(subtypeList2);
    typeNameList.addAll(typeList.map((item) => item['label']).toList());
    selectedTypeIndex = 0;
    selectedTypeName.value = typeNameList[selectedTypeIndex];
    update();
  }

  // 类型列表
  List typeList = [];
  // 生产任务
  List subtypeList1 = [
    {'value': -1, 'label': '全部'},
    {'value': 401, 'label': '待查情'},
    {'value': 402, 'label': '待配种'},
    {'value': 403, 'label': '待孕检'},
    {'value': 404, 'label': '待产犊'},
    {'value': 405, 'label': '待断奶'},
    {'value': 406, 'label': '待淘汰'},
    {'value': 407, 'label': '待销售'},
    {'value': 408, 'label': '待防疫'},
    {'value': 409, 'label': '待保健'},
  ];
  // 预警提醒
  List subtypeList2 = [
    {'value': -1, 'label': '全部'},
    {'value': 201, 'label': '未发情'},
    {'value': 202, 'label': '发情未配'},
    {'value': 203, 'label': '未孕检'},
    {'value': 204, 'label': '未产犊'},
    {'value': 205, 'label': '未淘汰'},
  ];

  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 16;
  //
  bool hasMore = false;

  //刷新控件
  late EasyRefreshController refreshController;

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //当前批次列表
  RxList<Notice> items = <Notice>[].obs;

  //生长阶段
  late List szjdList;
  //公母
  late List gmList;

  @override
  void onInit() {
    super.onInit();
    szjdList = AppDictList.searchItems('szjd') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
    //
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
    debugPrint("==> 任务消息列表type: $typeParam");
    setSearchType(typeParam);

    searchCowBatch();
  }

  String get getTypeName => typeParam == 400 ? '生产任务' : '生产指南';
  @override
  void onReady() {
    super.onReady();
    debugPrint('--onReady--${typeParam}');
    BusinessLogger.instance.logEnter('任务提醒/$getTypeName');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('--onClose--');
    BusinessLogger.instance.logExit('任务提醒/$getTypeName');
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
      var response = await httpsClient.get("/api/cow/$cowId");
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
  Future<void> searchCowBatch({bool isRefresh = true}) async {
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
        'Type': searchType != -1 ? searchType : null,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response = await httpsClient.get("/api/notice", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<Notice> modelList = [];
      for (var item in mapList) {
        Notice model = Notice.fromJson(item);
        modelList.add(model);
      }

      // 根据 category 过滤数据, 因为300和500都是统计类的数据
      if (typeParam == 200) {
        modelList.removeWhere((element) => element.category != 200);
      }
      if (typeParam == 400) {
        modelList.removeWhere((element) => element.category != 400);
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
