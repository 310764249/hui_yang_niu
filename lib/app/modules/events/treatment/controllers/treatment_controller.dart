import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/mine/controllers/mine_controller.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cow_batch.dart';
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

class TreatmentController extends GetxController {
  var argument = Get.arguments;
  // 编辑事件传入
  TreatmentEvent? event;

  //输入框
  TextEditingController dosageController = TextEditingController();
  TextEditingController cattleCountController = TextEditingController();
  TextEditingController symptomController = TextEditingController();
  TextEditingController pharmacyController = TextEditingController();
  TextEditingController treatmentPersonController = TextEditingController();
  TextEditingController remarkController = TextEditingController();

  final FocusNode dosageNode = FocusNode();
  final FocusNode cattleCountNode = FocusNode();
  final FocusNode symptomNode = FocusNode();
  final FocusNode pharmacyNode = FocusNode();
  final FocusNode treatmentPersonNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(dosageNode),
        KeyboardActionsHelper.getDefaultItem(cattleCountNode),
        KeyboardActionsHelper.getDefaultItem(symptomNode),
        KeyboardActionsHelper.getDefaultItem(pharmacyNode),
        KeyboardActionsHelper.getDefaultItem(treatmentPersonNode),
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

  // 是否是编辑页面
  RxBool isEdit = false.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  RxString codeString = ''.obs;

  /// "类型"选中项: 默认第一项, 0: 种牛(大牛), 1: 犊牛/育肥牛(小牛)
  final typeIndex = 0.obs;
  //当前选中的牛
  late Cattle selectedOldCow;

  // 诊疗时间
  final treatmentTime = ''.obs;

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String oldCowHouseId = ''; // 种牛
  RxString oldCowHouse = ''.obs;
  String littleCowHouseId = ''; // 犊牛/育肥牛
  RxString littleCowHouse = ''.obs;

  // 疾病
  List illnessList = [];
  List<String> illnessNameList = [];
  int illnessId = -1;
  RxString illness = ''.obs;

  // 症状
  RxString symptom = ''.obs;

  // 用药
  RxString pharmacy = ''.obs;

  // 单头剂量
  RxDouble dosage = 0.0.obs;
  // 头数
  RxInt cattleCount = 0.obs;
  //当前选中的批次模型
  late CowBatch selectedLittleCowBatch;
  //批次号
  final batchNumber = ''.obs;
  //数量
  final countNum = 0.obs;

  //诊疗人员
  String treatmentPerson = '';
  //备注
  String remarkStr = '';

  // 更新"当前状态"选中项
  void updateChooseTypeIndex(int index) {
    typeIndex.value = index;
    update();
  }

  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();
    cattleCountNode.addListener(() async {
      if (!cattleCountNode.hasFocus) {
        // 当焦点失去时执行的逻辑
        cattleCount.value = int.parse(cattleCountController.text);
        update();
      }
    });

