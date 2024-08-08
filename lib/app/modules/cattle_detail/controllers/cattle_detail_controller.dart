import 'package:common_utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/cattle.dart';
import '../../../models/cattle_event.dart';
import '../../../models/common_data.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/Log.dart';
import '../../../services/constant.dart';
import '../../../services/ex_string.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';

class CattleDetailController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  Cattle cattle = Get.arguments;

  // 是否加载中, 在[页面初始化]时触发
  var isLoading = true.obs;

  // 当前TabIndex, 0:基本信息, 1:生产记录
  RxInt currentIndex = 0.obs;

  List<String> tabTitles = ['基本信息', '生产记录', '育种信息'];

  // 更新顶部tab index
  void updatePageIndex(int index) {
    currentIndex.value = index;
    update();
  }

  /// 牛只公母类型: 1公牛, 2母牛,
  RxInt genderType = 1.obs;

  /// 设置公母类型: 1公牛, 2母牛
  void setGenderType(int gender) {
    genderType.value = gender;
    update();
  }

  //生长阶段
  late List szjdList;
  //品种
  late List pzList;
  //公母
  late List gmList;
  // 生产记录状态
  late List czztList;

  @override
  void onInit() {
    super.onInit();
    szjdList = AppDictList.searchItems('szjd') ?? [];
    pzList = AppDictList.searchItems('pz') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
    czztList = AppDictList.searchItems('czzt') ?? [];

    if (ObjectUtil.isEmpty(cattle)) {
      return;
    }

    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    getCattleTotalData();
  }

  Future<void> getCattleTotalData() async {
    if (cattle.id.isEmpty) {
      Toast.show('牛只id为空');
      return;
    }

    onLoadingChange(true);
    await getCattleCardData();
    await getCattleEventListData();
    onLoadingChange(false);
  }

  // 更新loading flag
  void onLoadingChange(bool showFlag) {
    isLoading.value = showFlag;
    update();
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

  // 公牛色块列表
  RxList<CommonData> bullColorSectionList = <CommonData>[].obs;

  // 母牛色块列表
  RxList<CommonData> cowColorSectionList = <CommonData>[].obs;

  Future<void> getCattleCardData() async {
    try {
      //接口参数
      Map<String, dynamic> mapParam = {
        "cowId": cattle.id,
      };
      debugPrint('-----> $mapParam');

      var response = await httpsClient.get(
          "/api/dashboard/statistics/cow/statistics",
          queryParameters: mapParam);

      Cattle cattleModel = Cattle.fromJson(response);

      // 数据适配
      setGenderType(cattle.gender);
      // genderType.value = cattle.gender;
      if (cattle.gender == 1) {
        bullColorSectionList.value = [
          CommonData(
              id: 0,
              name: '采精次数',
              value: ObjectUtil.isNotEmpty(cattleModel.semenCount)
                  ? cattleModel.semenCount.toString().orEmpty()
                  : Constant.placeholder,
              unit: '次'),
          CommonData(
              id: 1,
              name: '采精合格次数',
              value: ObjectUtil.isNotEmpty(cattleModel.qualifiedCount)
                  ? cattleModel.qualifiedCount.toString()
                  : Constant.placeholder,
              unit: '次'),
          CommonData(
              id: 2,
              name: '采精合格率',
              value: ObjectUtil.isNotEmpty(cattleModel.qualifiedRate)
                  ? cattleModel.qualifiedRate.toString().replaceAll('%', '')
                  : Constant.placeholder,
              unit: '%'),
          CommonData(
              id: 3,
              name: '上次采精',
              value: ObjectUtil.isNotEmpty(cattleModel.lastSemenDate)
                  ? cattleModel.lastSemenDate
                      .toString() // .replaceFirst('-', '\n')
                  : Constant.placeholder),
        ];
      } else {
        cowColorSectionList.value = [
          CommonData(
              id: 0,
              name: '已产胎次',
              value: cattle.calvNum.toString().orEmpty().isEmpty
                  ? Constant.placeholder
                  : cattle.calvNum.toString().orEmpty(),
              unit: '次'),
          CommonData(
              id: 1,
              name: '初生重',
              value: ObjectUtil.isNotEmpty(cattleModel.birthWeight)
                  ? cattleModel.birthWeight.toString()
                  : Constant.placeholder,
              unit: '千克'),
          // CommonData(
          //     id: 2,
          //     name: '窝均活仔2',
          //     value: ObjectUtil.isNotEmpty(cattleModel.calfLive)
          //         ? cattleModel.calfLive.toString()
          //         : Constant.placeholder,
          //     unit: '头'),
          CommonData(
              id: 3,
              name: '上次配种',
              value: ObjectUtil.isNotEmpty(cattleModel.lastMating)
                  ? cattleModel.lastMating.toString()
                  : Constant.placeholder),
          CommonData(
              id: 4,
              name: '上次孕检',
              value: ObjectUtil.isNotEmpty(cattleModel.lastPregcy)
                  ? cattleModel.lastPregcy.toString() //.replaceFirst('-', '\n')
                  : Constant.placeholder),
          CommonData(
              id: 5,
              name: '上次产犊',
              value: ObjectUtil.isNotEmpty(cattleModel.lastCalv)
                  ? cattleModel.lastCalv.toString() //.replaceFirst('-', '\n')
                  : Constant.placeholder),
          CommonData(
              id: 6,
              name: '空怀天数',
              value: ObjectUtil.isNotEmpty(cattleModel.nonantCount)
                  ? cattleModel.nonantCount.toString()
                  : Constant.placeholder,
              unit: '天'),
          CommonData(
              id: 7,
              name: '是否禁配',
              value: ObjectUtil.isNotEmpty(cattleModel.lastSemenDate)
                  ? cattleModel.isBan ?? false
                      ? '是'
                      : '否'
                  : Constant.placeholder),
        ];
      }
      update();
    } catch (error) {
      Toast.dismiss();
      Toast.show(error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }

  //
  int pageIndex = 1;
  int pageSize = 14;
  //
  bool hasMore = false;

  RxList<CattleEvent> items = <CattleEvent>[].obs;

  //刷新控件
  late EasyRefreshController refreshController;

  // 请求牛只[生产记录]列表
  Future<void> getCattleEventListData({bool isRefresh = true}) async {
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
        'CowId': cattle.id,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response =
          await httpsClient.get("/api/cowhistory", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<CattleEvent> modelList = [];
      for (var item in mapList) {
        CattleEvent model = CattleEvent.fromJson(item);
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
    } catch (error) {
      Toast.dismiss();
      Toast.show(error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  /// 公牛事件
  // 公牛 - 生成管理
  List<CommonData> productionManagementList4Bull = [
    // CommonData(id: 0, name: "转群", image: AssetsImages.icon4),
    //CommonData(id: 1, name: "调拨", image: AssetsImages.icon3),
    // CommonData(id: 3, name: "饲喂", image: AssetsImages.icon9),
    CommonData(id: 5, name: "淘汰", image: AssetsImages.icon5),
    CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
    CommonData(id: 7, name: "死亡", image: AssetsImages.icon6),
  ];
  // 公牛 - 繁殖管理
  List<CommonData> reproductiveManagementList4Bull = [
    CommonData(id: 4, name: "采精", image: AssetsImages.icon10),
  ];
  // 公牛 - 育种管理
  List<CommonData> breedingManagementList4Bull = [];
  // 公牛 - 健康管理
  List<CommonData> healthManagementList4Bull = [
    // CommonData(id: 2, name: "防疫", image: AssetsImages.icon24),
  ];

  /// 母牛事件
  // 母牛 - 生成管理
  List<CommonData> productionManagementList4Cow = [
    // CommonData(id: 0, name: "转群", image: AssetsImages.icon4),
    //CommonData(id: 1, name: "调拨", image: AssetsImages.icon3),
    // CommonData(id: 3, name: "饲喂", image: AssetsImages.icon9),
    CommonData(id: 5, name: "淘汰", image: AssetsImages.icon5),
    CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
    CommonData(id: 7, name: "死亡", image: AssetsImages.icon6),
  ];
  // 母牛 - 繁殖管理
  List<CommonData> reproductiveManagementList4Cow = [
    CommonData(id: 1, name: "发情", image: AssetsImages.icon11),
    CommonData(id: 4, name: "配种", image: AssetsImages.icon14),
    CommonData(id: 5, name: "孕检", image: AssetsImages.icon15),
    CommonData(id: 6, name: "产犊", image: AssetsImages.icon16),
    CommonData(id: 7, name: "断奶", image: AssetsImages.icon17),
  ];
  // 母牛 - 育种管理
  List<CommonData> breedingManagementList4Cow = [];
  // 母牛 - 健康管理
  List<CommonData> healthManagementList4Cow = [
    // CommonData(id: 2, name: "防疫", image: AssetsImages.icon24),
  ];
}
