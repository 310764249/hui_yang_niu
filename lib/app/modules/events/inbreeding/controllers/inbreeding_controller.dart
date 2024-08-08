import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';

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
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class InbreedingController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //编辑事件传入
  InBreedArgument? event;

  //输入框
  TextEditingController youngCodeController = TextEditingController(); //犊牛耳号
  TextEditingController weightController = TextEditingController(); //犊牛体重
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode youngCodeNode = FocusNode(); //犊牛耳号
  final FocusNode weightNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(youngCodeNode),
        KeyboardActionsHelper.getDefaultItem(weightNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  //母牛 筛选列表限制条件
  List gmList = [];
  //公牛 筛选列表限制条件
  List bullGmList = [];
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  //当前选中的牛
  Cattle? selectedCow;
  //母牛耳号
  final codeString = ''.obs;
  //当前选中的公牛
  Cattle? selectedBull;
  //公牛耳号
  final bullCodeString = ''.obs;

  //近交系数
  final coefficient = ''.obs;

  //时间
  final timesStr = ''.obs;

  @override
  void onInit() {
    super.onInit();
    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);

    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    gmList.removeWhere((item) => item['label'] == '公');
    //取出公母数组
    bullGmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    bullGmList.removeWhere((item) => item['label'] == '母');

    // 获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['3', '4']);

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
      updateCodeString(selectedCow!.code ?? '');
    } else if (argument is SimpleEvent) {
      //isEdit.value = true;
      //编辑
      event = InBreedArgument.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充母牛耳号
      updateCodeString(event?.cowCode ?? '');
      //填充公牛耳号
      updateBullCodeString(event?.maleCowCode ?? '');
      //近交系数
      coefficient.value = event?.coefficient.toString() ?? '';
      //填充时间
      updateTimeStr(event!.date);
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

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
    //请求近交测定
    getCoefficient();
  }

  // 更新 公牛耳号
  void updateBullCodeString(String value) {
    bullCodeString.value = value;
    update();
    //请求近交测定
    getCoefficient();
  }

  // 提交数据
  void requestCommit() async {
    //种牛
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('母牛耳号未获取,请选择');
      return;
    }
    if (ObjectUtil.isEmpty(bullCodeString.value)) {
      Toast.show('公牛耳号未获取,请选择');
      return;
    }
    if (ObjectUtil.isEmpty(coefficient.value)) {
      Toast.show('近交系数未获取');
      return;
    }
    //判断提交类型
    if (ObjectUtil.isEmpty(event)) {
      newAction();
    } else {
      if (argument is Cattle) {
        newAction();
      } else {
        editAction();
      }
    }
  }

  //新增事件
  void newAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'cowId': selectedCow!.id, // 母牛ID
        'maleCowId': selectedBull!.id, // 公牛ID
        'coefficient': coefficient.value, //
        'date': timesStr.value, // 时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/inbreedmeasure", data: para);
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
        'cowId': ObjectUtil.isEmpty(selectedCow) ? event!.cowId : selectedCow!.id, // 母牛ID
        'maleCowId': ObjectUtil.isEmpty(selectedBull)
            ? event!.maleCowId
            : selectedBull!.id, // 公牛ID
        'coefficient': coefficient.value, //必传 integer 数量
        'date': timesStr.value, //必传 string销售时间
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/inbreedmeasure", data: para);
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

  //请求近交测定
  Future<void> getCoefficient() async {
    if (ObjectUtil.isEmpty(codeString.value)) {
      return;
    }
    if (ObjectUtil.isEmpty(bullCodeString.value)) {
      return;
    }

    try {
      var response = await httpsClient.post(
        "/api/progeny/coefficient",
        data: {
          "paternalCowCode": bullCodeString.value,
          "maternalCowCode": codeString.value
        },
      );
      print('coefficient:$response');
      coefficient.value = response.toString();
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
