import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../models/cattle.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/toast.dart';

class CharactersController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //编辑事件传入
  CharactersArgument? event;
  //输入框
  TextEditingController dailyController = TextEditingController(); //日增重（g）
  TextEditingController usageController = TextEditingController(); //饲料利用率
  TextEditingController birthWeightController =
      TextEditingController(); //初生重（kg）
  TextEditingController weanWeightController =
      TextEditingController(); //断奶重（kg）
  TextEditingController weanWeightDayController =
      TextEditingController(); //断奶后日增重
  TextEditingController growUpWeightController = TextEditingController(); //成年体重
  TextEditingController pregnancyController = TextEditingController(); //受胎率
  TextEditingController calvRateController = TextEditingController(); //产犊率
  TextEditingController rateOfWeanController =
      TextEditingController(); //犊牛断奶成活率
  TextEditingController deadWeightController = TextEditingController(); //屠宰量
  TextEditingController fatThicknessController = TextEditingController(); //脂肪厚度
  TextEditingController eyeMuscleAreaController =
      TextEditingController(); //眼肌面积
  TextEditingController musclePhController = TextEditingController(); //肌肉PH
  TextEditingController muscleFatRateController =
      TextEditingController(); //肌肉脂肪率
  TextEditingController backfatThickController = TextEditingController(); //背膘厚度
  TextEditingController pureMeatRateController = TextEditingController(); //净肉率
  TextEditingController tendernessController = TextEditingController(); //嫩度
  TextEditingController waterHoldController = TextEditingController(); //系水力
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode dailyNode = FocusNode();
  final FocusNode usageNode = FocusNode();
  final FocusNode birthWeightNode = FocusNode(); //初生重（kg）
  final FocusNode weanWeightNode = FocusNode(); //断奶重（kg）
  final FocusNode weanWeightDayNode = FocusNode();
  final FocusNode growUpNode = FocusNode();
  final FocusNode pregnancyNode = FocusNode();
  final FocusNode calvRateNode = FocusNode();
  final FocusNode rateOfWeanNode = FocusNode();
  final FocusNode deadWeightNode = FocusNode();
  final FocusNode fatThicknessNode = FocusNode();
  final FocusNode eyeMuscleAreaNode = FocusNode();
  final FocusNode musclePhNode = FocusNode();
  final FocusNode muscleFatRateNode = FocusNode();
  final FocusNode backfatThickNode = FocusNode();
  final FocusNode pureMeatRateNode = FocusNode();
  final FocusNode tendernessNode = FocusNode();
  final FocusNode waterHoldNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(remarkNode),
        KeyboardActionsHelper.getDefaultItem(dailyNode),
        KeyboardActionsHelper.getDefaultItem(usageNode),
        KeyboardActionsHelper.getDefaultItem(birthWeightNode),
        KeyboardActionsHelper.getDefaultItem(weanWeightNode),
        KeyboardActionsHelper.getDefaultItem(weanWeightDayNode),
        KeyboardActionsHelper.getDefaultItem(growUpNode),
        KeyboardActionsHelper.getDefaultItem(pregnancyNode),
        KeyboardActionsHelper.getDefaultItem(calvRateNode),
        KeyboardActionsHelper.getDefaultItem(rateOfWeanNode),
        KeyboardActionsHelper.getDefaultItem(deadWeightNode),
        KeyboardActionsHelper.getDefaultItem(pureMeatRateNode),
        KeyboardActionsHelper.getDefaultItem(fatThicknessNode),
        KeyboardActionsHelper.getDefaultItem(backfatThickNode),
        KeyboardActionsHelper.getDefaultItem(eyeMuscleAreaNode),
        KeyboardActionsHelper.getDefaultItem(musclePhNode),
        KeyboardActionsHelper.getDefaultItem(muscleFatRateNode),
        KeyboardActionsHelper.getDefaultItem(tendernessNode),
        KeyboardActionsHelper.getDefaultItem(waterHoldNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;

  //肉色
  List<String> mealList = ['1', '2', '3', '4', '5'];
  RxInt curMealIndex = 0.obs;
  //大理石纹
  List<String> marbleList = ['1', '2', '3', '4', '5'];
  RxInt curMarbleIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //处理传入参数
    handleArgument();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    Toast.showLoading();
    if (argument is Cattle) {
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = CharactersArgument.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId);
      //填充内容
      dailyController.text =
          event!.dailyGain == 0 ? '' : event!.dailyGain.toString();
      usageController.text = event!.efficiencyOfFeed == 0
          ? ''
          : event!.efficiencyOfFeed.toString();
      birthWeightController.text =
          event!.birthWeight == 0 ? '' : event!.birthWeight.toString();
      weanWeightController.text =
          event!.weanWeight == 0 ? '' : event!.weanWeight.toString();
      growUpWeightController.text =
          event!.adultWeight == 0 ? '' : event!.adultWeight.toString();
      pregnancyController.text = event!.pregnancyRateOfBulls == 0
          ? ''
          : event!.pregnancyRateOfBulls.toString();
      calvRateController.text =
          event!.calvRate == 0 ? '' : event!.calvRate.toString();
      weanWeightDayController.text =
          event!.weanDailyGain == 0 ? '' : event!.weanDailyGain.toString();
      rateOfWeanController.text =
          event!.rateOfWean == 0 ? '' : event!.rateOfWean.toString();
      deadWeightController.text =
          event!.deadWeight == 0 ? '' : event!.deadWeight.toString();
      fatThicknessController.text =
          event!.fatThickness == 0 ? '' : event!.fatThickness.toString();
      eyeMuscleAreaController.text =
          event!.eyeMuscleArea == 0 ? '' : event!.eyeMuscleArea.toString();
      musclePhController.text =
          event!.musclePh == 0 ? '' : event!.musclePh.toString();
      muscleFatRateController.text =
          event!.muscleFatRate == 0 ? '' : event!.muscleFatRate.toString();
      tendernessController.text =
          event!.tenderness == 0 ? '' : event!.tenderness.toString();
      waterHoldController.text =
          event!.waterHold == 0 ? '' : event!.waterHold.toString();
      updateMeal(event!.fleshcolor - 1); //肉色 1-5级
      updateMarble(event!.marble - 1); //大理石纹 1-5级

      //填充时间
      //updateTimeStr(event!.created);
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
    Toast.dismiss();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  //肉色
  void updateMeal(int index) {
    curMealIndex.value = index;
    update();
  }

  //肉色
  void updateMarble(int index) {
    curMarbleIndex.value = index;
    update();
  }

  // 提交数据
  void requestCommit() async {
    //耳号
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('耳号未获取,请点击耳号选择');
      return;
    }
    if (ObjectUtil.isNotEmpty(musclePhController.text.trim())) {
      double ph = double.parse(musclePhController.text.trim());
      if (ph < 5.0 || ph > 7.0) {
        Toast.show('肌肉PH必须在5.0-7.0之间');
        return;
      }
    }

    //判断提交类型
    if (ObjectUtil.isEmpty(event)) {
      newAction();
    } else {
      editAction();
    }
  }

  //新增事件
  void newAction() async {
    Toast.showLoading();

    try {
      //接口参数
      Map<String, dynamic> para = {
        'cowId': codeString.value.isEmpty ? '' : selectedCow.id, // string 牛只编码
        'dailyGain': dailyController.text.trim(), //日增重
        'efficiencyOfFeed': usageController.text.trim(), //饲料利用率
        'birthWeight': birthWeightController.text.trim(), //出生重
        'weanWeight': weanWeightController.text.trim(), //断奶重
        'weanDailyGain': weanWeightDayController.text.trim(), //断奶后日增重
        'adultWeight': growUpWeightController.text.trim(), //成年体重
        'pregnancyRateOfBulls': pregnancyController.text.trim(), //受胎率
        'calvRate': calvRateController.text.trim(), //产犊率
        'rateOfWean': rateOfWeanController.text.trim(), //犊牛断奶成活率
        'deadWeight': deadWeightController.text.trim(), //屠宰量
        'fatThickness': fatThicknessController.text.trim(), //脂肪厚度
        'eyeMuscleArea': eyeMuscleAreaController.text.trim(), //眼肌面积
        'musclePh': musclePhController.text.trim(), //肌肉PH
        'muscleFatRate': muscleFatRateController.text.trim(), //肌肉脂肪率
        'backfatThickness': backfatThickController.text.trim(), //背膘厚度
        'pureMeatRate': pureMeatRateController.text.trim(), //纯肉率
        'fleshcolor': curMealIndex.value + 1, //肉色 1-5级
        'marble': curMarbleIndex.value + 1, //大理石纹
        'tenderness': tendernessController.text.trim(), //嫩度
        'waterHold': waterHoldController.text.trim(), //系水力
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      await httpsClient.post("/api/characterstats", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      Get.back();
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

  //编辑事件
  void editAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': event!.id, //事件 ID
        'rowVersion': event!.rowVersion, //事件行版本
        'cowId': codeString.value.isEmpty ? '' : selectedCow.id, // string 牛只编码
        'dailyGain': dailyController.text.trim(), //日增重
        'efficiencyOfFeed': usageController.text.trim(), //饲料利用率
        'birthWeight': birthWeightController.text.trim(), //出生重
        'weanWeight': weanWeightController.text.trim(), //断奶重
        'weanDailyGain': weanWeightDayController.text.trim(), //断奶后日增重
        'adultWeight': growUpWeightController.text.trim(), //成年体重
        'pregnancyRateOfBulls': pregnancyController.text.trim(), //受胎率
        'calvRate': calvRateController.text.trim(), //产犊率
        'rateOfWean': rateOfWeanController.text.trim(), //犊牛断奶成活率
        'deadWeight': deadWeightController.text.trim(), //屠宰量
        'fatThickness': fatThicknessController.text.trim(), //脂肪厚度
        'eyeMuscleArea': eyeMuscleAreaController.text.trim(), //眼肌面积
        'musclePh': musclePhController.text.trim(), //肌肉PH
        'muscleFatRate': muscleFatRateController.text.trim(), //肌肉脂肪率
        'fleshcolor': curMealIndex.value + 1, //肉色 1-5级
        'marble': curMarbleIndex.value + 1, //大理石纹
        'tenderness': tendernessController.text.trim(), //嫩度
        'waterHold': waterHoldController.text.trim(), //系水力
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/characterstats", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      Get.back();
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

  //获取牛只详情
  Future<void> getCattleMoreData(String cowId) async {
    try {
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      selectedCow = Cattle.fromJson(response);
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
