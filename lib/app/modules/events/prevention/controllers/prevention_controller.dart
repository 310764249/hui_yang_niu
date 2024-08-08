import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
import '../../../../services/ex_string.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class PreventionController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  PreventionEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController dosageController = TextEditingController();
  TextEditingController totalDosageController = TextEditingController();
  TextEditingController cattleCountController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode dosageNode = FocusNode();
  final FocusNode totalDosageNode = FocusNode();
  final FocusNode cattleCountNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(dosageNode),
        KeyboardActionsHelper.getDefaultItem(totalDosageNode),
        KeyboardActionsHelper.getDefaultItem(cattleCountNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;

  // 防疫类型
  List<String> preventionTypeList = [
    '批量',
    '个体',
  ];
  // 防疫类型index: 0:批量 1:个体
  var typeIndex = 0.obs;
  void updateTypeIndex(int index) {
    typeIndex.value = index;
    // [个体防疫]没有[头数], 所以[总量]和[单头剂量]一样
    calculateTotalDosage();
    update();
  }

  // "类型"选中项: 默认第一项
  final chooseTypeIndex = 0.obs;
  // 当前选中的牛
  late Cattle selectedCow;
  // 耳号
  final codeString = ''.obs;
  // 当前状态Id
  int stageId = -1;
  // 当前状态
  final currentStage = ''.obs;
  // 当前选中的批次模型
  late CowBatch selectedCowBatch;

  // 批量防疫栋舍Id, 由于涉及到批量和个体的切换, 数据交叉容易混乱, 所以分开容易控制
  late String? batchCowHouseId = '';
  // 批量防疫栋舍
  late RxString? batchCowHouse = RxString('');

  // 个体栋舍Id
  late String? cowHouseId = '';
  // 个体栋舍
  late RxString? cowHouse = RxString('');

  // 防疫时间
  final preventionTime = ''.obs;

  // 疫病
  List loimiaList = [];
  List<String> loimiaNameList = [];
  int loimiaId = -1;
  RxString loimia = ''.obs;

  // 疫苗
  List vaccineList = [];
  List<String> vaccineNameList = [];
  int vaccineId = -1;
  RxString vaccine = ''.obs;

  // 单头剂量
  RxDouble dosage = 0.0.obs;
  // 头数
  RxInt cattleCount = 0.obs;
  // 总量
  RxDouble totalDosage = 0.0.obs;

  // 计算总剂量
  void calculateTotalDosage() {
    if (typeIndex.value == 0) {
      // 批次
      totalDosage.value = double.parse(
          (dosage.value * cattleCount.value).toStringAsFixed(2)); // 保留了两位小数
    } else {
      // 个体
      totalDosage.value = double.parse(dosage.value.toStringAsFixed(2));
    }
    totalDosageController.text = totalDosage.value.toString();
  }

  // 计算单头剂量
  void calculateSingleDosage() {
    if (typeIndex.value == 0) {
      // 批次
      dosage.value = double.parse((totalDosage.value / cattleCount.value)
          .toStringAsFixed(2)); // 保留了两位小数
    } else {
      // 个体
      dosage.value = double.parse(totalDosage.value.toStringAsFixed(2));
    }
    dosageController.text = dosage.value.toString();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  void setCurrentStage(int stageCode) {
    stageId = stageCode;
    switch (stageCode) {
      case 1:
        currentStage.value = '犊牛';
        break;
      case 2:
        currentStage.value = '育肥牛';
        break;
      case 3:
        currentStage.value = '后备牛';
        break;
      case 4:
        currentStage.value = '种牛';
        break;
      case 5:
        currentStage.value = '妊娠母牛';
        break;
      case 6:
        currentStage.value = '哺乳母牛';
        break;
      case 7:
        currentStage.value = '空怀母牛';
        break;
      default:
        currentStage.value = '犊牛';
        break;
    }
    update();
  }

  void updateCowHouseInfo(String value, int position) {
    batchCowHouseId = houseList[position].id;
    batchCowHouse?.value = value;
    // 批量操作数量, 选择了栋舍后, 头数 = 入驻数
    cattleCount.value = houseList[position].occupied;
    calculateTotalDosage();
    update();
  }

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];

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

    loimiaList = AppDictList.searchItems('yb') ?? [];
    loimiaNameList =
        List<String>.from(loimiaList.map((item) => item['label']).toList());

    vaccineList = AppDictList.searchItems('ym') ?? [];
    vaccineNameList =
        List<String>.from(vaccineList.map((item) => item['label']).toList());

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

    //首先处理传入参数
    handleArgument();
    Toast.dismiss();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() {
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
      event = PreventionEvent.fromJson(argument.data);

      // 判断是[单只牛]or[批次牛]
      var isMultiple = event?.cowHouseId != null && event?.cowCode == null;

      //* 判断是[批量]or[个体], 然后处理对应的展示数据
      if (isMultiple) {
        // 类型
        typeIndex.value = 0;
        // 栋舍
        batchCowHouseId = event?.cowHouseId;
        batchCowHouse?.value = event?.cowHouseName ?? '';
        // 头数
        cattleCount.value = event?.count ?? 0;
      } else {
        // 类型
        typeIndex.value = 1;
        // 耳号
        codeString.value = event?.cowCode ?? '';
        // 当前状态
        stageId = event?.status ?? -1;
        setCurrentStage(event?.status ?? -1);
        // 栋舍
        cowHouseId = event?.cowHouseId;
        cowHouse?.value = event?.cowHouseName ?? '';
      }
      // 防疫时间
      preventionTime.value = event?.date ?? '';
      // 疫病
      loimiaId = event?.loimia ?? -1;
      loimia.value = loimiaList.firstWhere(
          (item) => int.parse(item['value']) == event?.loimia)['label'];

      // 疫苗
      vaccineId = event?.vaccine ?? -1;
      Log.i('************************');
      vaccine.value = vaccineList.firstWhereOrNull(
              (item) => int.parse(item['value']) == event?.vaccine)?['label'] ??
          '';
      // 剂量
      dosage.value = event?.dosage ?? 0;
      // 单头剂量单位
      unitId = event?.unit ?? -1;
      unit.value = unitList.firstWhereOrNull(
              (item) => int.parse(item['value']) == event?.unit)?['label'] ??
          '';
      // 总剂量
      totalDosage.value = event?.total ?? 0;

      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
  }

  /// 提交表单数据
  Future<void> commitPreventionData() async {
    // 批次防疫校验
    if (typeIndex.value == 0) {
      if (batchCowHouseId?.isBlankEx() ?? true) {
        Toast.show('请选择栋舍');
        return;
      }
      if (preventionTime.value.isBlankEx()) {
        Toast.show('请选择防疫时间');
        return;
      }
      if (loimiaId == -1) {
        Toast.show('请选择疫病');
        return;
      }
      // if (vaccineId.value.isBlankEx()) {
      //   Toast.show('请选择疫苗');
      //   return;
      // }
      // if (dosage.value == 0) {
      //   Toast.show('请输入单头剂量');
      //   return;
      // }
      if ((dosage.value > 0) && (unitId == -1 || unitId == 0)) {
        Toast.show('请选择剂量单位');
        return;
      }
    }

    // 个体防疫校验
    if (typeIndex.value == 1) {
      if (codeString.value.isBlankEx()) {
        Toast.show('请选择牛只');
        return;
      }
      if (cowHouseId?.isBlankEx() ?? true) {
        Toast.show('请选择栋舍');
        return;
      }
      if (preventionTime.value.isBlankEx()) {
        Toast.show('请选择防疫时间');
        return;
      }
      if (loimiaId == -1) {
        Toast.show('请选择疫病');
        return;
      }
      // if (vaccineId.value.isBlankEx()) {
      //   Toast.show('请选择疫苗');
      //   return;
      // }
      // if (dosage.value == 0) {
      //   Toast.show('请输入单头剂量');
      //   return;
      // }
      if ((dosage.value > 0) && (unitId == -1 || unitId == 0)) {
        Toast.show('请选择剂量单位');
        return;
      }
    }

    try {
      Toast.showLoading(msg: "提交中...");

      //接口参数
      late Map<String, dynamic> mapParam;
      if (!isEdit.value) {
        //* 新增
        mapParam = {
          "date": preventionTime.value,
          "loimia": loimiaId,
          "vaccine": vaccineId == -1 ? null : vaccineId,
          "cowHouseId": typeIndex.value == 0
              ? batchCowHouseId // 注意批量防疫选择的是批量的栋舍id
              : cowHouseId, // 注意个体防疫选择的是个体的栋舍id
          "status": typeIndex.value == 1 ? stageId : null,
          "count": typeIndex.value == 0 ? cattleCount.value : 1,
          "cowId": typeIndex.value == 1 ? selectedCow.id : null, // 个体
          // "batchNo": typeIndex.value == 0 ? batchNumber.value : null, // 批次
          "dosage": dosage.value,
          "unit": unitId != -1 ? unitId : null,
          "total": totalDosage.value,
          // "executor": "string",
          "remark": remarkController.text.trim(),
        };
      } else {
        //* 编辑
        mapParam = {
          "date": preventionTime.value,
          "loimia": loimiaId,
          "vaccine": vaccineId == -1 ? null : vaccineId,
          "cowHouseId": typeIndex.value == 0
              ? batchCowHouseId // 注意批量防疫选择的是批量的栋舍id
              : cowHouseId, // 注意个体防疫选择的是个体的栋舍id
          "status": typeIndex.value == 1 ? stageId : null,
          "count": typeIndex.value == 0 ? cattleCount.value : 1,
          "cowId": typeIndex.value == 1 ? event?.cowId ?? '' : null, // 个体
          // "batchNo": typeIndex.value == 0 ? batchNumber.value : null, // 批次
          "dosage": dosage.value,
          "unit": unitId != -1 ? unitId : null,
          "total": totalDosage.value,
          // "executor": "string",
          "remark": remarkController.text.trim(),
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '', //事件 ID
          'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/antidemic", data: mapParam)
          : await httpsClient.post("/api/antidemic", data: mapParam);

      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back();
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }
}
