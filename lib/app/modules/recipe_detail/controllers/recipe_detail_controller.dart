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
  TextEditingController dialogRecipeInstructionController = TextEditingController();
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

  //配方目标
  List pfmbList = [];

  //品种
  List pzList = [];

  //原料分类
  List ylflList = [];

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
          dialogRecipeInstruction.value = dialogRecipeInstructionController.text;
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

  List getRawMaterialListByType(String type) {
    List targetList = [];
    switch (type) {
      case 'roughages':
        if (argument?.roughages?.isNotEmpty ?? false) {
          for (var element in argument!.roughages!) {
            targetList.add({
              "id": element.id,
              "demand": element.demand,
              "weight": element.weight,
              "de": element.de,
              "nEm": element.nEm,
              "nEg": element.nEg,
              "mj": element.mj,
              "mp": element.mp,
              "price": element.price,
              "variable": element.variable,
              "correlation": element.correlation,
              "referenceValues": element.referenceValues,
              // "ruleCode": element.ruleCode,
              // "ruleRemark": element.ruleRemark,
            });
          }
        }
        break;
      case 'energyFeed':
        if (argument?.energyFeed?.isNotEmpty ?? false) {
          for (var element in argument!.energyFeed!) {
            targetList.add({
              "id": element.id,
              "demand": element.demand,
              "weight": element.weight,
              "de": element.de,
              "nEm": element.nEm,
              "nEg": element.nEg,
              "mj": element.mj,
              "mp": element.mp,
              "price": element.price,
              "variable": element.variable,
              "correlation": element.correlation,
              "referenceValues": element.referenceValues,
              // "ruleCode": element.ruleCode,
              // "ruleRemark": element.ruleRemark,
            });
          }
        }
        break;
      case 'proteinFeed':
        if (argument?.proteinFeed?.isNotEmpty ?? false) {
          for (var element in argument!.proteinFeed!) {
            targetList.add({
              "id": element.id,
              "demand": element.demand,
              "weight": element.weight,
              "de": element.de,
              "nEm": element.nEm,
              "nEg": element.nEg,
              "mj": element.mj,
              "mp": element.mp,
              "price": element.price,
              "variable": element.variable,
              "correlation": element.correlation,
              "referenceValues": element.referenceValues,
              // "ruleCode": element.ruleCode,
              // "ruleRemark": element.ruleRemark,
            });
          }
        }
        break;
      case 'additives':
        if (argument?.additives?.isNotEmpty ?? false) {
          for (var element in argument!.additives!) {
            targetList.add({
              "id": element.id,
              "demand": element.demand,
              "weight": element.weight,
              "de": element.de,
              "nEm": element.nEm,
              "nEg": element.nEg,
              "mj": element.mj,
              "mp": element.mp,
              "price": element.price,
              "variable": element.variable,
              "correlation": element.correlation,
              "referenceValues": element.referenceValues,
              // "ruleCode": element.ruleCode,
              // "ruleRemark": element.ruleRemark,
            });
          }
        }
        break;
      case 'premix':
        if (argument?.premix?.isNotEmpty ?? false) {
          for (var element in argument!.premix!) {
            targetList.add({
              "id": element.id,
              "demand": element.demand,
              "weight": element.weight,
              "de": element.de,
              "nEm": element.nEm,
              "nEg": element.nEg,
              "mj": element.mj,
              "mp": element.mp,
              "price": element.price,
              "variable": element.variable,
              "correlation": element.correlation,
              "referenceValues": element.referenceValues,
              // "ruleCode": element.ruleCode,
              // "ruleRemark": element.ruleRemark,
            });
          }
        }
        break;
      default:
        break;
    }
    return targetList;
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
        "nutritionId": argument?.nutritionId,
        "name": formulaName,
        "individualCate": argument?.individualCate,
        "individualType": argument?.individualType,
        "weightType": argument?.weightType,
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
        "weight": argument?.weight,
        "price": argument?.price,

        "date": DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d),
        "description": dialogRecipeInstruction.value.trim(),
        "taboo": dialogTabooItem.value.trim(),
        "executor": UserInfoTool.nickName(),
        "remark": argument?.remark,
        "roughages": getRawMaterialListByType("roughages"),
        "energyFeed": getRawMaterialListByType("energyFeed"),
        "proteinFeed": getRawMaterialListByType("proteinFeed"),
        "additives": getRawMaterialListByType("additives"),
        "premix": getRawMaterialListByType("premix"),
      };
      // print('配方参数:$mapParam');
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
      Map<String, dynamic> mapParam = {"id": argument?.id, "rowVersion": argument?.rowVersion};
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
}
