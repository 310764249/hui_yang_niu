import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

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

class EnvironmentAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  PreventionEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController remarkController = TextEditingController();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;

  // 防疫时间
  final assessTime = ''.obs;

  // 环境
  List environmentAssessList = [];
  List<String> environmentAssessNameList = [];
  int environmentAssessId = -1;
  RxString environmentAssess = ''.obs;


  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();

    environmentAssessList = AppDictList.searchItems('hjpg') ?? [];
    environmentAssessNameList =
        List<String>.from(environmentAssessList.map((item) => item['label']).toList());


    //首先处理传入参数
    handleArgument();
    Toast.dismiss();
  }

  //处理传入参数
  void handleArgument() async{
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is SimpleEvent) {
      Log.i('-- 环境评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = PreventionEvent.fromJson(argument.data);


      // 评估时间
      assessTime.value = event?.date ?? '';
      // 环境
      environmentAssessId = event?.status ?? -1;
      environmentAssess.value = environmentAssessList.firstWhere(
          (item) => int.parse(item['value']) == event?.status)['label'];

      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
  }

  /// 提交表单数据
  Future<void> commitPreventionData() async {

      if (environmentAssessId == -1) {
        Toast.show('请选择环境评估');
        return;
      }
      if (assessTime.value.isBlankEx()) {
        Toast.show('请选择评估时间');
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
          "state": environmentAssessId,
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
          "state": environmentAssessId,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/environmentAssess", data: mapParam)
          : await httpsClient.post("/api/environmentAssess", data: mapParam);

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
