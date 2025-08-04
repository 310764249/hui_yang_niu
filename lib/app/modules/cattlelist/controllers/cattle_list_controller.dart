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
  List stateList = [];
  List stateNameList = [];
  List selectedStateIndex = [];
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

    //初始化下拉刷新控制器
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
    //
    if (argument != null) {
      //
      //获取生长阶段字典项
      List szjdList = AppDictList.searchItems('szjd') ?? [];
      //有传值就使用传值，否则使用默认值
      stateList.addAll(argument.szjdList ?? szjdList);
      stateNameList.addAll(stateList.map((item) => item['label']).toList());
      print(stateNameList);
      selectedStateIndex = List.generate(stateList.length, (index) => index);
    }

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    //获取品种字典项
    List pzList = AppDictList.searchItems('pz') ?? [];
    typeList.addAll(pzList);
    typeNameList.addAll(typeList.map((item) => item['label']).toList());
    //print(typeNameList);
    //获取公母字典项
    if (ObjectUtil.isEmpty(argument?.gmList)) {
      //print(argument.gmList);
      List gmList = AppDictList.searchItems('gm') ?? [];
      sexList.addAll(gmList);
      sexNameList.addAll(sexList.map((item) => item['label']).toList());
    } else {
      sexList = argument!.gmList!;
      //print(sexList);
      sexNameList.addAll(sexList.map((item) => item['label']).toList());
      selectedSexName.value = sexNameList.first;
    }
    //print(sexNameList);

    //请求数据
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

  //请求牛只列表数据
  Future<void> searchCowList({bool isRefresh = true}) async {
    //把选中的 index 转化为字典项里面的具体 value

    List stateValues = [];
    if (selectedStateIndex.isNotEmpty) {
      //把选择的 index 转为接口需要的 value
      for (int index in selectedStateIndex) {
        String value = stateList[index]['value'];
        stateValues.add(value);
      }
      growthStage = stateValues;
    } else {
      growthStage = [];
    }

    kind = selectedTypeIndex == 0 ? 0 : int.parse(typeList[selectedTypeIndex]['value']);
    if (ObjectUtil.isEmpty(argument?.gmList)) {
      sex = selectedSexIndex == 0 ? 0 : int.parse(sexList[selectedSexIndex]['value']);
    } else {
      sex = int.parse(sexList[selectedSexIndex]['value']);
    }
    cowHouseId = selectedHouseIndex == -1 ? '' : houseList[selectedHouseIndex].id;
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
        'Code': cowCode,
        'CowHouseId': cowHouseId,
        'GrowthStages': growthStage,
        'IsFilterInvalid': argument.isFilterInvalid,
        'Kind': kind == 0 ? '' : kind,
        'Gender': sex == 0 ? '' : sex,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response = await httpsClient.get("/api/cow", queryParameters: para);
      print(jsonEncode(response));
      PageInfo model = PageInfo.fromJson(response);
      // print(model.itemsCount);

      List mapList = model.list;
      List<Cattle> modelList = [];
      for (var item in mapList) {
        Cattle model = Cattle.fromJson(item);
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
