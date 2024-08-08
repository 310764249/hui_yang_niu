import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../models/cattle.dart';
import '../../../../models/simple_event.dart';
import '../../../../services/Log.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../network/httpsClient.dart';
import '../../../../network/apiException.dart';
import '../../../../services/ex_string.dart';

class UnBanController extends GetxController {
  //TODO: Implement UnBanController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  UnBanEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
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

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;
  //给筛选列表限制条件
  List gmList = [];
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  @override
  void onInit() {
    super.onInit();

    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除公
    gmList.removeWhere((item) => item['label'] == '公');
    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, [
      '3',
      '4',
      '7',
    ]);

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
      //任务事件
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = UnBanEvent.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId!);
      //时间
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

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 提交数据
  void requestCommit() async {
    //种牛
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('耳号未获取,请点击耳号选择');
      return;
    }
    //时间不能小于入场日期
    if (timesStr.value.isBefore(selectedCow.inArea)) {
      Toast.show('解禁时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('解禁时间不能早于出生日期');
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
        'cowId': codeString.value.isEmpty ? '' : selectedCow.id, // string 牛只编码
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 发情日期
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.post("/api/pick", data: para);
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
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 发情日期
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/pick", data: para);
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
