import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';
import 'package:intellectual_breed/app/models/simple_event.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../../models/cattle.dart';
import '../../../../models/cow_batch.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../models/cow_batch.dart';
import '../../../../models/cow_house.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/common_service.dart';
import '../../../../services/constant.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../network/apiException.dart';
import '../../../../services/Log.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class KnockOutController extends GetxController {
  //TODO: Implement KnockOutController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  KnockOutEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  TextEditingController countController = TextEditingController();
  TextEditingController columnController = TextEditingController(); //栏位
  TextEditingController remarkController = TextEditingController();
  // TextEditingController sourceController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode columnNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(columnNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  // "类型"可选项
  List chooseTypeList = [];
  List<String> chooseTypeNameList = [
    '种牛',
    '犊牛/育肥牛',
  ];
  // "类型"选中项: 默认第一项
  final chooseTypeIndex = 0.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;
  //当前选中的批次模型
  late CowBatch selectedCowBatch;
  //批次号
  final batchNumber = ''.obs;
  //数量
  final countNum = 0.obs;

  // "淘汰原因"可选项
  List reasonList = [];
  List<String> reasonNameList = [];
  String curReasonID = '';
  final reasonIndex = 0.obs;

  //时间
  final timesStr = ''.obs;
  //备注
  String remarkStr = '';

  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  @override
  void onInit() {
    super.onInit();

    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //原因
    reasonList = AppDictList.searchItems('ttyy') ?? [];
    curReasonID = reasonList.isNotEmpty ? reasonList.first['value'] : '';
    reasonNameList =
        List<String>.from(reasonList.map((item) => item['label']).toList());

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered =
        AppDictList.findMapByCode(szjdList, ['3', '4', '5', '6', '7']);

    //首先处理传入参数
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
      event = KnockOutEvent.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号/批次号
      if (ObjectUtil.isEmpty(event?.batchNo)) {
        updateChooseTypeIndex(0);
        updateCodeString(event?.cowCode ?? '');
        //获取牛只详情
        await getCattleMoreData(event!.cowId!);
      } else if (ObjectUtil.isEmpty(event?.cowCode)) {
        updateChooseTypeIndex(1);
        updateBatchNumber(event?.batchNo ?? '');
        //获取批次详情
        await getBatchMoreData(event!.batchNo!);
      }
      //填充数量
      countController.text = event!.count == 0 ? '' : event!.count.toString();
      //填充原因
      curReasonID = event!.cause.toString(); //提交数据
      reasonIndex.value = AppDictList.findIndexByCode(
          reasonList, event!.cause.toString()); //显示选中项
      //填充时间
      updateSeldate(event!.date);
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

  // 更新"当前状态"选中项
  void updateChooseTypeIndex(int index) {
    chooseTypeIndex.value = index;
    if (index == 0) {
      //选择种牛，清空 犊牛的填写数据
      batchNumber.value = '';
    } else {
      //选择犊牛，清空种牛的填写数据
      codeString.value = '';
      countController.text = '';
    }
    update();
  }

  // 时间
  void updateSeldate(String date) {
    timesStr.value = date;
    update();
  }

  // 更新 批次号
  void updateBatchNumber(String value) {
    batchNumber.value = value;
    update();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  // 更新选择原因
  void updateCurReason(int index) {
    curReasonID = reasonList[index]['value'];
    reasonIndex.value = index;
    update();
  }

  // 提交数据
  void requestCommit() {
    if (chooseTypeIndex.value == 0) {
      //种牛
      if (ObjectUtil.isEmpty(codeString.value)) {
        Toast.show('耳号未获取,请点击耳号选择');
        return;
      }
      //时间不能小于入场日期
      if (timesStr.value.isBefore(selectedCow.inArea)) {
        Toast.show('淘汰时间不能早于入场日期');
        return;
      }
      //时间不能小于出生日期
      if (timesStr.value.isBefore(selectedCow.birth)) {
        Toast.show('淘汰时间不能早于出生日期');
        return;
      }
    } else {
      //育肥牛
      if (ObjectUtil.isEmpty(batchNumber.value)) {
        Toast.show('批次号未获取,请点击批次号选择');
        return;
      }
      String count = countController.text.trim();
      if (ObjectUtil.isEmpty(count)) {
        Toast.show('请输入数量');
        return;
      }
      //时间不能小于入场日期
      if (timesStr.value.isBefore(selectedCowBatch.inArea)) {
        Toast.show('淘汰时间不能早于入场日期');
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
        'type': chooseTypeIndex.value + 1, //必传 integer 类型1：种牛；2：犊牛-育肥牛；
        'batchNo': batchNumber.value, //必传 string 批次号
        'count': countController.text.trim(), // integer 数量
        'cowId': codeString.value.isEmpty ? '' : selectedCow.id, // string 牛只编码
        'cause': int.parse(curReasonID), // string 淘汰原因
        'executor': UserInfoTool.nickName(), // string 淘汰人
        'date': timesStr.value, //必传 string 淘汰时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/weedout", data: para);
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
        'type': chooseTypeIndex.value + 1, //必传 integer 类型1：种牛；2：犊牛-育肥牛；
        'batchNo': batchNumber.value, //必传 string 批次号
        'count': countController.text.trim(), // integer 数量
        'cowId': codeString.value.isEmpty ? '' : event!.cowId, // string 牛只编码
        'cause': int.parse(curReasonID), // string 淘汰原因
        'executor': UserInfoTool.nickName(), // string 淘汰人
        'date': timesStr.value, //必传 string 淘汰时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.put("/api/weedout", data: para);
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

  //获取批次详情
  Future<void> getBatchMoreData(String batchId) async {
    try {
      var response = await httpsClient.get(
        "/api/cowbatch/getbybatchno",
        queryParameters: {"batchNo": batchId},
      );
      selectedCowBatch = CowBatch.fromJson(response);
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
