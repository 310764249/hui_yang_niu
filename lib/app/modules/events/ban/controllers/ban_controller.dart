import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../models/cattle.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class BanController extends GetxController {
  //TODO: Implement BanController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  BanEvent? event;
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
  //开始时间
  final startTimeStr = ''.obs;
  //结束时间
  final endTimeStr = ''.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;
  // "禁配原因"可选项
  List reasonList = [];
  List<String> reasonNameList = [];
  String curReasonID = '';
  RxInt curReasonIndex = 0.obs;

  //给筛选列表限制条件
  List gmList = [];
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  @override
  void onInit() {
    super.onInit();

    //默认当前
    startTimeStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    endTimeStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项
    reasonList = AppDictList.searchItems('jpyy') ?? [];
    curReasonID = reasonList.isNotEmpty ? reasonList.first['value'] : '';
    reasonNameList =
        List<String>.from(reasonList.map((item) => item['label']).toList());
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
      event = BanEvent.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId!);
      //原因
      curReasonID = event!.reason.toString(); //提交数据
      curReasonIndex.value = AppDictList.findIndexByCode(
          reasonList, event!.reason.toString()); //显示选中项
      //开始时间
      updateTimeStr(event!.startDate);
      //结束时间
      updateEndTimeStr(event!.endDate ?? startTimeStr.value);
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

  //
  void updateTimeStr(String date) {
    startTimeStr.value = date;
    update();
  }

  //
  void updateEndTimeStr(String date) {
    endTimeStr.value = date;
    update();
  }

  // 更新原因
  void updatePass(int index) {
    curReasonID = reasonList[index]['value'];
    curReasonIndex.value = index;
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
    if (startTimeStr.value.isBefore(selectedCow.inArea)) {
      Toast.show('开始时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (startTimeStr.value.isBefore(selectedCow.birth)) {
      Toast.show('开始时间不能早于出生日期');
      return;
    }
    //时间不能小于入场日期
    if (endTimeStr.value.isBefore(selectedCow.inArea)) {
      Toast.show('结束时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (endTimeStr.value.isBefore(selectedCow.birth)) {
      Toast.show('结束时间不能早于出生日期');
      return;
    }
    //结束时间不能早于开始时间
    if (endTimeStr.value.isBefore(startTimeStr.value)) {
      Toast.show('结束时间不能早于开始时间');
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
        'startDate': startTimeStr.value, //必传 string 开始日期
        'endDate': endTimeStr.value, // string 截止日期
        'reason':
            int.parse(curReasonID), //必传 integer 禁配原因1：体况差；2：诊疗中（疾病）；3：待淘汰；4：其他；
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.post("/api/ban", data: para);
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
        'startDate': startTimeStr.value, //必传 string 开始日期
        'endDate': endTimeStr.value, // string 截止日期
        'reason':
            int.parse(curReasonID), //必传 integer 禁配原因1：体况差；2：诊疗中（疾病）；3：待淘汰；4：其他；
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/ban", data: para);
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
