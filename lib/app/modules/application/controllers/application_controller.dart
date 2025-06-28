import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/statistics.dart';

import '../../../models/common_data.dart';
import '../../../models/user_resource.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/Log.dart';
import '../../../services/constant.dart';
import '../../../services/storage.dart';
import '../../../widgets/dict_list.dart';

class ApplicationController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  // 牛只存栏统计列表
  final RxList<CommonData> cattleInventoryStatisticsList = [
    CommonData(id: 0, name: "母牛存栏", value: "0"),
    CommonData(id: 1, name: "公牛存栏", value: "0"),
    CommonData(id: 2, name: "犊牛存栏", value: "0"),
    CommonData(id: 3, name: "育肥牛存栏", value: "0"),
    CommonData(id: 4, name: "哺乳母牛\n存栏", value: "0"),
    CommonData(id: 5, name: "后备母牛\n存栏", value: "0"),
    CommonData(id: 6, name: "妊娠母牛\n存栏", value: "0"),
    CommonData(id: 7, name: "空怀母牛\n存栏", value: "0"),
  ].obs;

  // 任务统计列表
  final RxList<CommonData> taskStatisticsList = [
    CommonData(id: 0, name: "待查情数", value: "0"),
    CommonData(id: 1, name: "待配种数", value: "0"),
    CommonData(id: 2, name: "待孕检数", value: "0"),
    CommonData(id: 3, name: "待产犊数", value: "0"),
    CommonData(id: 4, name: "待断奶数", value: "0"),
    CommonData(id: 5, name: "待淘汰数", value: "0"),
    CommonData(id: 6, name: "待出栏数", value: "0"),
    CommonData(id: 7, name: "待防疫数", value: "0"),
    CommonData(id: 8, name: "待保健数", value: "0"),
    //CommonData(id: 9, name: "待诊疗数", value: "0"),
  ].obs;

  /// 1.生产管理
  RxList<CommonData> productionManagementList = <CommonData>[].obs;

  /// 生产管理 - 角色区分
  final List<CommonData> productionManagementList4FarmerType1 = [
    CommonData(id: 0, name: "引种", image: AssetsImages.icon1),
    CommonData(id: 1, name: "选种", image: AssetsImages.icon2),
    CommonData(id: 3, name: "转群", image: AssetsImages.icon4),
    CommonData(id: 4, name: "淘汰", image: AssetsImages.icon5),
    CommonData(id: 5, name: "死亡", image: AssetsImages.icon6),
    CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
    CommonData(id: 7, name: "盘点", image: AssetsImages.icon8),
  ];
  final List<CommonData> productionManagementList4FarmerType3 = [
    CommonData(id: 4, name: "淘汰", image: AssetsImages.icon5),
    CommonData(id: 5, name: "死亡", image: AssetsImages.icon6),
    CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
  ];

  /// 2.繁殖管理
  RxList<CommonData> reproductiveManagementList = <CommonData>[].obs;

  /// 繁殖管理 - 角色区分
  final List<CommonData> reproductiveManagementList4FarmerType1 = [
    CommonData(id: 0, name: "采精", image: AssetsImages.icon10),
    CommonData(id: 1, name: "发情", image: AssetsImages.icon11),
    CommonData(id: 4, name: "配种", image: AssetsImages.icon14),
    CommonData(id: 5, name: "孕检", image: AssetsImages.icon15),
    CommonData(id: 6, name: "产犊", image: AssetsImages.icon16),
    CommonData(id: 7, name: "断奶", image: AssetsImages.icon17),
  ];
  final List<CommonData> reproductiveManagementList4FarmerType3 = [
    CommonData(id: 1, name: "发情", image: AssetsImages.icon11),
    CommonData(id: 4, name: "配种", image: AssetsImages.icon14),
    CommonData(id: 5, name: "孕检", image: AssetsImages.icon15),
    CommonData(id: 6, name: "产犊", image: AssetsImages.icon16),
    CommonData(id: 7, name: "断奶", image: AssetsImages.icon17),
  ];

  /// 3.育种管理
  RxList<CommonData> breedingManagementList = <CommonData>[].obs;

  /// 育种管理 - 角色区分
  final List<CommonData> breedingManagementListFarmerType3 = [
    CommonData(id: 0, name: "后裔登记", image: AssetsImages.icon18),
    CommonData(id: 1, name: "性状统计", image: AssetsImages.icon22),
    CommonData(id: 2, name: "选育测定", image: AssetsImages.icon41),
    CommonData(id: 3, name: "体尺测定", image: AssetsImages.icon20),
    CommonData(id: 4, name: "品相评估", image: AssetsImages.icon21),
    CommonData(id: 5, name: "近交测定", image: AssetsImages.icon19),
    CommonData(id: 7, name: "育种值统计", image: AssetsImages.icon42),
  ];

  /// 4.健康管理
  RxList<CommonData> healthManagementList = <CommonData>[].obs;

  /// 健康管理 - 角色区分
  final List<CommonData> healthManagementList4FarmerType1 = [
    CommonData(id: 0, name: "防疫", image: AssetsImages.icon24),
    CommonData(id: 1, name: "诊疗", image: AssetsImages.icon25),
    CommonData(id: 2, name: "保健", image: AssetsImages.icon26),
  ];
  final List<CommonData> healthManagementList4FarmerType3 = [
    CommonData(id: 0, name: "防疫", image: AssetsImages.icon24),
    CommonData(id: 1, name: "诊疗", image: AssetsImages.icon25),
    CommonData(id: 2, name: "保健", image: AssetsImages.icon26),
  ];

  /// 5.物资管理
  RxList<CommonData> materialManagementList = <CommonData>[].obs;

  /// 6.养殖评估
  RxList<CommonData> breedingAssessmentList = <CommonData>[].obs;

  /// 7.效益评估
  RxList<CommonData> benefitAssessmentList = <CommonData>[].obs;

  void updateUIByPermission() async {
    var res = await Storage.getData(Constant.userResData);
    if (res != null) {
      UserResource resourceModel = UserResource.fromJson(res);

      debugPrint('==用户数据==刷新===type: ${resourceModel.farmerType}');
      // 用户类型（type）：type标识变量: 1:养殖户（农户散养、家庭农场、规模化养殖场）2：养殖户员工；98：系统用户(非业务用户，主要是研究所、畜牧站的人员)；99：平台用户（运维、开发使用） ；
      // 养殖户类型标识 farmerType:  1:规模化养殖场；2：家庭农场；3：农户散养；
      //! 注意下面在处理的时候没有的角色模块一定要给空[], 如果不处理的话角色切换后会有上个角色的缓存数据
      switch (3) {
        case 1: // 1 [规模场]
          productionManagementList.value = productionManagementList4FarmerType1;
          reproductiveManagementList.value = reproductiveManagementList4FarmerType1;
          breedingManagementList.value = [];
          healthManagementList.value = healthManagementList4FarmerType1;
          materialManagementList.value = [];
          breedingAssessmentList.value = [];
          benefitAssessmentList.value = [];

        case 3: //  3 是[农户]角色
          productionManagementList.value = productionManagementList4FarmerType3;
          reproductiveManagementList.value = reproductiveManagementList4FarmerType3;
          breedingManagementList.value = [];
          healthManagementList.value = healthManagementList4FarmerType3;
          materialManagementList.value = [];
          breedingAssessmentList.value = [];
          benefitAssessmentList.value = [];
          break;
      }

      // 是否散户
      bool isRetailer = resourceModel.farmerType == 3;

      // 生产管理
      productionManagementList.value = isRetailer
          ? [
              CommonData(id: 4, name: "淘汰", image: AssetsImages.icon5),
              CommonData(id: 5, name: "死亡", image: AssetsImages.icon6),
              CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
            ]
          : [
              CommonData(id: 0, name: "引种", image: AssetsImages.icon1),
              CommonData(id: 1, name: "选种", image: AssetsImages.icon2),
              CommonData(id: 2, name: "调拨", image: AssetsImages.icon3),
              CommonData(id: 3, name: "转群", image: AssetsImages.icon4),
              CommonData(id: 4, name: "淘汰", image: AssetsImages.icon5),
              CommonData(id: 5, name: "死亡", image: AssetsImages.icon6),
              CommonData(id: 6, name: "出栏", image: AssetsImages.icon7),
              CommonData(id: 7, name: "盘点", image: AssetsImages.icon8),
              CommonData(id: 8, name: "饲喂", image: AssetsImages.icon9),
            ];
      // 繁殖管理
      reproductiveManagementList.value = isRetailer
          ? [
              CommonData(id: 1, name: "发情", image: AssetsImages.icon11),
              CommonData(id: 4, name: "配种", image: AssetsImages.icon14),
              CommonData(id: 5, name: "孕检", image: AssetsImages.icon15),
              CommonData(id: 6, name: "产犊", image: AssetsImages.icon16),
              CommonData(id: 7, name: "断奶", image: AssetsImages.icon17),
            ]
          : [
              CommonData(id: 0, name: "采精", image: AssetsImages.icon10),
              CommonData(id: 1, name: "发情", image: AssetsImages.icon11),
              // CommonData(id: 2, name: "禁配", image: AssetsImages.icon12),
              // CommonData(id: 3, name: "解禁", image: AssetsImages.icon13),
              CommonData(id: 4, name: "配种", image: AssetsImages.icon14),
              CommonData(id: 5, name: "孕检", image: AssetsImages.icon15),
              CommonData(id: 6, name: "产犊", image: AssetsImages.icon16),
              CommonData(id: 7, name: "断奶", image: AssetsImages.icon17),
            ];
      // 育种管理 【家庭农场】去掉大功能育种管理，其他不变
      bool isHomeFarm = resourceModel.farmerType == 2;
      breedingManagementList.value = isHomeFarm || isRetailer
          ? []
          : [
              CommonData(id: 0, name: "后裔登记", image: AssetsImages.icon18),
              CommonData(id: 1, name: "性状统计", image: AssetsImages.icon22),
              CommonData(id: 2, name: "选育测定", image: AssetsImages.icon41),
              CommonData(id: 3, name: "体尺测定", image: AssetsImages.icon20),
              CommonData(id: 4, name: "品相评估", image: AssetsImages.icon21),
              CommonData(id: 5, name: "近交测定", image: AssetsImages.icon19),
              // CommonData(id: 4, name: "遗传评估", image: AssetsImages.icon22),
              CommonData(id: 6, name: "异常近交列表", image: AssetsImages.icon23),
              CommonData(id: 7, name: "育种值统计", image: AssetsImages.icon42),
            ];

      // 健康管理
      healthManagementList.value = [
        CommonData(id: 0, name: "防疫", image: AssetsImages.icon24),
        CommonData(id: 1, name: "诊疗", image: AssetsImages.icon25),
        CommonData(id: 2, name: "保健", image: AssetsImages.icon26),
      ];
      // 物资管理
      materialManagementList.value = isRetailer
          ? []
          : [
              CommonData(id: 0, name: "入库", image: AssetsImages.icon27),
              CommonData(id: 1, name: "领用", image: AssetsImages.icon28),
              CommonData(id: 2, name: "报废", image: AssetsImages.icon29),
              // CommonData(id: 3, name: "盘存", image: AssetsImages.icon30),
              // CommonData(id: 4, name: "物资耗用明细", image: AssetsImages.icon31),
            ];
      // 养殖评估
      breedingAssessmentList.value = isRetailer
          ? []
          : [
              CommonData(id: 0, name: "体况评估", image: AssetsImages.icon32),
              CommonData(id: 1, name: "健康评估", image: AssetsImages.icon33),
              CommonData(id: 2, name: "环境评估", image: AssetsImages.icon34),
              //CommonData(id: 3, name: "异常评估", image: AssetsImages.icon35),
              CommonData(id: 4, name: "繁殖效率评估", image: AssetsImages.icon36),
            ];
      // 效益评估
      benefitAssessmentList.value = [
        CommonData(id: 0, name: "采购", image: AssetsImages.icon37),
        CommonData(id: 1, name: "人工", image: AssetsImages.icon38),
        CommonData(id: 2, name: "销售", image: AssetsImages.icon7),
        // CommonData(id: 3, name: "效益分析", image: AssetsImages.icon39),
        // CommonData(id: 4, name: "收支设置", image: AssetsImages.icon40),
      ];
      update();
    } else {
      debugPrint('xx 权限错误 xx');
    }
  }

  //业务统计
  void requestBasicStatistics() async {
    try {
      //print("----------/api/user/resource--------");
      var response = await httpsClient.get("/api/dashboard/basicstatistics");
      Map<String, dynamic> liveStock = response['liveStock'];
      Map<String, dynamic> productionTask = response['productionTask'];
      Map<String, dynamic> earlyWarning = response['earlyWarning'];
      //牛只存栏统计
      LiveStockStatistics liveStockModel = LiveStockStatistics.fromJson(liveStock);
      cattleInventoryStatisticsList.value = [
        CommonData(id: 0, name: "母牛存栏", value: liveStockModel.female.toString()),
        CommonData(id: 1, name: "公牛存栏", value: liveStockModel.male.toString()),
        CommonData(id: 2, name: "犊牛存栏", value: liveStockModel.calf.toString()),
        CommonData(id: 3, name: "育肥牛存栏", value: liveStockModel.adult.toString()),
        CommonData(id: 4, name: "哺乳母牛\n存栏", value: liveStockModel.lactation.toString()),
        CommonData(id: 5, name: "后备母牛\n存栏", value: liveStockModel.reserve.toString()),
        CommonData(id: 6, name: "妊娠母牛\n存栏", value: liveStockModel.gestation.toString()),
        CommonData(id: 7, name: "空怀母牛\n存栏", value: liveStockModel.nonpregnant.toString()),
      ];
      //任务统计
      ProductionTaskStatistics productionTaskModel = ProductionTaskStatistics.fromJson(productionTask);
      taskStatisticsList.value = [
        CommonData(id: 0, name: "待查情数", value: productionTaskModel.checkLove.toString()),
        CommonData(id: 1, name: "待配种数", value: productionTaskModel.mating.toString()),
        CommonData(id: 2, name: "待孕检数", value: productionTaskModel.pregcy.toString()),
        CommonData(id: 3, name: "待产犊数", value: productionTaskModel.calv.toString()),
        CommonData(id: 4, name: "待断奶数", value: productionTaskModel.wean.toString()),
        CommonData(id: 5, name: "待淘汰数", value: productionTaskModel.weedOut.toString()),
        CommonData(id: 6, name: "待出栏数", value: productionTaskModel.market.toString()),
        CommonData(id: 8, name: "待保健数", value: productionTaskModel.healthCare.toString()),
        CommonData(id: 7, name: "待防疫数", value: productionTaskModel.antidemic.toString()),
      ];

      update();
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  void updateSzjdListFiltered() {
    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, [
      '11',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9',
      '10',
    ]);
  }
}
