import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/raw_material.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../models/formula.dart';
import '../../network/httpsClient.dart';
import '../../services/Log.dart';

class RecipeVerifyController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  List gtlxList = [];
  List gtzlListHB = [];
  List gtzlListRS = [];
  List gtzlListYF = [];
  List rsyfList = [];

  //[{key: 880abf38-9c19-499b-b73e-72ed185838a8, label: 育肥牛, value: 4, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 1, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: 862a64f1-3c73-4956-9d04-994c2ca38a16, label: 青年妊娠母牛, value: 2, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 2, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: cbfa3876-d9bc-44c8-b264-3868790b4284, label: 妊娠母牛, value: 1, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 3, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: 0b5bcfaa-1c7e-41c7-a8c0-1b858e6df59f, label: 哺乳母牛, value: 3, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 4, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: f0b7a670-2d63-42e0-8f19-627edaac7859, label: 后备母牛, value: 5, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 5, disabled: false, dataType: null, isDeleted: false, children: null}]

  List<String> get labels => gtlxList.map((item) => item['label'].toString()).toList();

  String get currentLabel => currentItem['label'].toString();

  late Map<String, dynamic> currentItem;

  //显示牛只重量的牛只类型 育肥牛 青年妊娠母牛 后备母牛
  bool get showNuWeight =>
      currentItem['value'] == '4' || currentItem['value'] == '2' || currentItem['value'] == '5';

  //显示日增重的牛只类型 育肥牛 后备母牛
  bool get showNuDailyWeight => currentItem['value'] == '4' || currentItem['value'] == '5';

  //显示妊娠月份的牛只类型 青年妊娠母牛 妊娠母牛
  bool get showNuPregnancyMonth => currentItem['value'] == '2' || currentItem['value'] == '1';

  //显示哺乳月份的牛只类型 哺乳母牛
  bool get showNuBreastMonth => currentItem['value'] == '3';

  //当前选择牛只类型的体重
  List get nuWeight {
    if (showNuWeight) {
      //育肥牛
      if (currentItem['value'] == '4') {
        return gtzlListYF;
      }
      //青年妊娠母牛
      if (currentItem['value'] == '2') {
        return gtzlListRS;
      }
      //妊娠母牛
      if (currentItem['value'] == '5') {
        return gtzlListHB;
      }
    }
    return [];
  }

  Map<String, dynamic>? currentNuWeight;

  List<String> get nuWeightLabels => nuWeight.map((item) => item['label'].toString()).toList();

  String get nuWeightLabel => currentNuWeight?['label'] ?? '';

  //存栏输入
  TextEditingController countController = TextEditingController(text: "1");

  //当前选择的日增重
  String nuDailyWeight = '';

  //妊娠月份labels
  List<String> get rsyfLabels => rsyfList.map((item) => item['label'].toString()).toList();

  //选择的妊娠月份
  Map<String, dynamic>? currentRsyf;

  String get rsyfLabel => currentRsyf?['label'] ?? '';

  List<RawMaterial> rawMaterialList = [];

  //添加的粗饲料
  List<RawMaterial> addRawMaterialList = [];

  //添加的精饲料
  List<RawMaterial> addFeedRawMaterialList = [];

  //是否选择已有配方
  bool isSelectExistFormula = true;
  FormulaModel? formulaModelExist;

  //粗料总重量文本控制器
  TextEditingController czlzlController = TextEditingController(text: "0.0");
  //精料总重量文本控制器
  TextEditingController jzlzlController = TextEditingController(text: "0.0");

  /// 加法
  double add(double a, double b, {int precision = 2}) {
    double result = a + b;
    return double.parse(result.toStringAsFixed(precision));
  }

  /// 减法
  double sub(double a, double b, {int precision = 2}) {
    double result = a - b;
    return double.parse(result.toStringAsFixed(precision));
  }

  //验证配方的结果
  FormulaModel? formulaModel;
  ValueNotifier<bool> compareExpanded = ValueNotifier(true);

  @override
  void onInit() {
    super.onInit();
    gtlxList = AppDictList.searchItems('pfmb')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListHB =
        AppDictList.searchItems('gtzl-hb')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListRS =
        AppDictList.searchItems('gtzl-qnrs')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListYF =
        AppDictList.searchItems('gtzl-yf')?.where((item) => !item['isDeleted']).toList() ?? [];
    rsyfList = AppDictList.searchItems('rsyf')?.where((item) => !item['isDeleted']).toList() ?? [];
    debugPrint('gtlxList: $gtlxList');
    currentItem = gtlxList.first;
    getRawMaterialList();
  }

  //获取饲料列表
  Future<void> getRawMaterialList() async {
    try {
      var response = await httpsClient.get("/api/rawmaterial/getall");
      for (var item in response) {
        RawMaterial model = RawMaterial.fromJson(item);
        rawMaterialList.add(model);
      }
    } catch (_) {}
  }

  //验证配方
  Future<void> verifyRecipe() async {
    if (showNuWeight) {
      if (currentNuWeight == null) {
        Toast.show('请选择牛只重量');
        return;
      }
    }
    if (showNuDailyWeight) {
      if (nuDailyWeight.isEmpty) {
        Toast.show('请选择日增重');
        return;
      }
    }
    if (showNuPregnancyMonth) {
      if (currentRsyf == null) {
        Toast.show('请选择妊娠月份');
      }
    }
    if (countController.text.isEmpty || countController.text == '0') {
      Toast.show('请输入存栏数');
      return;
    }
    if (addRawMaterialList.isEmpty) {
      Toast.show('请添加原料');
      return;
    }
    try {
      List<RawMaterial> all = [...addRawMaterialList, ...addFeedRawMaterialList];
      var response = await httpsClient.post(
        "/api/formula/verifyformula",
        data: {
          'formulaType': 1,
          "individualCate": 0,
          "individualType": currentItem['value'],
          "weightType": currentNuWeight?['value'],
          "dailyGainWeight": nuDailyWeight.replaceAll('kg', ''),
          "calvingMonths": currentRsyf?['value'],
          "milkGrade": 0,
          "gestationMonths": currentRsyf?['value'],
          "roughages":
              all.where((e) => e.category == 1).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),

          "energyFeed":
              all.where((e) => e.category == 2 && e.type == 2).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && element.type == 3
          "proteinFeed":
              all.where((e) => e.category == 2 && e.type == 3).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && (element.type == 4 || element.type == 6
          "additives":
              all.where((e) => e.category == 2 && (e.type == 4 || e.type == 6)).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && element.type == 5
          "premix":
              all.where((e) => e.category == 2 && e.type == 5).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
        },
      );

      formulaModel = FormulaModel.fromJson(response);
      formulaModel?.cowCount = int.parse(countController.text);
      formulaModel?.formulaType = 1;
      update();
    } catch (e) {
      debugPrint('verifyRecipe error: $e');

      formulaModel = null;
      update();
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      Toast.show('验证配方失败');
    }
  }

  void currentCowType(value, int position) {
    currentItem = gtlxList[position];
    currentNuWeight = null;
    currentRsyf = null;
    nuDailyWeight = '';
    countController.text = '1';
    update();
  }

  void currentWeight(value, int position) {
    currentNuWeight = nuWeight[position];
    update();
  }

  void currentDailyWeight(value, int position) {
    nuDailyWeight = value;
    update();
  }

  void currentRsyfVoid(value, int position) {
    currentRsyf = rsyfList[position];
    update();
  }

  void removeRawMaterial(RawMaterial e) {
    addRawMaterialList.remove(e);
    update();
  }

  void removeFeedRawMaterial(RawMaterial e) {
    addFeedRawMaterialList.remove(e);
    checkJLWeight();
    update();
  }

  void addRawMaterial(RawMaterial showRawMaterialLabel) {
    addRawMaterialList.add(showRawMaterialLabel);
    checkCLWeight();
    update();
  }

  void addRawMaterialAll(List<RawMaterial> showRawMaterialLabel) {
    addRawMaterialList = [...addRawMaterialList, ...showRawMaterialLabel];
    checkCLWeight();
    update();
  }

  void addFeedRawMaterialAll(List<RawMaterial> showRawMaterialLabel) {
    addFeedRawMaterialList = [...addFeedRawMaterialList, ...showRawMaterialLabel];
    checkJLWeight();
    update();
  }

  //检查粗料总重量，如果重量小于当前输入的重量，则用总重量，反之不动
  checkCLWeight() {
    if (getTotalWeight(addRawMaterialList) > (num.tryParse(czlzlController.text) ?? 0.0)) {
      czlzlController.text = getTotalWeight(addRawMaterialList).toString();
    }
  }

  //检查精料总重量，如果重量小于当前输入的重量，则用总重量，反之不动
  checkJLWeight() {
    if (getTotalWeight(addFeedRawMaterialList) > (num.tryParse(jzlzlController.text) ?? 0.0)) {
      jzlzlController.text = getTotalWeight(addFeedRawMaterialList).toString();
    }
  }

  num getTotalWeight(List<RawMaterial> list) {
    num totalWeight = 0.0;
    for (var item in list) {
      totalWeight += item.verifyWeight;
    }
    return double.parse(totalWeight.toStringAsFixed(2));
  }

  void selectHaveFormula(bool value) {
    isSelectExistFormula = value;
    formulaModelExist = null;
    countController.text = '1';
    addRawMaterialList.clear();
    addFeedRawMaterialList.clear();
    formulaModel = null;
    czlzlController.text = '0.0';
    jzlzlController.text = '0.0';
    update();
  }

  void currentFormula(FormulaModel result) {
    debugPrint('currentFormula: ${result.roughages?[0].toJson()}');
    formulaModelExist = result;
    //更新携带的信息
    currentItem = gtlxList.firstWhereOrNull((e) => e['value'] == '${result.individualType}');
    currentNuWeight = nuWeight.firstWhereOrNull((e) => e['value'] == '${result.weightType}');
    currentRsyf = rsyfList.firstWhereOrNull((e) => e['value'] == '${result.gestationMonths}');
    nuDailyWeight = '${result.dailyGainWeight}kg';
    addRawMaterialList = [
      for (var element in result.roughages ?? []) RawMaterial.fromJson(element.toJson()),
    ];
    getFormulaItems(result.id ?? '');
    update();
  }

  //获取事件详情
  Future<void> getFormulaItems(String formulaId) async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get(
        "/api/formulaItems/getAll",
        queryParameters: {"formulaId": formulaId},
      );
      debugPrint('response: $response');
      Toast.dismiss();
      List<RawMaterial> modelList = [];
      for (var item in response) {
        RawMaterial model = RawMaterial.fromJson(item);
        model.verifyWeight = item['weight'];
        modelList.add(model);
      }
      addRawMaterialList = modelList.where((e) => e.isCruseFeed).toList();
      addFeedRawMaterialList = modelList.where((e) => !e.isCruseFeed).toList();
      czlzlController.text = getTotalWeight(addRawMaterialList).toString();
      jzlzlController.text = getTotalWeight(addFeedRawMaterialList).toString();
      update();
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
}
