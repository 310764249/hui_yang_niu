import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/ex_string.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cow_house.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/common_service.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class HealthCareController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  HealthCareEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController dosageController = TextEditingController();
  TextEditingController totalDosageController = TextEditingController();
  TextEditingController cattleCountController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController pharmacyController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  final FocusNode dosageNode = FocusNode();
  final FocusNode totalDosageNode = FocusNode();
  final FocusNode cattleCountNode = FocusNode();
  final FocusNode symptomNode = FocusNode();
  final FocusNode pharmacyNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(dosageNode),
        KeyboardActionsHelper.getDefaultItem(totalDosageNode),
        KeyboardActionsHelper.getDefaultItem(cattleCountNode),
        KeyboardActionsHelper.getDefaultItem(symptomNode),
        KeyboardActionsHelper.getDefaultItem(pharmacyNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  // 栋舍Id
  late String? cowHouseId = '';
  // 栋舍
  late RxString? cowHouse = RxString('');
  // 保健时间
  final healthTime = ''.obs;

  List healthTypeList = [];
  List healthTypeNameList = [];
  // 保健类型Id
  String healthTypeId = '';
  // 保健类型
  RxString healthType = ''.obs;

  // 用药
  RxString pharmacy = ''.obs;
  // 单头剂量
  RxDouble dosage = 0.0.obs;
  // 头数
  RxInt cattleCount = 0.obs;
  // 总量
  RxDouble totalDosage = 0.0.obs;

  // 可选单位列表
  late List unitList;
  late List unitNameList;
  // 单位字典项相关
  int unitId = -1;
  RxString unit = ''.obs;

  void updateUnit(String newUnit, int position) {
    unitId = int.parse(unitList[position]['value']);
    unit.value = newUnit;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();
    unitList = AppDictList.searchItems('jldw') ?? [];
    unitNameList =
        List<String>.from(unitList.map((item) => item['label']).toList());

    // 栋舍列表
    houseList = await CommonService().requestCowHouse();
    // 获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    // 保健类型列表
    healthTypeList = AppDictList.searchItems('bjlx') ?? [];
    healthTypeNameList =
        List<String>.from(healthTypeList.map((item) => item['label']).toList());

    // 设置输入框焦点监听
    dosageNode.addListener(() async {
      if (!cattleCountNode.hasFocus) {
        // 当焦点失去时执行的逻辑
        dosage.value = double.parse(dosageController.text);
        calculateTotalDosage();
      }
    });
    cattleCountNode.addListener(() async {
      if (!cattleCountNode.hasFocus) {
        // 当焦点失去时执行的逻辑
        cattleCount.value = int.parse(cattleCountController.text);
        calculateTotalDosage();
      }
    });
    totalDosageNode.addListener(() async {
      if (!cattleCountNode.hasFocus) {
        // 当焦点失去时执行的逻辑
        totalDosage.value = double.parse(totalDosageController.text);
        calculateSingleDosage();
      }
    });
    Toast.dismiss();

    //处理传入参数
    handleArgument();
  }

  //处理传入参数
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
      event = HealthCareEvent.fromJson(argument.data);
      //更新栋舍
      cowHouseId = event!.cowHouseId;
      cowHouse?.value = event!.cowHouseName ?? '';
      //保健时间
      healthTime.value = event!.date;
      //
      //品种
      healthTypeId = event!.type.toString(); //提交数据
      healthType.value = AppDictList.findLabelByCode(
          healthTypeList, event!.type.toString()); //显示选中项

      //用药
      pharmacyController.text = event!.pharmacy ?? '';
      //单头剂量
      dosage.value = event!.dosage ?? 0.0;
      //剂量单位
      unitId = event!.unit;
      unit.value = AppDictList.findLabelByCode(unitList, unitId.toString());
      //头数
      cattleCount.value = event!.count;
      //总剂量
      totalDosage.value = event!.total ?? 0.0;
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
    Toast.dismiss();
  }

  // 计算总剂量
  void calculateTotalDosage() {
    totalDosage.value = double.parse(
        (dosage.value * cattleCount.value).toStringAsFixed(2)); // 保留了两位小数
    totalDosageController.text = totalDosage.value.toString();
  }

  // 计算单头剂量
  void calculateSingleDosage() {
    dosage.value = double.parse(
        (totalDosage.value / cattleCount.value).toStringAsFixed(2)); // 保留了两位小数
    dosageController.text = dosage.value.toString();
  }

  // 提交数据
  void requestCommit() async {
    if (ObjectUtil.isEmpty(cowHouseId.orEmpty())) {
      Toast.show('请选择牛只栋舍');
      return;
    }
    if (ObjectUtil.isEmpty(healthTime.value)) {
      Toast.show('请选择保健时间');
      return;
    }
    if (ObjectUtil.isEmpty(healthTypeId.orEmpty())) {
      Toast.show('请选择保健类型');
      return;
    }
    // if (ObjectUtil.isEmpty(pharmacy.value.trim())) {
    //   Toast.show('请输入用药');
    //   return;
    // }
    // if (ObjectUtil.isEmpty(dosage.value) || dosage.value == 0) {
    //   Toast.show('请输入单头剂量');
    //   return;
    // }
    if ((dosage.value > 0) && (unitId == -1 || unitId == 0)) {
      Toast.show('请选择剂量单位');
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
    try {
      Toast.showLoading();

      Map<String, dynamic> para = {
        "cowHouseId": cowHouseId,
        "date": healthTime.value,
        "type": int.parse(healthTypeId),
        "count": cattleCount.value,
        "pharmacy": pharmacy.value,
        "dosage": dosage.value,
        "unit": (unitId != -1 && unitId != 0) ? unitId : null,
        "total": totalDosage.value,
        "remark": remarkController.text.trim(),
      };
      // print(para);
      await httpsClient.post("/api/healthcare", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      Get.back();
    } catch (error) {
      Toast.dismiss();
      Toast.failure(msg: error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //编辑事件
  void editAction() async {
    try {
      Toast.showLoading();

      Map<String, dynamic> para = {
        'id': event!.id, //事件 ID
        'rowVersion': event!.rowVersion, //事件行版本
        "cowHouseId": cowHouseId,
        "date": healthTime.value,
        "type": int.parse(healthTypeId),
        "count": cattleCount.value,
        "pharmacy": pharmacy.value,
        "dosage": dosage.value,
        "unit": (unitId != -1 && unitId != 0) ? unitId : null,
        "total": totalDosage.value,
        "remark": remarkController.text.trim(),
      };
      await httpsClient.put("/api/healthcare", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      Get.back();
    } catch (error) {
      Toast.dismiss();
      Toast.failure(msg: error.toString());
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
