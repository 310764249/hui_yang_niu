import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/cow_batch.dart';
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

class SelectCattleController extends GetxController {
  //TODO: Implement SelectCattleController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  SelectEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  TextEditingController codeController = TextEditingController(); //耳号
  TextEditingController columnController = TextEditingController(); //栏位
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode codeNode = FocusNode(); //
  final FocusNode columnNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(codeNode),
        KeyboardActionsHelper.getDefaultItem(columnNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  //时间格式
  final timesStr = ''.obs;

  //当前选中的批次模型
  late CowBatch selectedCowBatch;
  //批次号
  final batchNumber = ''.obs;

  //入场时间
  final stationedTime = ''.obs;
  //耳号
  final codeString = ''.obs;
  // "类型"可选项
  List chooseTypeList = [];
  List<String> chooseTypeNameList = [
    '后备公牛',
    '后备母牛',
  ];
  String selectedGenderID = ''; //提交数据使用
  RxInt selectedGenderIndex = 0.obs;
  //出生时间
  final birthday = ''.obs;
  // "品种"可选项
  List breedList = [];
  List<String> breedNameList = [];
  String selectedBreedID = ''; //提交数据使用
  RxInt selectedBreedIndex = 0.obs;
  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    birthday.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项
    breedList = AppDictList.searchItems('pz') ?? [];
    selectedBreedID = breedList.isNotEmpty ? breedList.first['value'] : '';
    breedNameList =
        List<String>.from(breedList.map((item) => item['label']).toList());
    //公、母
    chooseTypeList = AppDictList.searchItems('gm') ?? [];
    selectedGenderID =
        chooseTypeList.isNotEmpty ? chooseTypeList.first['value'] : '1';

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());

    //处理传入参数
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
      event = SelectEvent.fromJson(argument.data);
      //填充耳号/批次号
      if (ObjectUtil.isNotEmpty(event?.batchNo)) {
        updateBatchNumber(event?.batchNo ?? '');
        //获取批次详情
        await getBatchMoreData(event!.batchNo!);
      }
      //耳号
      codeController.text = event!.cowCode ?? '';
      //填充时间
      updateBirthday(event!.date);
      //填充性别
      selectedGenderID = event!.gender.toString(); //提交数据
      selectedGenderIndex.value = AppDictList.findIndexByCode(
          chooseTypeList, event!.gender.toString()); //显示选中项
      //填充品种
      selectedBreedID = event!.kind.toString(); //提交数据
      selectedBreedIndex.value = AppDictList.findIndexByCode(
          breedList, event!.kind.toString()); //显示选中项
      //更新栋舍
      selectedHouseID = event!.inCowHouseId;
      selectedHouseName.value = event!.inCowHouseName ?? '';
      // for (var element in houseList) {
      //   if (event!.cowHouseId == element.id) {
      //     //更新栋舍容纳量
      //     cowHouseNum.value = element.occupied.toString();
      //     break;
      //   }
      // }
      //填充栏位
      columnController.text = event!.inColumn ?? '';
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

  void updateBirthday(String date) {
    birthday.value = date;
    update();
  }

  // 更新"栋舍"选中项
  void updateCurCowHouse(String cowHouse, int position) {
    selectedHouseID = houseList[position].id;
    selectedHouseName.value = cowHouse;
    update();
  }

  // 更新 批次号
  void updateBatchNumber(String value) {
    batchNumber.value = value;
    update();
  }

  // 更新公、母
  void updateCurGender(int index) {
    selectedGenderID = chooseTypeList[index]['value'];
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
      Toast.show('请选择批次');
      return;
    }
    String code = codeController.text.trim();
    if (ObjectUtil.isEmpty(code)) {
      Toast.show('请输入耳号');
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
      if (argument is SimpleEvent) {
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
        'batchNo': batchNumber.value, // 批次号
        'cowCode': codeController.text.trim(), // 牛只耳号
        'gender': int.parse(selectedGenderID), // 性别1：公；2：母；
        'kind': int.parse(selectedBreedID), // 品种
        'birth': birthday.value, // 出生日期
        'inCowHouseId': selectedHouseID, // 转入栋舍ID
        'inColumn': columnController.text.trim(), //必传 转入栏位
        'executor': UserInfoTool.nickName(), //必传 技术员
        'date':
            DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d), //
        'remark': remarkController.text.trim(), //必传 备注
      };
      print(para);
      await httpsClient.post("/api/selstock", data: para);
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
        'batchNo': batchNumber.value, // 批次号
        'cowCode': codeController.text.trim(), // 牛只耳号
        'gender': int.parse(selectedGenderID), // 性别1：公；2：母；
        'kind': int.parse(selectedBreedID), // 品种
        'birth': birthday.value, // 出生日期
        'inCowHouseId': selectedHouseID, // 转入栋舍ID
        'inColumn': columnController.text.trim(), //必传 转入栏位
        'executor': UserInfoTool.nickName(), //必传 技术员
        'date':
            DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d), //
        'remark': remarkController.text.trim(), //必传 备注
      };
      //print(para);
      await httpsClient.put("/api/selstock", data: para);
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

  //获取批次详情
  Future<void> getBatchMoreData(String batchId) async {
    try {
      var response = await httpsClient.get(
        "/api/cowbatch/getbybatchno",
        queryParameters: {"batchNo": batchId},
      );
      selectedCowBatch = CowBatch.fromJson(response);
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
