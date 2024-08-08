import 'package:get/get.dart';
import 'package:flutter/material.dart';

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

class MeasurementController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  MeasurementEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController foreheadWidthController = TextEditingController(); //额宽
  TextEditingController heightController = TextEditingController(); //体高
  TextEditingController lengthController = TextEditingController(); //体长
  TextEditingController geologyController = TextEditingController(); //体斜长
  TextEditingController chestWidthController = TextEditingController(); //胸宽
  TextEditingController chestDepthController = TextEditingController(); //胸深
  TextEditingController chestSizeController = TextEditingController(); //胸围
  TextEditingController waistWidthController = TextEditingController(); //腰角宽
  TextEditingController perimeterController = TextEditingController(); //管围
  TextEditingController weightController = TextEditingController(); //体重
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode foreheadWidthNode = FocusNode(); //
  final FocusNode heightNode = FocusNode();
  final FocusNode lengthNode = FocusNode();
  final FocusNode geologyNode = FocusNode();
  final FocusNode chestWidthNode = FocusNode();
  final FocusNode chestDepthNode = FocusNode();
  final FocusNode chestSizeNode = FocusNode();
  final FocusNode waistWidthNode = FocusNode();
  final FocusNode perimeterNode = FocusNode();
  final FocusNode weightNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(foreheadWidthNode),
        KeyboardActionsHelper.getDefaultItem(heightNode),
        KeyboardActionsHelper.getDefaultItem(lengthNode),
        KeyboardActionsHelper.getDefaultItem(geologyNode),
        KeyboardActionsHelper.getDefaultItem(chestWidthNode),
        KeyboardActionsHelper.getDefaultItem(chestDepthNode),
        KeyboardActionsHelper.getDefaultItem(chestSizeNode),
        KeyboardActionsHelper.getDefaultItem(waistWidthNode),
        KeyboardActionsHelper.getDefaultItem(perimeterNode),
        KeyboardActionsHelper.getDefaultItem(weightNode),
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
    //删除母
    gmList.removeWhere((item) => item['value'] == '母');

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['3', '4']);

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
      event = MeasurementEvent.fromJson(argument.data);
      //
      selectedCow = await getCattleMoreData(event!.cowId);
      //填充母牛耳号
      updateCodeString(selectedCow.code ?? '');
      //登记时间
      updateTimeStr(event!.date);
      //填充数据
      foreheadWidthController.text = event!.foreheadSize.toString();
      heightController.text = event!.bodyHeight.toString();
      lengthController.text = event!.bodyLen.toString();
      geologyController.text = event!.bodyDiagonalLen.toString();
      chestWidthController.text = event!.chestWide.toString();
      chestDepthController.text = event!.chestDepth.toString();
      chestSizeController.text = event!.chest.toString();
      waistWidthController.text = event!.waistline.toString();
      perimeterController.text = event!.cocbone.toString();
      weightController.text = event!.wight.toString();
      //备注
      remarkController.text = event!.remark ?? '';

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
    //耳号
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('耳号未获取,请点击选择');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('登记时间不能早于出生日期');
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

  //编辑事件
  void editAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': event!.id, //事件 ID
        'rowVersion': event!.rowVersion, //事件行版本
        'cowId': selectedCow.id, //
        'date': timesStr.value, //必传 string 时间
        'foreheadSize': foreheadWidthController.text.trim(), //额宽cm
        'bodyHeight': heightController.text.trim(), //体高cm
        'bodyLen': lengthController.text.trim(), //体长cm
        'bodyDiagonalLen': geologyController.text.trim(), //体斜长cm
        'chestWide': chestWidthController.text.trim(), //胸宽cm
        'chestDepth': chestDepthController.text.trim(), //胸深
        'chest': chestSizeController.text.trim(), //胸围cm
        'waistline': waistWidthController.text.trim(), //腰角宽cm
        'cocbone': perimeterController.text.trim(), //管围cm
        'wight': weightController.text.trim(), //体重kg
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.put("/api/bodymeasure", data: para);
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

  //新增事件
  void newAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'cowId': selectedCow.id, //
        'date': timesStr.value, //必传 string 时间
        'foreheadSize': foreheadWidthController.text.trim(), //额宽cm
        'bodyHeight': heightController.text.trim(), //体高cm
        'bodyLen': lengthController.text.trim(), //体长cm
        'bodyDiagonalLen': geologyController.text.trim(), //体斜长cm
        'chestWide': chestWidthController.text.trim(), //胸宽cm
        'chestDepth': chestDepthController.text.trim(), //胸深
        'chest': chestSizeController.text.trim(), //胸围cm
        'waistline': waistWidthController.text.trim(), //腰角宽cm
        'cocbone': perimeterController.text.trim(), //管围cm
        'wight': weightController.text.trim(), //体重kg
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/bodymeasure", data: para);
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
}
