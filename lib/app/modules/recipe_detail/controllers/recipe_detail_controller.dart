import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../services/user_info_tool.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';
import '../../recipe/controllers/recipe_controller.dart';

class RecipeDetailController extends GetxController {
  //传入的参数
  FormulaModel? argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  // 弹窗输入框
  TextEditingController dialogFormulaNameController = TextEditingController();
  TextEditingController dialogRecipeInstructionController =
      TextEditingController();
  TextEditingController dialogTabooItemController = TextEditingController();

  final FocusNode dialogFormulaNameNode = FocusNode();
  final FocusNode dialogRecipeInstructionNode = FocusNode();
  final FocusNode dialogTabooItemNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(dialogFormulaNameNode),
        KeyboardActionsHelper.getDefaultItem(dialogRecipeInstructionNode),
        KeyboardActionsHelper.getDefaultItem(dialogTabooItemNode),
      ],
    );
  }

  RxString dialogFormulaName = ''.obs;
  RxString dialogRecipeInstruction = ''.obs;
  RxString dialogTabooItem = ''.obs;

  //当前列表
  RxList<FormulaItemModel> items = <FormulaItemModel>[].obs;

  //粗饲料
  List<FormulaItemModel> get roughages =>
      items.where((e) => e.type == 1).toList();

  //精饲料e.type不等于0和不等于1的.其他都是精饲料
  List<FormulaItemModel> get energyFeed =>
      items.where((e) => e.type != 0 && e.type != 1).toList();

  //配方目标
  List pfmbList = [];

  //品种
  List pzList = [];

  //原料分类
  List ylflList = [];

  bool get isFromCreate => argument?.id == null;

  @override
  void onInit() {
    super.onInit();

    //配方目标
    pfmbList = AppDictList.searchItems('pfmb') ?? [];
    pzList = AppDictList.searchItems('pz') ?? [];
    ylflList = AppDictList.searchItems('ylfl') ?? [];

    // 判断id是否为空, 如果不为空则是正常进详情, 否则就是从[创建配方]的页面调过来
    if (argument?.id != null) {
      // 原料列表
      getFormulaItems();
    } else {
      // 当argument的id为空时说明是从[创建配方]的页面调过来的
      dialogFormulaNameNode.addListener(() async {
        if (!dialogFormulaNameNode.hasFocus) {
          dialogFormulaName.value = dialogFormulaNameController.text;
          update();
        }
      });
      dialogRecipeInstructionNode.addListener(() async {
        if (!dialogRecipeInstructionNode.hasFocus) {
          dialogRecipeInstruction.value =
              dialogRecipeInstructionController.text;
          update();
        }
      });
      dialogTabooItemNode.addListener(() async {
        if (!dialogTabooItemNode.hasFocus) {
          dialogTabooItem.value = dialogTabooItemController.text;
          update();
        }
      });

      if (argument?.roughages?.isNotEmpty ?? false) {
        items.addAll(argument!.roughages!);
      }
      if (argument?.energyFeed?.isNotEmpty ?? false) {
        items.addAll(argument!.energyFeed!);
      }
      if (argument?.proteinFeed?.isNotEmpty ?? false) {
        items.addAll(argument!.proteinFeed!);
      }
      if (argument?.additives?.isNotEmpty ?? false) {
        items.addAll(argument!.additives!);
      }
      if (argument?.premix?.isNotEmpty ?? false) {
        items.addAll(argument!.premix!);
      }
    }

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

  //获取事件详情
  Future<void> getFormulaItems() async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get(
        "/api/formulaItems/getAll",
        queryParameters: {"formulaId": argument?.id},
      );
      debugPrint('response: $response');
      Toast.dismiss();
      List<FormulaItemModel> modelList = [];
      for (var item in response) {
        FormulaItemModel model = FormulaItemModel.fromJson(item);
        modelList.add(model);
      }
      print(modelList.length);
      items.value = modelList;
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

  List<FormulaItemModel> get _currentItems {
    if (items.isNotEmpty) return items.toList();
    return [
      ...?argument?.roughages,
      ...?argument?.energyFeed,
      ...?argument?.proteinFeed,
      ...?argument?.additives,
      ...?argument?.premix,
    ];
  }

  Map<String, dynamic> _itemPayload(
    FormulaItemModel item, {
    bool save = false,
  }) {
    final payload = <String, dynamic>{'id': item.id, 'weight': item.weight};
    if (save) {
      payload.addAll({
        'demand': item.demand,
        'de': item.de,
        'nEm': item.nEm,
        'nEg': item.nEg,
        'mj': item.mj,
        'mp': item.mp,
        'price': item.price,
        'variable': item.variable,
        'correlation': item.correlation,
        'referenceValues': item.referenceValues,
      });
    }
    return payload;
  }

  List<Map<String, dynamic>> getRawMaterialListByType(String type) {
    final matches = switch (type) {
      'roughages' => (FormulaItemModel item) => item.type == 1,
      'energyFeed' => (FormulaItemModel item) => item.type == 2,
      'proteinFeed' => (FormulaItemModel item) => item.type == 3,
      'additives' =>
        (FormulaItemModel item) => item.type == 4 || item.type == 6,
      'premix' => (FormulaItemModel item) => item.type == 5,
      _ => (FormulaItemModel item) => false,
    };
    return _currentItems
        .where(matches)
        .map((item) => _itemPayload(item, save: true))
        .toList();
  }

  Map<String, dynamic> _verificationPayload() {
    final current = _currentItems;
    return {
      // verifyformula expects the verification mode; keep the current
      // formulaType only for the local detail state after the response.
      'formulaType': 1,
      'cowCount': argument?.cowCount ?? 1,
      'individualCate': argument?.individualCate ?? 0,
      'individualType': argument?.individualType,
      'weightType': argument?.weightType,
      'dailyGainWeight': argument?.dailyGainWeight,
      'calvingMonths': argument?.calvingMonths,
      'milkProduction': argument?.milkProduction,
      'milkGrade': argument?.milkGrade ?? 0,
      'gestationMonths': argument?.gestationMonths,
      'roughages':
          current.where((item) => item.type == 1).map(_itemPayload).toList(),
      'energyFeed':
          current.where((item) => item.type == 2).map(_itemPayload).toList(),
      'proteinFeed':
          current.where((item) => item.type == 3).map(_itemPayload).toList(),
      'additives':
          current
              .where((item) => item.type == 4 || item.type == 6)
              .map(_itemPayload)
              .toList(),
      'premix':
          current.where((item) => item.type == 5).map(_itemPayload).toList(),
    };
  }

  /// Recalculate nutrition gaps immediately before opening the save dialog.
  Future<bool> refreshVerificationForSave() async {
    if (argument == null || argument?.id != null) return true;
    try {
      Toast.showLoading(msg: '营养成分检测中...');
      final response = await httpsClient.post(
        '/api/formula/verifyformula',
        data: _verificationPayload(),
      );
      final responseMap = Map<String, dynamic>.from(response);
      final previous = <String, dynamic>{...?argument?.toJson()}
        ..remove('gaps');
      final merged = <String, dynamic>{...previous, ...responseMap};
      final refreshed = FormulaModel.fromJson(merged);
      refreshed.cowCount = argument?.cowCount ?? refreshed.cowCount;
      refreshed.formulaType = argument?.formulaType ?? refreshed.formulaType;
      argument = refreshed;
      debugPrint(
        '[formula-save-check] verifyformula gaps=${refreshed.gaps?.map((gap) => gap.toJson()).toList()}',
      );
      update();
      Toast.dismiss();
      return true;
    } catch (error) {
      Toast.dismiss();
      Toast.show(error is ApiException ? error.message : '营养成分检测失败，请稍后重试');
      return false;
    }
  }

  /// 保存配方
  Future<void> saveFormula() async {
    String formulaName = dialogFormulaNameController.text.trim();
    if (formulaName.isEmpty) {
      Toast.show('请输入配方名称');
      return;
    }
    // if (dialogRecipeInstruction.value.trim().isEmpty) {
    //   Toast.show('请输入饲料说明');
    //   return;
    // }
    // if (dialogTabooItem.value.trim().isEmpty) {
    //   Toast.show('请输入禁忌事项');
    //   return;
    // }

    try {
      Toast.showLoading(msg: "配方保存中...");

      //接口参数
      Map<String, dynamic> mapParam = {
        'formulaType': argument?.formulaType,
        "nutritionId": argument?.nutritionId,
        "name": formulaName,
        "cowCount": argument?.cowCount ?? 1,
        "individualCate": argument?.individualCate,
        "individualType": argument?.individualType,
        "weightType": argument?.weightType,
        "dailyGainWeight": argument?.dailyGainWeight,
        "calvingMonths": argument?.calvingMonths,
        "milkProduction": argument?.milkProduction,
        "milkGrade": argument?.milkGrade,
        "gestationMonths": argument?.gestationMonths,
        "dm": argument?.dm,
        "ash": argument?.ash,
        "starch": argument?.starch,
        "fat": argument?.fat,
        "fibre": argument?.fibre,
        "ndf": argument?.ndf,
        "adf": argument?.adf,
        "cp": argument?.cp,
        "rdp": argument?.rdp,
        "rup": argument?.rup,
        "me": argument?.me,
        "mLys": argument?.mLys,
        "mMet": argument?.mMet,
        "de": argument?.de,
        "mj": argument?.mj,
        "rnd": argument?.rnd,
        "ca": argument?.ca,
        "p": argument?.p,
        "enable": true,

        "baseDM": argument?.baseDM,
        "baseAsh": argument?.baseAsh,
        "baseStarch": argument?.baseStarch,
        "baseFat": argument?.baseFat,
        "baseFibre": argument?.baseFibre,
        "baseNDF": argument?.baseNDF,
        "baseADF": argument?.baseADF,
        "baseCP": argument?.baseCP,
        "baseRDP": argument?.baseRDP,
        "baseRUP": argument?.baseRUP,
        "baseME": argument?.baseME,
        "baseMLys": argument?.baseMLys,
        "baseMMet": argument?.baseMMet,
        "baseDE": argument?.baseDE,
        "baseNEm": argument?.baseNEm,
        "nEm": argument?.nEm,
        "baseNEg": argument?.baseNEg,
        "nEg": argument?.nEg,
        "baseMJ": argument?.baseMJ,
        "baseMP": argument?.baseMP,
        "mp": argument?.mp,
        "baseCa": argument?.baseCa,
        "baseP": argument?.baseP,
        "baseRoughagesPercent": argument?.baseRoughagesPercent,
        "roughagesPercent": argument?.roughagesPercent,
        "weight": argument?.weight,
        "price": argument?.price,

        "date": DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d),
        "description": dialogRecipeInstruction.value.trim(),
        "taboo": dialogTabooItem.value.trim(),
        "executor": UserInfoTool.nickName(),
        "remark": argument?.remark,
        "gaps": argument?.gaps?.map((gap) => gap.toJson()).toList() ?? [],
        "roughages": getRawMaterialListByType("roughages"),
        "energyFeed": getRawMaterialListByType("energyFeed"),
        "proteinFeed": getRawMaterialListByType("proteinFeed"),
        "additives": getRawMaterialListByType("additives"),
        "premix": getRawMaterialListByType("premix"),
      };
      debugPrint('[formula-save] gaps=${mapParam['gaps']}');
      await httpsClient.post("/api/formula", data: mapParam);
      Toast.dismiss();
      Toast.success(msg: '配方保存成功');
      await Future.delayed(const Duration(seconds: 1));
      SmartDialog.dismiss();
      Get.back();
      Get.back();
      // Get.offUntil(
      //   MaterialPageRoute(builder: (context) => const TabsView()),
      //   (route) => route.isFirst, // 过滤条件，返回到第一个页面
      // );
      final recipeController = Get.find<RecipeController>();
      recipeController.refreshList();
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

  /// 删除配方
  Future<void> deleteFormula() async {
    try {
      Toast.showLoading(msg: "配方删除中...");
      //接口参数
      Map<String, dynamic> mapParam = {
        "id": argument?.id,
        "rowVersion": argument?.rowVersion,
      };
      await httpsClient.delete("/api/formula", data: mapParam);
      Toast.dismiss();
      Toast.success(msg: '配方删除成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
      final recipeController = Get.find<RecipeController>();
      recipeController.refreshList();
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

  ValueNotifier<bool> compareExpanded = ValueNotifier(false);

  void onTapCompare() {
    compareExpanded.value = !compareExpanded.value;
  }
}