    // 栋舍列表
    houseList = await CommonService().requestCowHouse();
    // 获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    illnessList = AppDictList.searchItems('jb') ?? [];
    illnessNameList = List<String>.from(illnessList.map((item) => item['label']).toList());
    treatmentPersonController.text = Get.find<MineController>().nickName.value;
    //首先处理传入参数
    handleArgument();
    Toast.dismiss();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is Cattle) {
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      Log.i('-- 防疫编辑event: $argument');
      isEdit.value = true;
      //编辑
      event = TreatmentEvent.fromJson(argument.data);

      // 判断是[单只牛]or[批次牛]
      var isSingle = event?.cowCode != null && event?.batchNo == null;

      //* 判断是[单只牛]or[批次牛], 然后处理对应的展示数据
      if (isSingle) {
        // 类型
        typeIndex.value = 0;
        // 耳号
        codeString.value = event?.cowCode ?? '';
        // 无需显示栋舍
      } else {
        // 类型
        typeIndex.value = 1;
        // 批次号
        batchNumber.value = event?.batchNo ?? '';
        // 无需显示栋舍
        // 头数
        cattleCount.value = event?.count ?? 0;
      }
      // 诊疗时间
      treatmentTime.value = event?.date ?? '';
      // 疾病名称
      illnessId = event?.illness ?? -1;
      illness.value = illnessList.firstWhere((item) => int.parse(item['value']) == event?.illness)['label'];
      // 诊疗人
      treatmentPersonController.text = event?.treatmentPerson ?? '';
      // 症状
      symptom.value = event?.symptom ?? '';
      // 用药
      pharmacy.value = event?.pharmacy ?? '';
      // 剂量
      dosage.value = event?.dosage ?? 0;
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('onReady');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('onClose');
  }

  // 更新"栋舍"选中项
  void updateCowHouse(Cattle cattle) {
    if (typeIndex.value == 0) {
      // 种牛
      oldCowHouseId = cattle.cowHouseId;
      oldCowHouse.value = cattle.cowHouseName ?? '';
    } else {
      // 犊牛/育肥牛
      littleCowHouseId = cattle.cowHouseId;
      littleCowHouse.value = cattle.cowHouseName ?? '';
    }
    update();
  }

  // 更新 批次号
  void updateBatchNumber(String value) {
    batchNumber.value = value;
    update();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    Log.i('更新耳号: $value');
    codeString.value = value;
    update();
  }

  // 提交数据
  void requestCommit() async {
    if (typeIndex.value == 0) {
      if (ObjectUtil.isEmpty(codeString.value)) {
        Toast.show('请选择牛只耳号');
        return;
      }
    } else {
      // 犊牛 & 育肥牛
      if (ObjectUtil.isEmpty(batchNumber.value)) {
        Toast.show('请选择牛只批次号');
        return;
      }
    }
    if (ObjectUtil.isEmpty(treatmentTime.value)) {
      Toast.show('请选择诊疗时间');
      return;
    }
    if (ObjectUtil.isEmpty(illness.value)) {
      Toast.show('请选择疾病名称');
      return;
    }
    // if (ObjectUtil.isEmpty(symptom.value.trim())) {
    //   Toast.show('请输入症状');
    //   return;
    // }
    // if (ObjectUtil.isEmpty(pharmacy.value.trim())) {
    //   Toast.show('请输入用药');
    //   return;
    // }
    // if (ObjectUtil.isEmpty(dosage.value) || dosage.value == 0) {
    //   Toast.show('请输入剂量');
    //   return;
    // }

    //诊疗人员不能为空
    if (ObjectUtil.isEmpty(treatmentPersonController.text.trim())) {
      Toast.show('请输入诊疗人员');
      return;
    }

    Toast.showLoading();
    try {
      //接口参数
      late Map<String, dynamic> para;

      if (!isEdit.value) {
        //* 新增
        para = {
          "date": treatmentTime.value,
          "cowHouseId": typeIndex.value == 0 ? oldCowHouseId : littleCowHouseId, // 栋舍参数可有可无
          "cowId": typeIndex.value == 0 ? selectedOldCow.id : null, // 犊牛只有批次号,没有cowId
          "batchNo": typeIndex.value == 1 ? batchNumber.value : null,
          "illness": illnessId,
          "count": typeIndex.value == 0 ? 1 : cattleCount.value,
          "symptom": symptom.value,
          "pharmacy": pharmacy.value,
          "dosage": dosage.value,
          "treatmentPerson": treatmentPersonController.text.trim(), // 诊疗人
          "remark": remarkController.text.trim(), // 备注
        };
      } else {
        //* 编辑
        para = {
          "date": treatmentTime.value,
          // "cowHouseId": null, // 栋舍参数可有可无
          "cowId": event?.cowId ?? '', // 犊牛只有批次号,没有cowId
          "batchNo": batchNumber.value,
          "illness": illnessId,
          "count": typeIndex.value == 0 ? 1 : cattleCount.value,
          "symptom": symptom.value,
          "pharmacy": pharmacy.value,
          "dosage": dosage.value,
          "treatmentPerson": treatmentPersonController.text.trim(), // 诊疗人
          "remark": remarkController.text.trim(), // 备注
          //* 编辑用的参数
          'id': isEdit.value ? event!.id : null, //事件 ID
          'rowVersion': isEdit.value ? event!.rowVersion : null, //事件行版本
        };
      }
      para = removeNulls(para);
      // print(para);
      isEdit.value ? await httpsClient.put("/api/treatment", data: para) : await httpsClient.post("/api/treatment", data: para);
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

  Map<String, dynamic> removeNulls(Map<String, dynamic> map) {
    map.removeWhere((key, value) => value == null);
    return map;
  }
}
