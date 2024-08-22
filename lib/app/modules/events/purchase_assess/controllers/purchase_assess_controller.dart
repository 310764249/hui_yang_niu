import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cow_batch.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/ex_string.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class PurchaseAssessController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  PurchaseEvent? event;

  HttpsClient httpsClient = HttpsClient();

  //输入框
  TextEditingController nameController = TextEditingController();
  TextEditingController manufacturersController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController breakageController = TextEditingController();

  TextEditingController remarkController = TextEditingController();

  //
  final FocusNode nameNode = FocusNode();
  final FocusNode manufacturersNode = FocusNode();
  final FocusNode countNode = FocusNode();
  final FocusNode priceNode = FocusNode();
  final FocusNode amountNode = FocusNode();
  final FocusNode breakageNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(nameNode),
        KeyboardActionsHelper.getDefaultItem(manufacturersNode),
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(priceNode),
        KeyboardActionsHelper.getDefaultItem(amountNode),
        KeyboardActionsHelper.getDefaultItem(breakageNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  // 是否是编辑页面
  RxBool isEdit = false.obs;

  // 数量
  RxInt cattleCount = 0.obs;

  // 时间
  final assessTime = ''.obs;

  // 采购
  List purchaseAssessList = [];
  List<String> purchaseAssessNameList = [];
  int purchaseAssessId = -1;
  RxString purchaseAssess = ''.obs;

  @override
  void onInit() async {
    super.onInit();
    Toast.showLoading();

    purchaseAssessList = AppDictList.searchItems('wzfl') ?? [];
    purchaseAssessNameList = List<String>.from(purchaseAssessList.map((item) => item['label']).toList());

    //首先处理传入参数
    handleArgument();
    if (!isEdit.value) {
      assessTime.value = DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    }
    Toast.dismiss();
  }

  //自动计算总价
  void autoCalculate() {
    if (countController.text.isNotEmpty && priceController.text.isNotEmpty && breakageController.text.isNotEmpty) {
      int count = int.parse(countController.text);
      double price = double.parse(priceController.text);
      // double amount = double.parse(amountController.text);
      double breakage = double.parse(breakageController.text);
      double amount = price * count - breakage;
      if (amount > 0) {
        amountController.text = amount.toStringAsFixed(2).replaceAll(RegExp(r'0*$'), ''); // "$amount";
        if (amountController.text.endsWith(".")) {
          amountController.text = amountController.text.substring(0, amountController.text.length - 1);
        }
      } else {
        amountController.text = "";
      }
    }
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is SimpleEvent) {
      Log.i('-- 采购评估编辑event: ${argument.data}');
      isEdit.value = true;
      //编辑
      event = PurchaseEvent.fromJson(argument.data);

      cattleCount.value = event?.count ?? 0;
      // 评估时间
      assessTime.value = event?.date ?? '';
      // 采购
      purchaseAssessId = event?.type ?? -1;
      if (purchaseAssessId != -1) {
        purchaseAssess.value = purchaseAssessList.firstWhere((item) => int.parse(item['value']) == purchaseAssessId)['label'];
      }
      //填充备注
      nameController.text = event?.name ?? '';
      manufacturersController.text = event?.manufacturers ?? '';
      countController.text = event?.count.toString() ?? '';
      priceController.text = event?.price.toString() ?? '';
      amountController.text = event?.amount.toString() ?? '';
      breakageController.text = event?.breakage.toString() ?? '';
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
  }

  //获取牛只详情
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

  /// 提交表单数据
  Future<void> commitPreventionData() async {
    String? str;
    if (nameController.text.isEmpty) {
      str = '请输入物资名称';
    } else if (nameController.text.isEmpty) {
      str = '请输入物资名称';
    } else if (assessTime.value.isBlankEx()) {
      str = '请选择采购日期';
    } else if (countController.text.isEmpty) {
      str = '请输入数量';
    } else if (priceController.text.isEmpty) {
      str = '请输入单价';
    } else if (amountController.text.isEmpty) {
      str = '请输入总价';
    } else if (breakageController.text.isEmpty) {
      str = '请输入折损';
    }
    /*if (purchaseAssessId == -1) {
        Toast.show('请选择采购类型');
        return;
      }*/
    if (str != null && str.isNotEmpty) {
      Toast.show(str);
      return;
    }

    try {
      Toast.showLoading(msg: "提交中...");

      //接口参数
      late Map<String, dynamic> mapParam;
      if (!isEdit.value) {
        //* 新增
        mapParam = {
          //'id': isEdit.value ? event?.id : '', //事件 ID
          //'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
          "date": assessTime.value,
          "type": purchaseAssessId,
          "name": nameController.text,
          "manufacturers": manufacturersController.text,
          "count": int.parse(countController.text),
          "price": double.parse(priceController.text),
          "amount": double.parse(amountController.text),
          "breakage": double.parse(breakageController.text),
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      } else {
        //* 编辑
        mapParam = {
          //* 编辑用的参数
          'id': isEdit.value ? event?.id : '', //事件 ID
          'rowVersion': isEdit.value ? event?.rowVersion : '', //事件行版本
          "no": event?.no ?? "",
          "date": assessTime.value,
          "type": purchaseAssessId,
          "name": nameController.text,
          "manufacturers": manufacturersController.text,
          "count": int.parse(countController.text),
          "price": double.parse(priceController.text),
          "amount": double.parse(amountController.text),
          "breakage": double.parse(breakageController.text),
          'executor': UserInfoTool.nickName(),
          "remark": remarkController.text.trim()
        };
      }

      debugPrint('-----> $mapParam');
      isEdit.value
          ? await httpsClient.put("/api/purchase", data: mapParam)
          : await httpsClient.post("/api/purchase", data: mapParam);

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
