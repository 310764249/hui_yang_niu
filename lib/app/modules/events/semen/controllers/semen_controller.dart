import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
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
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class SemenController extends GetxController {
  //TODO: Implement SemenController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  SemenEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController totalController = TextEditingController(); //采精量
  TextEditingController countController = TextEditingController(); //稀释份数
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode totalNode = FocusNode(); //
  final FocusNode countNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(totalNode),
        KeyboardActionsHelper.getDefaultItem(countNode),
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
  // "是否合格"可选项
  List passList = [];
  List<String> passNameList = [];
  String curPassID = '';
  RxInt curPassIndex = 0.obs;

  //采精量
  String total = '0';
  //稀释份数
  String count = '0';

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
    //初始化字典项
    passList = AppDictList.searchItems('hg') ?? [];
    curPassID = passList.isNotEmpty ? passList.first['value'] : '';
    passNameList =
        List<String>.from(passList.map((item) => item['label']).toList());
    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    gmList.removeWhere((item) => item['value'] == '母');

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['3', '4']);

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
      event = SemenEvent.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId!);
      //
      totalController.text = event!.dosage == 0 ? '' : event!.dosage.toString();
      //数量
      countController.text = event!.copies == 0 ? '' : event!.copies.toString();
      //是否合格
      curPassID = event!.quality.toString(); //提交数据
      curPassIndex.value = AppDictList.findIndexByCode(
          passList, event!.quality.toString()); //显示选中项
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

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 更新选择原因
  void updatePass(int index) {
    curPassID = passList[index]['value'];
    curPassIndex.value = index;
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
      Toast.show('采精时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('采精时间不能早于出生日期');
      return;
    }
    //采精量
    String total = totalController.text.trim();
    if (ObjectUtil.isEmpty(total)) {
      Toast.show('请输入采精量');
      return;
    }
    if (double.parse(total) == 0) {
      Toast.show('采精量不可为 0');
      return;
    }
    //稀释份数
    String count = countController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入稀释份数');
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
        'dosage': total, //必传 number 采集量
        'quality': int.parse(curPassID), //必传 integer 精液质量1：合格；2：不合格；
        'copies': count, //必传 integer 稀释份数
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      var response = await httpsClient.post("/api/semen", data: para);
      if (ObjectUtil.isNotEmpty(response)) {
        //请求入库
        requestStockIn(response);
      }
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
        'dosage': total, //必传 number 采集量
        'quality': int.parse(curPassID), //必传 integer 精液质量1：合格；2：不合格；
        'copies': count, //必传 integer 稀释份数
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.put("/api/semen", data: para);
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

  //入库操作
  Future<void> requestStockIn(String ID) async {
    try {
      await httpsClient.post("/api/semen/stockin/${ID}");
      return Future.value();
    } catch (error) {
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
