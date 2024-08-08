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

class BreedAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  PreventionEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController remarkController = TextEditingController();
  //
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


  // 当前选中的牛
  Cattle? selectedCow;
  // 耳号
  final codeString = ''.obs;

  // 个体栋舍Id
  late String? cowHouseId = '';
  // 个体栋舍
  late RxString? cowHouse = RxString('');

  // 防疫时间
  final assessTime = ''.obs;

  // 繁殖
  List breedAssessList = [];
  List<String> breedAssessNameList = [];
  int breedAssessId = -1;
  RxString breedAssess = ''.obs;

  void setSelectedCow(Cattle? cow){
    selectedCow = cow;
    // healthAssess.value = cow?.bodyStatus;
    breedAssessId = cow?.breedStatus ?? -1;
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

    breedAssessList = AppDictList.searchItems('fzpg') ?? [];
    breedAssessNameList =
        List<String>.from(breedAssessList.map((item) => item['label']).toList());


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
      Log.i('-- 繁殖评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = PreventionEvent.fromJson(argument.data);


      // 耳号
      codeString.value = event?.cowCode ?? '';
      selectedCow = await getCattleMoreData(event!.cowId!);
      // 评估时间
      assessTime.value = event?.date ?? '';
      // 繁殖
      breedAssessId = event?.status ?? -1;
      breedAssess.value = breedAssessList.firstWhere(
          (item) => int.parse(item['value']) == event?.status)['label'];

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

      if (selectedCow == null) {
        Toast.show('请选择牛只');
        return;
      }
      if (breedAssessId == -1) {
        Toast.show('请选择繁殖评估');
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
          "cowId": selectedCow?.id ?? "",
          "date": assessTime.value,
          "state": breedAssessId,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      } else {
        //* 编辑
        mapParam = {
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '',
          'rowVersion': isEdit.value ? event?.rowVersion : '',
          "cowId":  selectedCow?.id ?? "",
          "date": assessTime.value,
          "state": breedAssessId,
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/breedAssess", data: mapParam)
          : await httpsClient.post("/api/breedAssess", data: mapParam);

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
