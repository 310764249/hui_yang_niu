import 'dart:math';

import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../../models/cow_house.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/common_service.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/alert.dart';
import '../../../../widgets/toast.dart';

class CheckCattleController extends GetxController {
  //TODO: Implement CheckCattleController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  CheckArgument? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  TextEditingController countController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;
  //当前栋舍的数量
  RxString cowHouseNum = '0'.obs;

  //盘点数量
  String realNumber = '0';

  //时间
  final timesStr = ''.obs;
  //备注
  String remarkStr = '';

  @override
  void onInit() async {
    super.onInit();

    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.full);
    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

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
    if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = CheckArgument.fromJson(argument.data);
      //更新栋舍
      selectedHouseID = event!.cowHouseId;
      selectedHouseName.value = event!.cowHouseName ?? '';
      for (var element in houseList) {
        if (event!.cowHouseId == element.id) {
          //更新栋舍容纳量
          cowHouseNum.value = element.occupied.toString();
          break;
        }
      }
      //填充数量
      countController.text = event!.count == 0 ? '' : event!.count.toString();
      //填充时间
      updateSeldate(event!.date);
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
      Toast.dismiss();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 更新"栋舍"选中项
  void updateCurCowHouse(String cowHouse, int position) {
    selectedHouseID = houseList[position].id;
    cowHouseNum.value = houseList[position].occupied.toString();
    selectedHouseName.value = cowHouse;
    update();
  }

  // 调拨时间
  void updateSeldate(String date) {
    timesStr.value = date;
    update();
  }

  // 提交数据
  void requestCommit() async {
    if (ObjectUtil.isEmpty(selectedHouseID)) {
      Toast.show('请选择栋舍');
      return;
    }
    String count = countController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入数量');
      return;
    }

    if (cowHouseNum.value != realNumber) {
      Alert.showConfirm(
        '数量与盘点数量不一致,请完成数量增减事件后再提交!',
      );
      return;
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
    {
      Toast.showLoading();
      try {
        //这里需要转为 ISO 时间 2023-09-21T11:23:36.000
        String realTime = DateTime.parse(timesStr.value).toIso8601String();
        //接口参数
        Map<String, dynamic> para = {
          'cowHouseId': selectedHouseID, //必传 string 栋舍
          'count': countController.text.trim(), //必传 integer 数量
          'executor': UserInfoTool.nickName(), // string 盘点人
          'date': realTime, //必传 string 盘点时间
          'remark': remarkController.text.trim(), // 备注
        };

        //print(para);
        await httpsClient.post("/api/cowcheck", data: para);
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
  }

  //编辑事件
  void editAction() async {
    {
      Toast.showLoading();
      try {
        //这里需要转为 ISO 时间 2023-09-21T11:23:36.000
        String realTime = DateTime.parse(timesStr.value).toIso8601String();
        //接口参数
        Map<String, dynamic> para = {
          'id': event!.id, //事件 ID
          'rowVersion': event!.rowVersion, //事件行版本
          'cowHouseId': selectedHouseID, //必传 string 栋舍
          'count': countController.text.trim(), //必传 integer 数量
          'executor': UserInfoTool.nickName(), // string 盘点人
          'date': realTime, //必传 string 盘点时间
          'remark': remarkController.text.trim(), // 备注
        };

        //print(para);
        await httpsClient.put("/api/cowcheck", data: para);
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
  }
}
