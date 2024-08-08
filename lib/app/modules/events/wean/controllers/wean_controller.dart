import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:common_utils/common_utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

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
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';
import '../../../../services/ex_string.dart';

class WeanController extends GetxController {
  //TODO: Implement WeanController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  WeanEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController countController = TextEditingController(); //头数
  TextEditingController weightController = TextEditingController(); //重量
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode weightNode = FocusNode(); //
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(weightNode),
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //给筛选列表限制条件
  List gmList = [];
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  //时间
  final timesStr = ''.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;
  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;

  //当前选中的批次模型
  late CowBatch selectedCowBatch;
  //批次号
  final batchNumber = ''.obs;
  //头数
  String count = '0';

  @override
  void onInit() async {
    super.onInit();
    //首先处理传入参数
    handleArgument();
    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除公
    gmList.removeWhere((item) => item['label'] == '公');

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['6']);
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
      isEdit.value = true;
      //编辑
      event = WeanEvent.fromJson(argument.data);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId!);
      //填充时间
      updateTimeStr(event!.date);
      //数量
      countController.text = event!.nums == 0 ? '' : event!.nums.toString();
      //重量
      weightController.text =
          event!.weight == 0 ? '' : event!.weight.toString();
      //批次
      updateBatchNumber(event!.batchNo ?? '');
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

  // 更新 批次号
  void updateBatchNumber(String value) {
    batchNumber.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 更新"栋舍"选中项
  void updateCurCowHouse(String cowHouse, int position) {
    selectedHouseID = houseList[position].id;
    selectedHouseName.value = cowHouse;
    update();
  }

  // 提交数据
  void requestCommit() async {
    //种牛
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('耳号未获取,请点击耳号选择');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('断奶时间不能早于出生日期');
      return;
    }
    //育肥牛批次
    if (ObjectUtil.isEmpty(batchNumber.value)) {
      Toast.show('育肥牛批次号未获取,请选择批次号');
      return;
    }
    // if (ObjectUtil.isEmpty(selectedHouseID)) {
    //   Toast.show('请选择栋舍');
    //   return;
    // }
    String count = countController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入数量');
      return;
    }
    //时间不能小于入场日期
    if (timesStr.value.isBefore(selectedCow.inArea)) {
      Toast.show('断奶时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('断奶时间不能早于出生日期');
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
        'batchNo': batchNumber.value, //必传 育肥牛批次号
        'nums': countController.text.trim(), //必传 integer 断奶头数
        'weight': weightController.text.trim(), //必传 number 断奶重量
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 断奶时间
        'remark': remarkController.text.trim(), // 备注
      };

      await httpsClient.post("/api/wean", data: para);
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
        'batchNo': batchNumber.value, //必传 育肥牛批次号
        'nums': countController.text.trim(), //必传 integer 断奶头数
        'weight': weightController.text.trim(), //必传 number 断奶重量
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 断奶时间
        'remark': remarkController.text.trim(), // 备注
      };

      await httpsClient.put("/api/wean", data: para);
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
}
