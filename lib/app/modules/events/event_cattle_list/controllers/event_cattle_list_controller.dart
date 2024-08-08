import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../models/cow_house.dart';
import '../../../../models/page_info.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/common_service.dart';
import '../../../../widgets/dict_list.dart';

/// 事件筛查牛只专用，与牛只列表无关！！！！！
class EventCattleListController extends GetxController {
  //传入的参数
  EventsCattleListArgument argument = Get.arguments;

  HttpsClient httpsClient = HttpsClient();
  //刷新控件
  late EasyRefreshController refreshController;
  //
  int pageIndex = 1;
  int pageSize = 15;
  //
  bool hasMore = false;

  // 搜索参数-耳号
  String cowCode = '';
  // 搜索参数-栋舍ID
  String cowHouseId = '';
  // 搜索参数-生长阶段1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  int growthStage = 0;
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
    {'value': 0, "label": '全部品种'}
  ];
  List typeNameList = [];
  int selectedTypeIndex = 0;
  RxString selectedTypeName = '全部品种'.obs;
  //公母列表
  List sexList = [
    {'value': 0, "label": '全部公母'}
  ];
  List sexNameList = [];
  int selectedSexIndex = 0;
  RxString selectedSexName = '全部公母'.obs;
  //状态列表
  List stateList = [
    {'value': 0, "label": '全部类型'}
  ];
  List stateNameList = [];
  int selectedStateIndex = 0;
  RxString selectedStateName = '全部类型'.obs;
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
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    //获取品种字典项
    List pzList = AppDictList.searchItems('pz') ?? [];
    typeList.addAll(pzList);
    typeNameList.addAll(typeList.map((item) => item['label']).toList());
    print(typeNameList);
    //获取公母字典项
    List gmList = AppDictList.searchItems('gm') ?? [];
    sexList.addAll(gmList);
    sexNameList.addAll(sexList.map((item) => item['label']).toList());
    print(sexNameList);
    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    stateList.addAll(szjdList);
    stateNameList.addAll(stateList.map((item) => item['label']).toList());
    print(stateNameList);

    //请求数据
    searchCowlist();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 点击更新index
  void selectIndex(index) {
    // Log.e('----> CattleListView index: $index');

    var tempList = <Cattle>[];
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
    selectItems.refresh();
    update();
  }

  void callRouter() {
    // print(controller.argument.routerStr);
    Get.toNamed(argument.routerStr, arguments: selectItems.first);
  }

  //请求牛只列表数据
  Future<void> searchCowlist({bool isRefresh = true}) async {
    //把选中的 index 转化为字典项里面的具体 value
    growthStage = selectedStateIndex == 0
        ? 0
        : int.parse(stateList[selectedStateIndex]['value']);
    kind = selectedTypeIndex == 0
        ? 0
        : int.parse(typeList[selectedTypeIndex]['value']);
    sex = selectedSexIndex == 0
        ? 0
        : int.parse(sexList[selectedSexIndex]['value']);
    cowHouseId =
        selectedHouseIndex == -1 ? '' : houseList[selectedHouseIndex].id;
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
        'Type': argument.type,
        'Code': cowCode,
        'CowHouseId': cowHouseId,
        'GrowthStage': growthStage == 0
            ? ''
            : growthStage, //这里 state 为 0 表示筛选条件为全部，设置为空字符串，提交表单时自动移除该 key-value
        'Kind': kind == 0 ? '' : kind,
        'Gender': sex == 0 ? '' : sex,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response =
          await httpsClient.get("/api/dashboard", queryParameters: para);

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
      update();
      // Toast.dismiss();
    } catch (error) {
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
