import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/constant.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/storage.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class AddCattleHouseController extends GetxController {
  //TODO: Implement AddCattleHouseController
  //输入框
  TextEditingController nameController = TextEditingController();
  TextEditingController dutyController = TextEditingController(); //负责人
  TextEditingController capacityController = TextEditingController(); //容纳量
  TextEditingController descController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  final FocusNode nameNode = FocusNode();
  final FocusNode dutyNode = FocusNode();
  final FocusNode capacityNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(nameNode),
        KeyboardActionsHelper.getDefaultItem(dutyNode),
        KeyboardActionsHelper.getDefaultItem(capacityNode),
        KeyboardActionsHelper.getDefaultItem(descNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //备注
  String remarkStr = '';

  // "类型"可选项
  List typeList = [];
  List<String> typeNameList = [];
  String curTypeID = '';
  RxInt curTypeIndex = 0.obs;

  //位置信息
  RxString locationInfo = ''.obs;
  double latitude = 0.0;
  double longitude = 0.0;

  @override
  void onInit() {
    super.onInit();
    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //栋舍类型
    typeList = AppDictList.searchItems('dslx') ?? [];
    curTypeID = typeList.isNotEmpty ? typeList.first['value'] : '';
    typeNameList =
        List<String>.from(typeList.map((item) => item['label']).toList());
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //更新类型
  void handleLocation(Map res) {
    latitude = res['lat'];
    longitude = res['lng'];
    locationInfo.value = res['address'];
    update();
  }

  //更新类型
  void updateCurType(int index) {
    curTypeIndex.value = index;
    curTypeID = typeList[index]['value'];
    update();
  }

  // 提交数据
  void requestCommit() async {
    //栋舍名称
    if (ObjectUtil.isEmpty(nameController.text.trim())) {
      Toast.show('请输入栋舍名称');
      return;
    }
    //负责人
    if (ObjectUtil.isEmpty(dutyController.text.trim())) {
      Toast.show('请输入负责人');
      return;
    }
    //容纳量
    String capacity = capacityController.text.trim();
    if (ObjectUtil.isEmpty(capacity)) {
      Toast.show('请输入容纳量');
      return;
    }
    if (int.parse(capacity) == 0) {
      Toast.show('容纳量不可为 0');
      return;
    }
    //
    Toast.showLoading();

    String farmId = '';
    //获取当前选中养殖场的 farmId
    var res = await Storage.getData(Constant.selectFarmData);
    if (!ObjectUtil.isEmpty(res)) {
      farmId = res['id'] ?? '';
    }

    try {
      //接口参数
      Map<String, dynamic> para = {
        'farmId': farmId,
        'name': nameController.text.trim(), // string 栋舍名称
        'type': curTypeID, // string 栋舍类型
        'lat': latitude == 0.0 ? null : latitude, //
        'lng': longitude == 0.0? null : longitude, //
        'principal': dutyController.text.trim(), // string 负责人
        'capacity': int.parse(capacity), // string 栋舍容纳量
        'desc': descController.text.trim(), // string 栋舍简介
        //'date': timesStr.value, //必传 string 时间
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/cowhouse", data: para);
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
