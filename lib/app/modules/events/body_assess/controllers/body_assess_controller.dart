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

class BodyAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  PreventionEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  // TextEditingController ribCountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  //
  final FocusNode ribCountNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(ribCountNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;

  // 数量
  RxInt ribCount = 0.obs;

  // 当前选中的牛
  Cattle? selectedCow;

  // 耳号
  final codeString = ''.obs;

  // 防疫时间
  final assessTime = ''.obs;

  // 体况
  List bodyAssessList = [];
  List<String> bodyAssessNameList = [];
  int bodyAssessId = -1;
  RxString bodyAssess = ''.obs;

  void setSelectedCow(Cattle? cow) {
    selectedCow = cow;
    // healthAssess.value = cow?.bodyStatus;
    bodyAssessId = cow?.bodyStatus ?? -1;
    Log.d(cow?.toJson().toString() ?? '***');
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
    argument = Get.arguments;
    bodyAssessList = AppDictList.searchItems('tkpg') ?? [];
    bodyAssessNameList = List<String>.from(bodyAssessList.map((item) => item['label']).toList());
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
    if (argument is Cattle) {
      selectedCow = argument;
      updateCodeString(selectedCow?.code ?? '');
    } else if (argument is SimpleEvent) {
      Log.i('-- 体况评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = PreventionEvent.fromJson(argument.data);

      // 耳号
      codeString.value = event?.cowCode ?? '';
      ribCount.value = event?.count ?? 0;
      selectedCow = await getCattleMoreData(event!.cowId!);
      // 评估时间
      assessTime.value = event?.date ?? '';
      // 体况
      bodyAssessId = event?.status ?? -1;
      bodyAssess.value = bodyAssessList.firstWhere((item) => int.parse(item['value']) == event?.status)['label'];

      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
  }

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
    } else if (ribCount.value == 0) {
      str = '请输入肋骨数量';
    } else if (bodyAssessId == -1) {
      str = '请选择体况';
    } else if (assessTime.value.isBlankEx()) {
      str = '请选择评估日期';
    }
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
          //'id': isEdit.value ? event?.id : '', //事件 ID
          //'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
          "cowId": selectedCow?.id ?? "",
          "date": assessTime.value,
          "count": ribCount.value,
          "state": bodyAssessId,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      } else {
        //* 编辑
        mapParam = {
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '', //事件 ID
          'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
          "cowId": selectedCow?.id ?? "",
          "date": assessTime.value,
          "count": ribCount.value,
          "state": bodyAssessId,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/bodyAssess", data: mapParam)
          : await httpsClient.post("/api/bodyAssess", data: mapParam);

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
