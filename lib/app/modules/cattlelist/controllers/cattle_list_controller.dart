import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/cattle.dart';
import 'package:intellectual_breed/app/models/cow_house.dart';
import 'package:intellectual_breed/app/services/common_service.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';

import '../../../../route_utils/business_logger.dart';
import '../../../models/cattle_list_argu.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/toast.dart';

class CattleListController extends GetxController {
  //传入的参数
  CattleListArgument argument = Get.arguments;

  HttpsClient httpsClient = HttpsClient();

  //刷新控件
  late EasyRefreshController refreshController;

  //
  int pageIndex = 1;
  int pageSize = 21;

  // 是否加载中, 在[页面初始化]和[条件筛选]时触发
  RxBool isLoading = true.obs;

  // 启动loading
  void startLoading() {
    isLoading.value = true;
    update();
  }

  //
  bool hasMore = false;

  // 搜索参数-耳号
  String cowCode = '';

  // 搜索参数-栋舍ID
  String cowHouseId = '';

  // 搜索参数-生长阶段1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  List growthStage = [];

  // 搜索参数-品种1：安格斯；2：西门塔尔；3：利木赞；4：皮埃蒙特；5：夏洛莱牛；6：澳洲和牛；7：秦川牛；8：黄牛；
  int kind = 0;

  // 搜索参数-公/母
  int sex = 0;

  //当前牛只列表
  RxList<Cattle> items = <Cattle>[].obs;

  //已选牛只数组
  RxList<Cattle> selectItems = <Cattle>[].obs;

  //上次选择的位置，单选模式
  int lastSelectIndex = -1;

  //
  TextEditingController searchController = TextEditingController();

  //品种列表
  List typeList = [
    {'value': 0, "label": '全部品种'},
  ];
  List typeNameList = [];
  int selectedTypeIndex = 0;
  RxString selectedTypeName = '全部品种'.obs;

  //公母列表
  List sexList = [
    {'value': 0, "label": '全部公母'},
  ];
  List sexNameList = [];
  int selectedSexIndex = 0;
  RxString selectedSexName = '全部公母'.obs;

  //状态列表
  /// 状态列表
  List stateList = [];

  /// 状态名称列表（给 Picker 显示）
  List stateNameList = [];

  /// 已选中的状态 value（重点：不再存 index）
  List<String> selectedStateValues = [];

  /// 显示文本
  RxString selectedStateName = '类型'.obs;

  //栋舍列表
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = ['全部栋舍'];
  int selectedHouseIndex = -1;
  RxString selectedHouseName = '全部栋舍'.obs;

  //
  String farmId = '';

  @override
  void onInit() async {
    super.onInit();

    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

    /// 获取状态字典
    List szjdList = AppDictList.searchItems('szjd') ?? [];

    /// 使用传入状态或者默认状态
    stateList.addAll(argument.szjdList ?? szjdList);

    /// 名称列表
    stateNameList.addAll(stateList.map((item) => item['label']).toList());

    /// 默认全选（直接存 value）
    selectedStateValues = stateList.map<String>((e) => e['value'].toString()).toList();

    /// 栋舍列表
    houseList = await CommonService().requestCowHouse();

    houseNameList.addAll(houseList.map((item) => item.name).toList());

    /// 品种字典
    List pzList = AppDictList.searchItems('pz') ?? [];

    typeList.addAll(pzList);

    typeNameList.addAll(typeList.map((item) => item['label']).toList());

    /// 公母字典
    if (ObjectUtil.isEmpty(argument?.gmList)) {
      List gmList = AppDictList.searchItems('gm') ?? [];

      sexList.addAll(gmList);

      sexNameList.addAll(sexList.map((item) => item['label']).toList());
    } else {
      sexList = argument!.gmList!;

      sexNameList.addAll(sexList.map((item) => item['label']).toList());

      selectedSexName.value = sexNameList.first;
    }

    /// 请求数据
    searchCowList();
  }

  @override
  void onReady() {
    BusinessLogger.instance.logEnter('生产管理/牛只列表');
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    BusinessLogger.instance.logExit('生产管理/牛只列表');
  }

  // 点击更新index
  void selectIndex(index) {
    // Log.e('----> CattleListView index: $index');

    var tempList = <Cattle>[];
    var tempSelList = selectItems.value;

    if (argument!.single) {
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
    } else {
      //多选
      for (int i = 0; i < items.length; i++) {
        if (i == index) {
          items[i].isSelected = !items[i].isSelected;
          if (items[i].isSelected) {
            tempSelList.add(items[i]);
          } else {
            tempSelList.remove(items[i]);
          }
        }
        tempList.add(items[i]);
      }
    }

    // print(tempList);
    //统一更新数据
    items.value = tempList;
    selectItems.value = tempSelList;
    //强制刷新
    selectItems.refresh();
    update();
  }

  // 提交数据
  void requestDelete(Cattle cattle) async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {"id": cattle.id, "rowVersion": cattle.rowVersion};
      await httpsClient.delete("/api/cow", data: para);
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

  Future<void> searchCowList({bool isRefresh = true}) async {
    /// 直接使用 value
    growthStage = selectedStateValues;

    kind = selectedTypeIndex == 0 ? 0 : int.parse(typeList[selectedTypeIndex]['value']);

    if (ObjectUtil.isEmpty(argument?.gmList)) {
      sex = selectedSexIndex == 0 ? 0 : int.parse(sexList[selectedSexIndex]['value']);
    } else {
      sex = int.parse(sexList[selectedSexIndex]['value']);
    }

    cowHouseId = selectedHouseIndex == -1 ? '' : houseList[selectedHouseIndex].id;

    try {
      int tempPageIndex = pageIndex;

      if (isRefresh) {
        tempPageIndex = pageIndex = 1;
      } else {
        tempPageIndex++;
      }

      Map<String, dynamic> para = {
        'Code': cowCode,
        'CowHouseId': cowHouseId,

        /// 修复后的状态参数
        'GrowthStages': growthStage,

        'IsFilterInvalid': true,

        'Kind': kind == 0 ? '' : kind,

        'Gender': sex == 0 ? '' : sex,

        'PageIndex': tempPageIndex,

        'PageSize': pageSize,
      };

      print('请求参数: $para');

      var response = await httpsClient.get("/api/cow", queryParameters: para);

      print(jsonEncode(response));

      PageInfo model = PageInfo.fromJson(response);

      List mapList = model.list;

      List<Cattle> modelList = [];

      for (var item in mapList) {
        Cattle model = Cattle.fromJson(item);
        modelList.add(model);
      }

      if (isRefresh) {
        items.value = modelList;
      } else {
        pageIndex++;
        items.addAll(modelList);
      }

      hasMore = items.length < model.itemsCount;

      isLoading.value = false;

      update();
    } catch (error) {
      isLoading.value = false;

      if (error is ApiException) {
        Log.d('API Exception: ${error.toString()}');
      } else {
        Log.d('Other Exception: $error');
      }
    }
  }
}
