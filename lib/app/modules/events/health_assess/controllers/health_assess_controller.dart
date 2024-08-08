import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cow_batch.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/ex_string.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class HealthAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  HealthAssessEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController ageController = TextEditingController();
  TextEditingController cattleCountController = TextEditingController();
  TextEditingController calvCountController = TextEditingController();
  TextEditingController treatCountController = TextEditingController();
  TextEditingController illnessController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode ageNode = FocusNode();
  final FocusNode calvCountNode = FocusNode();
  final FocusNode illnessNode = FocusNode();
  final FocusNode treatCountNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(ageNode),
        KeyboardActionsHelper.getDefaultItem(calvCountNode),
        KeyboardActionsHelper.getDefaultItem(illnessNode),
        KeyboardActionsHelper.getDefaultItem(treatCountNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;


  // "类型"选中项: 默认第一项
  final chooseTypeIndex = 0.obs;
  // 当前选中的牛
  Cattle? selectedCow;
  // 耳号
  final codeString = ''.obs;
  
  // 防疫时间
  final assessTime = ''.obs;

  // 健康
  List healthAssessList = [];
  List<String> healthAssessNameList = [];
  int healthAssessId = -1;
  RxString healthAssess = ''.obs;

  void setSelectedCow(Cattle? cow){
    selectedCow = cow;
    // healthAssess.value = cow?.bodyStatus;
    ageController.text = "${cow?.ageOfDay ?? 0}";
    calvCountController.text = "${cow?.calvNum ?? 0}";
  }
  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }


  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();

    healthAssessList = AppDictList.searchItems('jkpg') ?? [];
    healthAssessNameList =
        List<String>.from(healthAssessList.map((item) => item['label']).toList());

    //首先处理传入参数
    handleArgument();
    Toast.dismiss();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async{
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is Cattle) {
      selectedCow = argument;
      updateCodeString(selectedCow?.code ?? '');
    } else if (argument is SimpleEvent) {
      Log.i('-- 健康评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = HealthAssessEvent.fromJson(argument.data);


      // 耳号
      codeString.value = event?.cowCode ?? '';
      selectedCow = await getCattleMoreData(event!.cowId!);
      // 评估时间
      assessTime.value = event?.date ?? '';
      // 健康
      healthAssessId = event?.state ?? -1;
      healthAssess.value = healthAssessList.firstWhere(
          (item) => int.parse(item['value']) == healthAssessId)['label'];

      ageController.text = event?.ageOfDay.toString() ?? '';
      calvCountController.text = event?.calvNum.toString() ?? '';
      illnessController.text = event?.illness ?? '';
      treatCountController.text = event?.treatCount.toString() ?? '';
      //填充备注
      remarkController.text = event?.remark ?? '';

      //更新
      update();
    }
  }

  //获取牛只详情
  //获取牛只详情
  Future<Cattle> getCattleMoreData(String cowId) async {
    try {
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      Cattle model = Cattle.fromJson(response);
      return Future.value(model);
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
      return Future.value();
    }
  }

  /// 提交表单数据
  Future<void> commitPreventionData() async {

     String? str;
      if (selectedCow == null) {
        str = '请选择牛只';
      }else if (ageController.text.isEmpty) {
        str = '请输入日龄';
      }else if (calvCountController.text.isEmpty) {
        str = '请输入胎次';
      }else if (illnessController.text.isEmpty) {
        str = '请输入历次疾病名称';
      }else if (treatCountController.text.isEmpty) {
        str = '请输入诊疗次数';
      }else if (healthAssessId == -1) {
        Toast.show('请选择健康评估');
      }else if (assessTime.value.isBlankEx()) {
        str = '请选择评估日期';
      }
      if(str != null && str.isNotEmpty){
        Toast.show(str);
        return;
      }

    try {
      Toast.showLoading(msg: "提交中...");

      //接口参数
      late Map<String, dynamic> mapParam;
      if (!isEdit.value) {
        //* 新增
        mapParam = {
          "cowId":  selectedCow?.id, // 个体
          "date": assessTime.value,
          "state": healthAssessId,
          "ageOfDay":int.parse(ageController.text),
          "calvNum":int.parse(calvCountController.text),
          "illness":illnessController.text,
          "treatCount":int.parse(treatCountController.text),
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      } else {
        //* 编辑
        mapParam = {
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '', //事件 ID
          'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
          "cowId":  selectedCow?.id, // 个体
          "date": assessTime.value,
          "state": healthAssessId,
          "ageOfDay":int.parse(ageController.text),
          "calvNum":int.parse(calvCountController.text),
          "illness":illnessController.text,
          "treatCount":int.parse(treatCountController.text),
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/healthAssess", data: mapParam)
          : await httpsClient.post("/api/healthAssess", data: mapParam);

      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (error) {
      Toast.dismiss();
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
}
