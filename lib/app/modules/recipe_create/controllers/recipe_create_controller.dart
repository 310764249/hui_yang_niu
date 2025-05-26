import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/formula.dart';
import '../../../models/raw_material.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../routes/app_pages.dart';
import '../../../services/Log.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';

class RecipeCreateController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  // 个体类型
  late List gtlxList;
  // 个体重量
  RxList gtzlList = [].obs;
  late List gtzlListHB;
  late List gtzlListRS;
  late List gtzlListBR;
  late List gtzlListYF;
  // 日增重目标
  late List rzzList;
  late List rzzListHB;
  late List rzzListYF;
  // 妊娠月份
  late List rsyfList;
  // 泌乳月份
  late List mryfList;
  // 泌乳量目标
  // late List mrlList;
  // 泌乳等级/优秀等级
  late List yxdjList;
  // 粗饲料
  late List<RawMaterial> cslList;
  // 精饲料
  late List<RawMaterial> jslList;
  // 能量饲料
  late List<RawMaterial> nlslList;
  // 蛋白饲料
  late List<RawMaterial> dbslList;
  // 添加剂
  late List<RawMaterial> tjjListTotal; // 存储所有的添加剂数据
  late List<RawMaterial> tjjList;
  // 预混料
  late List<RawMaterial> yhlListTotal; // 存储所有的预混料数据
  late List<RawMaterial> yhlList; // 根据条件过滤后的结果

  // 个体类型
  List gtlxNameList = [];
  int gtlxSelIndex = 0;
  RxString gtlxSelName = ''.obs;

  /// !定义一个个体类型的 value 变量, 根据这个变量去显示不同的Widget, 默认999
  /// !value含义: 1-生长母牛, 2-妊娠母牛, 3-哺乳母牛, 4-育肥牛, 999:默认无含义
  RxInt gtlxValue = 999.obs;

  // 个体重量
  RxList gtzlNameList = [].obs;
  int gtzlSelIndex = -1;
  RxString gtzlSelName = ''.obs;

  // 个体重量-后备
  List gtzlNameListHB = [];

  // 个体重量-妊娠
  List gtzlNameListRS = [];

  // 个体重量-哺乳
  List gtzlNameListBR = [];

  // 个体重量-育肥牛
  List gtzlNameListYF = [];

  // 更新个体类型
  void updateGtlxSelectedItems(value, int position) {
    // 更新类型value, 显示不同的布局
    gtlxValue.value = int.parse(gtlxList[position]['value']);

    gtlxSelIndex = position;
    gtlxSelName.value = gtlxNameList[position];

    // 更新个体重量类型数据
    updateGtzlListByType();
    // 初始化日增重下标, 因为不同个体类型对应的下标的值不一样
    initRzzSelIndex();
    // 过滤添加剂和预混料的数据, 因为有的数据是针对不同性别的牛
    updateYhlList();
    update();
  }

  /// 切换个体类型时触发[个体体重]类型的数据变化
  void updateGtzlListByType() {
    switch (gtlxValue.value) {
      case 1:
        // 生长/后备母牛
        gtzlList.value = gtzlListHB;
        gtzlNameList.value = gtzlNameListHB;
        break;
      case 2:
        // 妊娠母牛
        gtzlList.value = gtzlListRS;
        gtzlNameList.value = gtzlNameListRS;
        break;
      case 3:
        // 哺乳母牛
        gtzlList.value = gtzlListBR;
        gtzlNameList.value = gtzlNameListBR;
        break;
      case 4:
        // 育肥牛
        gtzlList.value = gtzlListYF;
        gtzlNameList.value = gtzlNameListYF;
        break;
      default:
        break;
    }
    // 切换了类型, 重置index
    gtzlSelIndex = -1;
    gtzlSelName.value = '';
  }

  // 初始化日增重下标, 因为不同个体类型对应的下标的值不一样
  void initRzzSelIndex() {
    rzzSelIndex = -1;
    rzzSelName.value = '';
  }

  /// 切换个体类型时更新预混料
  void updateYhlList() {
    switch (gtlxValue.value) {
      case 1 || 2 || 3:
        Log.d("- 切换类型123 -gtlxValue.value: ${gtlxValue.value}");
        // 母牛: 生长/后备母牛, 妊娠母牛, 哺乳母牛
        // 预混料 列表更新
        yhlNameList.clear();
        yhlList = yhlListTotal.where((element) => element.individualType == 2).toList();
        if (yhlList.isNotEmpty) {
          yhlNameList.addAll(yhlList.map((item) => item.name).toList());
        }

        // 添加剂 列表更新
        tjjNameList.clear();
        tjjList = tjjListTotal.where((element) => element.individualType == 2 || element.individualType == 0).toList();
        if (tjjList.isNotEmpty) {
          tjjNameList.addAll(tjjList.map((item) => item.name).toList());
        }
        break;
      default:
        Log.d("- 切换类型other -gtlxValue.value: ${gtlxValue.value}");
        // 公牛
        // 预混料 列表更新
        yhlNameList.clear();
        yhlList = yhlListTotal.where((element) => element.individualType == 1).toList();
        if (yhlList.isNotEmpty) {
          yhlNameList.addAll(yhlList.map((item) => item.name).toList());
        }

        // 添加剂 列表更新
        tjjNameList.clear();
        tjjList = tjjListTotal.where((element) => element.individualType == 1 || element.individualType == 0).toList();
        if (tjjList.isNotEmpty) {
          tjjNameList.addAll(tjjList.map((item) => item.name).toList());
        }
        break;
    }
    // 切换了类型, 重置index
    yhlSelIndex = -1;
    yhlSelName.value = '';
  }

  // 更新个体重量
  void updateGtzlSelectedItems(value, int position) {
    Log.i('==> 个体重量: $value, $position');
    gtzlSelIndex = position;
    gtzlSelName.value = gtzlNameList[position];
    debugPrint('==> 个体重量: ${gtzlSelName.value}');
    update();
  }

  // 动态数据:
  // 日增重目标 - 生长母牛
  // 妊娠月份 - 妊娠期母牛
  // 泌乳/哺乳月份 - 哺乳母牛
  // 泌乳量目标 - 哺乳母牛

  // 日增重目标
  List rzzNameList = [];
  List rzzNameListHB = [];
  List rzzNameListYF = [];
  int rzzSelIndex = -1;
  RxString rzzSelName = ''.obs;
  // 更新个体类型
  void updateRzzSelectedItems(value, int position) {
    rzzSelIndex = position;
    switch (gtlxValue.value) {
      case 1:
        rzzSelName.value = rzzNameListHB[position];
        break;
      case 2 || 3:
        rzzSelName.value = rzzNameList[position];
        break;
      case 4:
        rzzSelName.value = rzzNameListYF[position];
        break;
      default:
        return;
    }
    update();
  }

  // 预混料
  List yhlNameList = [];
  int yhlSelIndex = -1;
  RxString yhlSelName = ''.obs;
  // 更新个体类型
  void updateYhlSelectedItems(value, int position) {
    yhlSelIndex = position;
    yhlSelName.value = yhlNameList[position];
    update();
  }

  // 妊娠月份
  List rsyfNameList = [];
  int rsyfSelIndex = -1;
  RxString rsyfSelName = ''.obs;
  // 更新妊娠月份
  void updateRsyfSelectedItems(value, int position) {
    rsyfSelIndex = position;
    rsyfSelName.value = rsyfNameList[position];
    update();
  }

  // 泌乳月份
  List mryfNameList = [];
  int mryfSelIndex = -1;
  RxString mryfSelName = ''.obs;
  // 更新泌乳月份
  void updateMryfSelectedItems(value, int position) {
    mryfSelIndex = position;
    mryfSelName.value = mryfNameList[position];
    update();
  }

  // 泌乳量目标
  // List mrlNameList = [];
  // int mrlSelIndex = -1;
  // RxString mrlSelName = ''.obs;
  // 更新泌乳量目标
  // void updateMrlSelectedItems(value, int position) {
  //   mrlSelIndex = position;
  //   mrlSelName.value = mrlNameList[position];
  //   update();
  // }

  // 泌乳等级(优秀等级)
  // List yxdjNameList = [];
  // int yxdjSelIndex = -1;
  // RxString yxdjSelName = ''.obs;
  // // 更新泌乳等级(优秀等级)
  // void updateYxdjSelectedItems(value, int position) {
  //   yxdjSelIndex = position;
  //   yxdjSelName.value = yxdjNameList[position];
  //   update();
  // }

  /// 粗饲料
  List cslNameList = []; // 粗饲料名称总列表
  List cslSelectedNameList = []; // 已选粗饲料名称列表
  List<(int index, int? lowlimit)> cslSelectedIndexList = []; // 已选粗饲料下标列表, 从弹窗中选择后得到
  List cslSelectedObjList = []; // 已选粗饲料Obj列表, 用于api提交
  RxString cslSelectedDisplayNames = ''.obs; // 已选粗饲料组合起来的名称

  // 能量饲料
  List nlslNameList = []; // 名称总列表
  List nlslSelectedNameList = []; // 已选名称列表
  List nlslSelectedIndexList = []; // 已选下标列表, 从弹窗中选择后得到
  List nlslSelectedObjList = []; // 已选饲料Obj列表, 用于api提交
  RxString nlslSelectedDisplayNames = ''.obs; // 已选组合起来的名称

  // 蛋白饲料
  List dbslNameList = []; // 名称总列表
  List dbslSelectedNameList = []; // 已选名称列表
  List dbslSelectedIndexList = []; // 已选下标列表, 从弹窗中选择后得到
  List dbslSelectedObjList = []; // 已选饲料Obj列表, 用于api提交
  RxString dbslSelectedDisplayNames = ''.obs; // 已选组合起来的名称

  // 添加剂
  List tjjNameList = []; // 名称总列表
  List tjjSelectedNameList = []; // 已选名称列表
  List tjjSelectedIndexList = []; // 已选下标列表, 从弹窗中选择后得到
  List tjjSelectedObjList = []; // 已选添加剂Obj列表, 用于api提交
  RxString tjjSelectedDisplayNames = ''.obs; // 已选组合起来的名称

  // 粗饲料更新
  void updateCslSelectedItems(List<(int index, int? lowlimit)> selectedList) {
    cslSelectedNameList.clear();
    cslSelectedObjList.clear();
    cslSelectedIndexList = selectedList;
    if (selectedList.isNotEmpty) {
      for (var i = 0; i < selectedList.length; i++) {
        cslSelectedNameList.add(cslNameList[selectedList[i].$1]);
        cslSelectedObjList.add({
          "id": cslList[selectedList[i].$1].id,
          "variable": cslList[selectedList[i].$1].category,
          "correlation": 0,
          "referenceValues": 0,
          if (selectedList[i].$2 != null) "lowLimit": selectedList[i].$2
        });
      }
    }
    cslSelectedDisplayNames.value = cslSelectedNameList.join(',');
    debugPrint('==> $cslSelectedNameList');
    update();
  }

  // 能量饲料更新
  void updateNlslSelectedItems(List selectedList) {
    nlslSelectedNameList.clear();
    nlslSelectedObjList.clear();
    nlslSelectedIndexList = selectedList;
    if (selectedList.isNotEmpty) {
      for (var i = 0; i < selectedList.length; i++) {
        nlslSelectedNameList.add(nlslNameList[selectedList[i]]);
        nlslSelectedObjList.add({
          "id": nlslList[selectedList[i]].id,
          "variable": nlslList[selectedList[i]].category,
          "correlation": 0,
          "referenceValues": 0
        });
      }
    }
    nlslSelectedDisplayNames.value = nlslSelectedNameList.join(',');
    debugPrint('==> $nlslSelectedNameList');
    update();
  }

  // 蛋白饲料更新
  void updateDbslSelectedItems(List selectedList) {
    dbslSelectedNameList.clear();
    dbslSelectedObjList.clear();
    dbslSelectedIndexList = selectedList;
    if (selectedList.isNotEmpty) {
      for (var i = 0; i < selectedList.length; i++) {
        dbslSelectedNameList.add(dbslNameList[selectedList[i]]);
        dbslSelectedObjList.add({
          "id": dbslList[selectedList[i]].id,
          "variable": dbslList[selectedList[i]].category,
          "correlation": 0,
          "referenceValues": 0
        });
      }
    }
    dbslSelectedDisplayNames.value = dbslSelectedNameList.join(',');
    debugPrint('==> $dbslSelectedNameList');
    update();
  }

  // 添加剂更新
  void updateTjjSelectedItems(List selectedList) {
    tjjSelectedNameList.clear();
    tjjSelectedObjList.clear();
    tjjSelectedIndexList = selectedList;
    if (selectedList.isNotEmpty) {
      for (var i = 0; i < selectedList.length; i++) {
        tjjSelectedNameList.add(tjjNameList[selectedList[i]]);
        tjjSelectedObjList.add({
          "id": tjjList[selectedList[i]].id,
          "variable": tjjList[selectedList[i]].category,
          "correlation": 0,
          "referenceValues": 0
        });
      }
    }
    tjjSelectedDisplayNames.value = tjjSelectedNameList.join(',');
    debugPrint('==> $tjjSelectedNameList');
    update();
  }

  @override
  void onInit() {
    super.onInit();
    // 请求饲料列表
    getRawMaterialList();

    gtlxList = AppDictList.searchItems('pfmb')?.where((item) => !item['isDeleted']).toList() ?? [];
    // gtzlList = AppDictList.searchItems('gtzl') ?? [];
    gtzlListHB = AppDictList.searchItems('gtzl-hb')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListRS = AppDictList.searchItems('gtzl-rs')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListBR = AppDictList.searchItems('gtzl-br')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListYF = AppDictList.searchItems('gtzl-yf')?.where((item) => !item['isDeleted']).toList() ?? [];

    rzzList = AppDictList.searchItems('rzz')?.where((item) => !item['isDeleted']).toList() ?? [];
    rzzListHB = AppDictList.searchItems('rzz-hb')?.where((item) => !item['isDeleted']).toList() ?? [];
    rzzListYF = AppDictList.searchItems('rzz-yf')?.where((item) => !item['isDeleted']).toList() ?? [];
    rsyfList = AppDictList.searchItems('rsyf')?.where((item) => !item['isDeleted']).toList() ?? [];
    mryfList = AppDictList.searchItems('mryf')?.where((item) => !item['isDeleted']).toList() ?? [];
    // mrlList = AppDictList.searchItems('mrl') ?? [];
    yxdjList = AppDictList.searchItems('yxdj')?.where((item) => !item['isDeleted']).toList() ?? [];

    if (gtlxList.isNotEmpty) {
      gtlxNameList.addAll(gtlxList.map((item) => item['label']).toList());
    }
    // if (gtzlList.isNotEmpty) {
    //   gtzlNameList.addAll(gtzlList.map((item) => item['label']).toList());
    // }
    if (gtzlListHB.isNotEmpty) {
      gtzlNameListHB.addAll(gtzlListHB.map((item) => item['label']).toList());
    }
    if (gtzlListRS.isNotEmpty) {
      gtzlNameListRS.addAll(gtzlListRS.map((item) => item['label']).toList());
    }
    if (gtzlListBR.isNotEmpty) {
      gtzlNameListBR.addAll(gtzlListBR.map((item) => item['label']).toList());
    }
    if (gtzlListYF.isNotEmpty) {
      gtzlNameListYF.addAll(gtzlListYF.map((item) => item['label']).toList());
    }

    // Dynamic data
    if (rzzList.isNotEmpty) {
      rzzNameList.addAll(rzzList.map((item) => item['label']).toList());
    }
    // 后备(母)牛
    if (rzzListHB.isNotEmpty) {
      rzzNameListHB.addAll(rzzListHB.map((item) => item['label']).toList());
    }
    // 育肥牛
    if (rzzListYF.isNotEmpty) {
      rzzNameListYF.addAll(rzzListYF.map((item) => item['label']).toList());
    }
    if (rsyfList.isNotEmpty) {
      rsyfNameList.addAll(rsyfList.map((item) => item['label']).toList());
    }
    if (mryfList.isNotEmpty) {
      mryfNameList.addAll(mryfList.map((item) => item['label']).toList());
    }
    // if (mrlList.isNotEmpty) {
    //   mrlNameList.addAll(mrlList.map((item) => item['label']).toList());
    // }
    // if (yxdjList.isNotEmpty) {
    //   yxdjNameList.addAll(yxdjList.map((item) => item['label']).toList());
    // }

    update();
  }

  // 获取饲料列表
  Future<void> getRawMaterialList() async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get("/api/rawmaterial/getall");
      List<RawMaterial> modelList = [];
      for (var item in response) {
        RawMaterial model = RawMaterial.fromJson(item);
        modelList.add(model);
      }
      // print(modelList);
      cslList = modelList.where((element) => element.category == 1).toList();
      nlslList = modelList.where((element) => element.category == 2 && element.type == 2).toList();
      dbslList = modelList.where((element) => element.category == 2 && element.type == 3).toList();
      tjjListTotal = modelList.where((element) => element.category == 2 && (element.type == 4 || element.type == 6)).toList();
      yhlListTotal = modelList.where((element) => element.category == 2 && element.type == 5).toList();

      if (cslList.isNotEmpty) {
        cslNameList.addAll(cslList.map((item) => item.name).toList());
      }
      if (nlslList.isNotEmpty) {
        nlslNameList.addAll(nlslList.map((item) => item.name).toList());
      }
      if (dbslList.isNotEmpty) {
        dbslNameList.addAll(dbslList.map((item) => item.name).toList());
      }
      if (tjjListTotal.isNotEmpty) {
        tjjNameList.addAll(tjjListTotal.map((item) => item.name).toList());
      }
      if (yhlListTotal.isNotEmpty) {
        yhlNameList.addAll(yhlListTotal.map((item) => item.name).toList());
      }

      Toast.dismiss();
      update();
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

  /// 根据牛只类型获取目标重量
  int getWeightType() {
    var targetWeight = '0';
    switch (gtlxValue.value) {
      case 1:
        targetWeight = gtzlListHB[gtzlSelIndex]['value'];
        break;
      case 2:
        targetWeight = gtzlListRS[gtzlSelIndex]['value'];
        break;
      case 3:
        targetWeight = gtzlListBR[gtzlSelIndex]['value'];
        break;
      case 4:
        targetWeight = gtzlListYF[gtzlSelIndex]['value'];
        break;
    }
    Log.i("-- targetWeight: $targetWeight");
    return int.parse(targetWeight);
  }

  /// 生成配方
  Future<void> makeRecipe() async {
    switch (gtlxValue.value) {
      case 1 || 4:
        // 生长母牛 & 育肥牛
        if (gtzlSelIndex == -1) {
          Toast.show('请选择个体重量');
          return;
        }
        if (rzzSelIndex == -1) {
          Toast.show('请选择日增重目标');
          return;
        }
        break;
      case 2:
        // 妊娠母牛
        if (gtzlSelName.value.isEmpty) {
          Toast.show('请选择个体重量');
          return;
        }
        if (rsyfSelIndex == -1) {
          Toast.show('请选择妊娠月份');
          return;
        }
        break;
      case 3:
        // 哺乳母牛
        if (gtzlSelName.value.isEmpty) {
          Toast.show('请选择个体重量');
          return;
        }
        if (mryfSelIndex == -1) {
          Toast.show('请选择哺乳月份');
          return;
        }
        // if (mrlSelIndex == -1) {
        //   Toast.show('请选择泌乳量');
        //   return;
        // }
        // if (yxdjSelIndex == -1) {
        //   Toast.show('请选择泌乳等级');
        //   return;
        // }
        break;
      default:
        Toast.show('请选择配方目标牛只类型');
        return;
    }

    // 饲料判空
    if (cslSelectedObjList.isEmpty) {
      Toast.show('请选择粗饲料');
      return;
    }

    try {
      Toast.showLoading(msg: "配方生成中...");

      //接口参数
      Map<String, dynamic> mapParam = {
        "individualCate": 0, // Hardcode:0
        "individualType": gtlxValue.value, // 配方目标
        "weightType": getWeightType(), // 个体重量
        "dailyGainWeight": gtlxValue.value == 1
            ? double.parse(rzzListHB[rzzSelIndex]['value'])
            : (gtlxValue.value == 4 ? double.parse(rzzListYF[rzzSelIndex]['value']) : 0), // 每日增加重量
        "gestationMonths": gtlxValue.value == 2 ? int.parse(rsyfList[rsyfSelIndex]['value']) : 0, // 妊娠月份
        "calvingMonths": gtlxValue.value == 3 ? int.parse(mryfList[mryfSelIndex]['value']) : 0, // 泌乳月份
        // "milkProduction": gtlxValue.value == 3
        //     ? double.parse(mrlList[mrlSelIndex]['value'])
        //     : 0, // 泌乳量
        // "milkGrade": gtlxValue.value == 3
        //     ? int.parse(yxdjList[yxdjSelIndex]['value'])
        //     : 0, // 优秀等级
        "milkGrade": 0, // 优秀等级
        "roughages": cslSelectedObjList.isNotEmpty ? cslSelectedObjList : [], // 粗饲料
        "energyFeed": nlslSelectedObjList.isNotEmpty ? nlslSelectedObjList : [], // 能量饲料
        "proteinFeed": dbslSelectedObjList.isNotEmpty ? dbslSelectedObjList : [], // 蛋白饲料
        "additives": tjjSelectedObjList.isNotEmpty ? tjjSelectedObjList : [], // 添加剂
        "premix": yhlSelIndex != -1
            ? [
                {"id": yhlList[yhlSelIndex].id, "variable": yhlList[yhlSelIndex].category, "correlation": 0, "referenceValues": 0}
              ]
            : [] // 预混料
      };
      // print('配方参数:$mapParam');
      var response = await httpsClient.post("/api/formula/fabricated", data: mapParam);
      FormulaModel formulaModel = FormulaModel.fromJson(response);
      Toast.dismiss();
      Toast.success(msg: '配方生成成功');
      if (ObjectUtil.isNotEmpty(formulaModel)) {
        Get.toNamed(Routes.RECIPE_DETAIL, arguments: formulaModel);
      }
    } catch (error) {
      Toast.dismiss();
      Toast.failure(msg: error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }
}
