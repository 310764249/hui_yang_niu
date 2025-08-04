import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../route_utils/business_logger.dart';
import '../../../models/cow_batch.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';

/// 批次列表参数
class BatchListArgument {
  /// 是否选择后点击选择返回数据
  final bool goBack;

  /// 传入的参数 类别1：犊牛；2：育肥牛；3：引种牛；
  final int? type;

  BatchListArgument({required this.goBack, this.type});
}

class BatchListController extends GetxController {
  //传入的参数 类别1：犊牛；2：育肥牛；3：引种牛；
  BatchListArgument? argument = Get.arguments;

  //输入框
  /*
  TextEditingController searchController = TextEditingController();
  final FocusNode searchNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(searchNode),
      ],
    );
  }
  */

  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 10;
  //
  bool hasMore = false;
  // 搜索参数-批次号
  String BatchNo = '';

  //刷新控件
  late EasyRefreshController refreshController;

  //生长阶段 字典数组
  List ssjdList = [];

  //公母 字典数组
  List gmList = [];

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;
  //当前批次列表
  RxList<CowBatch> items = <CowBatch>[].obs;
  //已选批次数组
  RxList<CowBatch> selectItems = <CowBatch>[].obs;
  //上次选择的位置，单选模式
  int lastSelectIndex = -1;

  @override
  void onInit() {
    super.onInit();
    //
    ssjdList = AppDictList.searchItems('pclb') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
    //
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

    searchCowBatch();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('-- onReady 批次列表--');
    BusinessLogger.instance.logEnter('批次列表');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('-- onClose 批次列表--');
    BusinessLogger.instance.logExit('批次列表');
  }

  // 点击更新index
  void selectIndex(index) {
    var tempList = <CowBatch>[];
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

  // 删除数据
  void requestDelete(CowBatch batch) async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {"id": batch.id, "rowVersion": batch.rowVersion};
      await httpsClient.delete("/api/cowbatch", data: para);
      Toast.dismiss();
      Toast.success(msg: '删除成功');
      //
      refreshController.callRefresh();
    } catch (error) {
      Toast.dismiss();
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

  //请求数据
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
        'Type': argument?.type ?? '',
        'BatchNo': BatchNo,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response = await httpsClient.get("/api/cowbatch", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<CowBatch> modelList = [];
      for (var item in mapList) {
        CowBatch model = CowBatch.fromJson(item);
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
