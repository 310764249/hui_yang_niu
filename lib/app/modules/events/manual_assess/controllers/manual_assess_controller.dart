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

class ManualAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  ManualWorkEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController amountController = TextEditingController();
  TextEditingController employeeController = TextEditingController();
  TextEditingController postController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode amountNode = FocusNode();
  final FocusNode employeeNode = FocusNode();
  final FocusNode postCountNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(amountNode),
        KeyboardActionsHelper.getDefaultItem(employeeNode),
        KeyboardActionsHelper.getDefaultItem(postCountNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;

  // 时间
  final assessTime = ''.obs;

  // 人工
  List manualAssessList = [];
  List<String> manualAssessNameList = [];
  int manualAssessId = -1;
  RxString manualAssess = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();

    manualAssessList = AppDictList.searchItems('rglx') ?? [];
    manualAssessNameList = List<String>.from(manualAssessList.map((item) => item['label']).toList());

    //首先处理传入参数
    handleArgument();
    Toast.dismiss();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is SimpleEvent) {
      Log.i('-- 人工评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = ManualWorkEvent.fromJson(argument.data);

      // 评估时间
      assessTime.value = event?.date ?? '';
      // 人工
      manualAssessId = event?.type ?? -1;
      manualAssess.value = manualAssessList.firstWhere((item) => int.parse(item['value']) == manualAssessId)['label'];

      //填充备注
      amountController.text = event?.amount.toString() ?? '';
      employeeController.text = event?.employee ?? '';
      postController.text = event?.post ?? '';
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
    if (manualAssessId == -1) {
      str = "请选择人工类型";
    } else if (amountController.text.isEmpty) {
      str = "请输入费用";
    } else if (employeeController.text.isEmpty) {
      str = "请输入人员姓名";
    } else if (assessTime.value.isBlankEx()) {
      str = '请选择录入时间';
    } /*else if(postController.text.isEmpty){
      str = "请输入所在岗位";
    }*/
    if (str != null && str.isNotEmpty) {
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
          "date": assessTime.value,
          "type": manualAssessId,
          "amount": double.parse(amountController.text),
          "employee": employeeController.text,
          "post": postController.text,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      } else {
        //* 编辑
        mapParam = {
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '', //事件 ID
          'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本

          "date": assessTime.value,
          "type": manualAssessId,
          "amount": double.parse(amountController.text),
          "employee": employeeController.text,
          "post": postController.text,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/manualWork", data: mapParam)
          : await httpsClient.post("/api/manualWork", data: mapParam);

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
