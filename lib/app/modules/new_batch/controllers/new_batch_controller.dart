import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/cow_batch.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../models/cow_house.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/common_service.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../services/user_info_tool.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';
import '../../../services/ex_string.dart';

class NewBatchController extends GetxController {
  //传入的参数
  CowBatch? argument = Get.arguments;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  TextEditingController countController = TextEditingController();
  TextEditingController sourceController = TextEditingController(); //来源
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode sourceNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(sourceNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //出生日期
  final birthStr = ''.obs;
  //批次号
  final batchNumber = ''.obs;
  // "批次类型"可选项
  List typeList = [];
  List<String> typeNameList = [];
  String curTypeID = '1';
  RxInt curTypeIDIndex = 0.obs;

  //公母
  late List gmList;
  late List<String> gmNameList;
  String gmCurID = '';
  RxInt gmCurIndex = 0.obs;

  //品种
  late List pzList;
  late List<String> pzNameList;
  String pzCurID = '';
  RxInt pzCurIndex = 0.obs;

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;

  //犊牛批次
  String? DNCowBatch;
  //育肥牛批次
  String? YCCowBatch;
  //引种牛批次
  String? YZCowBatch;

  @override
  void onInit() async {
    super.onInit();
    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    birthStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项
    typeList = AppDictList.searchItems('pclb') ?? [];
    typeNameList =
        List<String>.from(typeList.map((item) => item['label']).toList());

    //品种
    pzList = AppDictList.searchItems('pz') ?? [];
    pzCurID = pzList.isNotEmpty ? pzList.first['value'] : '';
    pzNameList =
        List<String>.from(pzList.map((item) => item['label']).toList());
    //公母
    gmList = AppDictList.searchItems('gm') ?? [];
    gmCurID = gmList.isNotEmpty ? gmList.first['value'] : '';
    gmNameList =
        List<String>.from(gmList.map((item) => item['label']).toList());

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());
    //
    handleArgument();
  }

  //处理传入参数
  //批次编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      //请求生成批次号 1 犊牛 2 育肥牛 3 引种牛
      DNCowBatch = await requestBatchNumber(1);
      return;
    }
    if (argument is CowBatch) {
      isEdit.value = true;
      //批次类型
      curTypeID = argument!.type.toString();
      curTypeIDIndex.value = AppDictList.findIndexByCode(typeList, curTypeID);
      //批次号
      batchNumber.value = argument!.batchNo ?? '';
      //批次总数
      countController.text = argument!.count.toString();
      //公母
      updateGMIndex(
          AppDictList.findIndexByCode(gmList, argument!.gender.toString()));
      //出生日期
      updateBirthday(argument!.birth);
      //品种
      updatePZ(AppDictList.findIndexByCode(pzList, argument!.kind.toString()));
      //来源场
      sourceController.text = argument!.sourceFarm ?? '';
      //入场时间
      updateSeldate(argument!.inArea ?? timesStr.value);
      //栋舍
      selectedHouseID = argument!.cowHouseId ?? '';
      selectedHouseName.value = argument!.cowHouseName ?? '';
      //备注
      remarkController.text = argument!.remark ?? '';
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

  //请求生成批次号 1 犊牛 2 育肥牛 3 引种牛
  Future<String> requestBatchNumber(int type) async {
    String number = await CommonService().requestNewBatchNumber(type);
    batchNumber.value = ObjectUtil.isEmpty(number) ? '' : number;
    update();
    return Future.value(batchNumber.value);
  }

  // 更新类型
  void updatePass(int index) async {
    curTypeID = typeList[index]['value'];
    curTypeIDIndex.value = index;
    update();
    //新增页面支持切换批次类型
    if (!isEdit.value) {
      //切换批次号
      if (index == 1) {
        if (YCCowBatch == null) {
          YCCowBatch = await requestBatchNumber(2);
        } else {
          batchNumber.value = YCCowBatch!;
        }
      } else if (index == 2) {
        if (YZCowBatch == null) {
          YZCowBatch = await requestBatchNumber(3);
        } else {
          batchNumber.value = YZCowBatch!;
        }
      } else {
        batchNumber.value = DNCowBatch!;
      }
    }
  }

  //更新品种
  void updatePZ(int index) {
    pzCurIndex.value = index;
    pzCurID = pzList[index]['value'];
    update();
  }

  // 入场时间
  void updateSeldate(String date) {
    timesStr.value = date;
    update();
  }

  // 出生时间
  void updateBirthday(String date) {
    birthStr.value = date;
    update();
  }

  //更新公母
  void updateGMIndex(int index) {
    gmCurIndex.value = index;
    gmCurID = gmList[index]['value'];
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
    String count = countController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入批次总数');
      return;
    }
    if (int.parse(count) == 0) {
      Toast.show('批次总数不可为 0');
      return;
    }
    if (ObjectUtil.isEmpty(selectedHouseID)) {
      Toast.show('请选择栋舍');
      return;
    }
    //时间不能小于入场日期
    if (timesStr.value.isBefore(birthStr.value)) {
      Toast.show('入场时间不能早于出生日期');
      return;
    }

    //判断提交类型
    if (ObjectUtil.isEmpty(argument)) {
      newAction();
    } else {
      editAction();
    }
  }

  //新增事件
  void newAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'farmId': UserInfoTool.farmerId(), //事件 ID
        'sourceFarm': sourceController.text.trim(), //来源场
        'cowHouseId': selectedHouseID, //必传 string 栋舍
        'batchNo': batchNumber.value, //batchNo
        'type': curTypeID, //类别1：犊牛；2：育肥牛；3：引种牛；
        'gender': gmCurID, //公母
        'birth': birthStr.value, //出生日期
        'kind': pzCurID, //品种
        'inArea': timesStr.value, //入场时间
        'count': countController.text.trim(), //批次总数
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      await httpsClient.post("/api/cowbatch", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      //执行跳转  回到上级页面，
      Get.back(result: true);
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
    {
      Toast.showLoading();
      try {
        //接口参数
        Map<String, dynamic> para = {
          'id': argument!.id, //事件 ID
          'farmId': argument!.farmId, //事件 ID
          'rowVersion': argument!.rowVersion, //事件行版本

          'sourceFarm': sourceController.text.trim(), //来源场
          'cowHouseId': selectedHouseID, //必传 string 栋舍
          'gender': gmCurID, //公母
          'birth': birthStr.value, //出生日期
          'kind': pzCurID, //品种
          'inArea': timesStr.value, //入场时间
          'count': countController.text.trim(), //批次总数
          'executor': UserInfoTool.nickName(), // string 技术员
          'remark': remarkController.text.trim(), // 备注
        };

        await httpsClient.put("/api/cowbatch", data: para);
        Toast.dismiss();
        Toast.success(msg: '提交成功');
        //执行跳转  回到上级页面，
        Get.back(result: true);
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
