import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:intellectual_breed/app/models/feeds.dart';
import 'package:intellectual_breed/app/models/formula.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../../models/cow_house.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/common_service.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class FeedCattleController extends GetxController {
  //TODO: Implement FeedCattleController
  //传入的参数
  var argument = Get.arguments;

  //编辑事件传入
  FeedEvent? event;

  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  //矫正饲喂量
  TextEditingController countController = TextEditingController(text: '1');
  TextEditingController remarkController = TextEditingController();

  //
  final FocusNode countNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  //配方详情信息
  RxList<FormulaItemModel> modelList = <FormulaItemModel>[].obs;

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
  TextEditingController cowHouseNumController = TextEditingController(text: '0');

  // 饲料类型
  // List<Feeds> feedsTypeList = <Feeds>[];
  // List<String> feedsTypeNameList = [];
  // String selectFeedsValue = '';
  RxString curFeedsType = ''.obs;

  //选择的配方
  FormulaModel? selectFormulaModel;

  //饲喂总量
  // String feedsTotal = '';
  //矫正饲喂量
  String feedsCorrect = '';

  //时间
  final timesStr = ''.obs;

  //备注
  String remarkStr = '';

  //是否编辑模式
  late bool isEditMode;

  @override
  void onInit() async {
    super.onInit();
    //首先处理传入参数
    handleArgument();
    // 输入总量 添加焦点监听器
    countNode.addListener(() async {
      if (!countNode.hasFocus) {
        // // 当焦点失去时执行的逻辑
        // countController.text = feedsCorrect == '' ? '1' : feedsCorrect;
        // String cowsNum = cowHouseNum.value;
        // double singleWeight = feedsCorrect == '' ? 0 : (double.parse(feedsCorrect) / int.parse(cowsNum));
        // feedsSingle.value = singleWeight.toStringAsFixed(2); // 保留两位小数

        // update();

        if (feedsCorrect != countController.text) {
          getFormulaItems();
        }
      }
    });

    //初始化为当前日期
    if (!isEdit.value) {
      timesStr.value = DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    }

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    // CommonService().requestFeedStuffAll();
    //饲料
    // feedsTypeList = await CommonService().requestFeedStuffAll();
    // feedsTypeNameList.addAll(feedsTypeList.map((item) => item.name ?? '').toList());
  }

  //处理传入参数
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = FeedEvent.fromJson(argument.data);
      countController.text = '${event?.dosage ?? '1'}';
      cowHouseNumController.text = '${event?.count ?? '0'}';
      curFeedsType.value = event?.formulaName ?? '--';
      //更新栋舍
      selectedHouseID = event!.cowHouseId;
      selectedHouseName.value = event!.cowHouseName ?? '';
      //填充时间
      updateSeldate(event!.date);
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
      getFormulaItems();
    } else {
      if (argument is CowHouse) {
        CowHouse cowHouse = argument;
        selectedHouseID = cowHouse.id;
        selectedHouseName.value = cowHouse.name ?? '';
        cowHouseNumController.text = cowHouse.occupied.toString();
        update();
      }
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
    cowHouseNumController.text = houseList[position].occupied.toString();
    selectedHouseName.value = cowHouse;
    update();
  }

  // 饲料类型
  void updateFormulaModel(FormulaModel formulaModel) {
    selectFormulaModel = formulaModel;
    curFeedsType.value = formulaModel.name ?? '';
    update();
    getFormulaItems();
  }

  // 调拨时间
  void updateSeldate(String date) {
    timesStr.value = date.length > 10 ? date.substring(0, 10) : date;
    update();
  }

  //temp 上次请求的饲喂量
  String? tempCount;

  //temp 上次请求的id
  String? tempId;

  //获取配方详情
  //获取事件详情
  Future<void> getFormulaItems() async {
    if (tempCount == countController.text && tempId == (selectFormulaModel?.id ?? '')) {
      return;
    }

    if (tempId == (selectFormulaModel?.id ?? '')) {
      update();
      return;
    }
    tempCount = countController.text;
    tempId = selectFormulaModel?.id;
    Toast.showLoading();
    try {
      var response = await httpsClient.get("/api/formulaItems/getAll", queryParameters: {
        "formulaId": (event?.formulaId ?? selectFormulaModel?.id),
      });
      Toast.dismiss();
      modelList.clear();
      for (var item in response) {
        FormulaItemModel model = FormulaItemModel.fromJson(item);
        modelList.add(model);
      }
      // items.value = modelList;
      update();
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

  // 提交数据
  void requestCommit() async {
    if (ObjectUtil.isEmpty(selectedHouseID)) {
      Toast.show('请选择栋舍');
      return;
    }
    if (cowHouseNumController.text == '0') {
      Toast.show('栋舍中没有牛只');
      return;
    }
    if (selectFormulaModel?.id == null && event?.formulaId == null) {
      Toast.show('请选择配方');
      return;
    }
    // String count = countController.text.trim();
    // if (ObjectUtil.isEmpty(count)) {
    //   Toast.show('请输入总饲喂量');
    //   return;
    // }

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
        //接口参数
        Map<String, dynamic> para = {
          'cowHouseId': selectedHouseID, //必传 string 栋舍
          'count': cowHouseNumController.text, //必传 integer 头数
          'formulaId': selectFormulaModel?.id, //必传 string 饲料ID
          'dosage': countController.text.trim(), //必传 number 单头饲喂量
          // 'total': countController.text.trim(), //必传 number 总量
          'executor': UserInfoTool.nickName(), // string 饲喂人
          'date': timesStr.value, //必传 string 饲喂时间
          'remark': remarkController.text.trim(), // 备注
        };

        print(para);
        await httpsClient.post("/api/feed", data: para);
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
        //接口参数
        Map<String, dynamic> para = {
          'id': event!.id, //事件 ID
          'rowVersion': event!.rowVersion, //事件行版本
          'cowHouseId': selectedHouseID, //必传 string 栋舍
          'count': cowHouseNumController.text, //必传 integer 头数
          'formulaId': selectFormulaModel?.id ?? event?.formulaId, //必传 string 饲料ID
          'dosage': countController.text.trim(), //必传 number 单头饲喂量
          // 'total': countController.text.trim(), //必传 number 总量
          'executor': UserInfoTool.nickName(), // string 饲喂人
          'date': timesStr.value, //必传 string 饲喂时间
          'remark': remarkController.text.trim(), // 备注
        };

        //print(para);
        await httpsClient.put("/api/feed", data: para);
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
