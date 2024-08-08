import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:common_utils/common_utils.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cow_house.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../services/Log.dart';
import '../../../../services/common_service.dart';
import '../../../../services/keyboard_actions_helper.dart';

class BuyInController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  BuyInEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController countController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController columnController = TextEditingController(); //栏位
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode sourceNode = FocusNode();
  final FocusNode columnNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      // keyboardBarColor: Colors.grey.shade200,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(sourceNode),
        KeyboardActionsHelper.getDefaultItem(columnNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  //引种数量
  final countNum = 0.obs;
  //批次号
  final batchNumber = ''.obs;
  //入场时间
  final stationedTime = ''.obs;
  //出生时间
  final birthday = ''.obs;
  // "品种"可选项
  List breedList = [];
  List<String> breedNameList = [];
  String selectedBreedID = ''; //提交数据使用
  RxInt selectedBreedIndex = 0.obs;
  // "性别"可选项
  List genderList = [];
  List<String> genderNameList = [];
  String selectedGenderID = ''; //提交数据使用
  RxInt selectedGenderIndex = 0.obs;
  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    //初始化为当前日期
    birthday.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    stationedTime.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项
    breedList = AppDictList.searchItems('pz') ?? [];
    selectedBreedID = breedList.isNotEmpty ? breedList.first['value'] : '';
    breedNameList =
        List<String>.from(breedList.map((item) => item['label']).toList());
    //公、母
    genderList = AppDictList.searchItems('gm') ?? [];
    selectedGenderID = genderList.isNotEmpty ? genderList.first['value'] : '';
    genderNameList =
        List<String>.from(genderList.map((item) => item['label']).toList());
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
      //请求生成批次号
      requestBatchNumber();
      //不传值是新增
      return;
    }
    if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = BuyInEvent.fromJson(argument.data);
      //填充批次
      batchNumber.value = event!.batchNo ?? '';
      //填充数量
      countController.text = event!.count == 0 ? '' : event!.count.toString();
      //来源场
      sourceController.text = event!.sourceFarm ?? '';
      //填充出生时间
      updateSeldate(event!.birth ?? '');
      //填充入场时间
      updateStationedTime(event!.inArea ?? '');
      //性别
      selectedGenderID = event!.gender.toString(); //提交数据
      selectedGenderIndex.value = AppDictList.findIndexByCode(
          genderList, event!.gender.toString()); //显示选中项
      //品种
      selectedBreedID = event!.kind.toString(); //提交数据
      selectedBreedIndex.value = AppDictList.findIndexByCode(
          breedList, event!.kind.toString()); //显示选中项
      //更新栋舍
      selectedHouseID = event!.cowHouseId;
      selectedHouseName.value = event!.cowHouseName ?? '';

      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
    Toast.dismiss();
  }

  //请求生成批次号
  void requestBatchNumber() async {
    String number = await CommonService().requestNewBatchNumber(3);
    batchNumber.value = ObjectUtil.isEmpty(number) ? '' : number;
    update();
  }

  void updateSeldate(String date) {
    birthday.value = date;
    update();
  }

  void updateStationedTime(String date) {
    stationedTime.value = date;
    update();
  }

  void updateCurCowHouse(String cowHouse, int index) {
    selectedHouseID = houseList[index].id;
    selectedHouseName.value = cowHouse;
    update();
  }

  // 更新公、母
  void updateCurGender(int index) {
    selectedGenderID = genderList[index]['value'];
    selectedGenderIndex.value = index;
    update();
  }

  // 更新品种
  void updateCurBreed(int index) {
    selectedBreedID = breedList[index]['value'];
    selectedBreedIndex.value = index;
    update();
  }

  // 提交数据
  void requestCommit() async {
    if (ObjectUtil.isEmpty(batchNumber.value)) {
      Toast.show('批次号未获取，请点击批次号重新获取');
      return;
    }
    String count = countController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入数量');
      return;
    }
    if (ObjectUtil.isEmpty(selectedHouseID)) {
      Toast.show('请选择栋舍');
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
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'sourceFarm': sourceController.text.trim(), //必传 来源养殖场
        'cowHouseId': selectedHouseID, // 栋舍ID
        'batchNo': batchNumber.value, //必传 批次号
        'inArea': stationedTime.value, //必传 入场时间
        'birth': birthday.value, //必传 出生日期
        'kind': int.parse(selectedBreedID), // 品种
        'gender': int.parse(selectedGenderID), // 性别1：公；2：母；
        'count': countController.text.trim(), // 数量
        'executor': UserInfoTool.nickName(), //必传 引种人
        'date':
            DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d), //
        'remark': remarkController.text.trim(), //必传 备注
      };
      // print(para);
      await httpsClient.post("/api/restock", data: para);
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
        'sourceFarm': sourceController.text.trim(), //必传 来源养殖场
        'cowHouseId': selectedHouseID, // 栋舍ID
        'batchNo': batchNumber.value, //必传 批次号
        'inArea': stationedTime.value, //必传 入场时间
        'birth': birthday.value, //必传 出生日期
        'kind': int.parse(selectedBreedID), // 品种
        'gender': int.parse(selectedGenderID), // 性别1：公；2：母；
        'count': countController.text.trim(), // 数量
        'executor': UserInfoTool.nickName(), //必传 引种人
        'date':
            DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d), //
        'remark': remarkController.text.trim(), //必传 备注
      };
      // print(para);
      await httpsClient.put("/api/restock", data: para);
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
