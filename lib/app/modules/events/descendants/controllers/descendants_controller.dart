import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../models/cattle.dart';
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

class DescendantsController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  DescendantsModel? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  TextEditingController youngCodeController = TextEditingController(); //犊牛耳号
  TextEditingController weightController = TextEditingController(); //犊牛体重
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode youngCodeNode = FocusNode(); //犊牛耳号
  final FocusNode weightNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(youngCodeNode),
        KeyboardActionsHelper.getDefaultItem(weightNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //当前选中的母牛
  late Cattle selectedCow;
  //母牛耳号
  RxString codeString = ''.obs;

  //当前选中的公牛
  late Cattle selectedBull;
  //公牛耳号
  RxString bullCodeString = ''.obs;

  //母牛耳号 给筛选列表限制条件
  List gmList = [];
  //母牛耳号 过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  //公牛耳号 给筛选列表限制条件
  List bullGmList = [];

  //出生日期
  RxString birth = ''.obs;

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

  // "品种"可选项
  List breedList = [];
  List<String> breedNameList = [];
  String selectedBreedID = ''; //提交数据使用
  RxInt selectedBreedIndex = 0.obs;

  @override
  void onInit() async {
    super.onInit();

    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    birth.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);

    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除公
    gmList.removeWhere((item) => item['label'] == '公');
    //取出公母数组
    bullGmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    bullGmList.removeWhere((item) => item['label'] == '母');

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, [
      '5',
      '6',
      '7',
    ]);

    //公、母
    genderList = AppDictList.searchItems('gm') ?? [];
    selectedGenderID = genderList.isNotEmpty ? genderList.first['value'] : '';
    genderNameList =
        List<String>.from(genderList.map((item) => item['label']).toList());

    //初始化字典项
    breedList = AppDictList.searchItems('pz') ?? [];
    selectedBreedID = breedList.isNotEmpty ? breedList.first['value'] : '';
    breedNameList =
        List<String>.from(breedList.map((item) => item['label']).toList());

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
      //不传值是新增
      return;
    }
    Toast.showLoading();
    if (argument is Cattle) {
      //任务事件
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = DescendantsModel.fromJson(argument.data);
      //获取母牛详情
      selectedCow = await getCattleMoreData(event!.maternalCowId!);
      //填充母牛耳号
      updateCodeString(selectedCow.code ?? '');

      if (ObjectUtil.isNotEmpty(event!.paternalCowId)) {
        //获取公牛详情
        selectedBull = await getCattleMoreData(event!.paternalCowId!);
        //填充公牛耳号
        updateBullCodeString(selectedBull.code ?? '');
      }

      //犊牛耳号
      youngCodeController.text = event?.code ?? '';
      //出生日期
      updateBirth(event!.birth);
      //公母
      selectedGenderID = event!.gender.toString(); //提交数据
      selectedGenderIndex.value =
          AppDictList.findIndexByCode(genderList, selectedGenderID); //显示选中项
      //栋舍
      selectedHouseID = event!.cowHouseId; //选中的接收场 ID 提交数据使用
      selectedHouseName.value = event!.cowHouseName ?? '';
      //品种
      selectedBreedID = event!.kind.toString(); //提交数据
      selectedBreedIndex.value = AppDictList.findIndexByCode(
          breedList, event!.kind.toString()); //显示选中项
      //体重
      weightController.text = event!.birthWeight.toString();
      //登记时间
      updateTimeStr(event!.date);
      //备注
      remarkController.text = event!.remark ?? '';

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

  // 更新 公牛耳号
  void updateBullCodeString(String value) {
    bullCodeString.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  void updateBirth(String date) {
    birth.value = date;
    update();
  }

  // 更新公、母
  void updateCurGender(int index) {
    selectedGenderID = genderList[index]['value'];
    selectedGenderIndex.value = index;
    update();
  }

  // 更新"栋舍"选中项
  void updateCurCowHouse(String cowHouse, int position) {
    selectedHouseID = houseList[position].id;
    // cowHouseNum.value = houseList[position].occupied.toString();
    selectedHouseName.value = cowHouse;
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
    //母牛
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('母牛耳号未获取,请点击选择');
      return;
    }
    //公牛
    // if (ObjectUtil.isEmpty(bullCodeString.value)) {
    //   Toast.show('公牛耳号未获取,请点击选择');
    //   return;
    // }
    //犊牛耳号
    String youngCode = youngCodeController.text.trim();
    if (ObjectUtil.isEmpty(youngCode)) {
      Toast.show('请输入犊牛耳号');
      return;
    }

    //时间不能小于出生日期
    if (timesStr.value.isBefore(birth.value)) {
      Toast.show('登记时间不能早于出生日期');
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
        'maternalCowId': selectedCow.id, // 母系
        //'paternalCowId': selectedBull.id, // 父系
        'code': youngCodeController.text.trim(), //必传 犊牛耳号
        'birth': birth.value, //必传 出生日期
        'birthWeight': weightController.text.trim(), // 犊牛体重（kg）
        'gender': int.parse(selectedGenderID), //必传 性别1：公；2：母
        'kind': int.parse(selectedBreedID), //必传 品种
        'cowHouseId': selectedHouseID, // 必传 string 栋舍
        'date': timesStr.value, //必传 string 时间
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/progeny", data: para);
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
        'maternalCowId': selectedCow.id, // 母系
        'paternalCowId': selectedBull.id, // 父系
        'code': youngCodeController.text.trim(), //必传 犊牛耳号
        'birth': birth.value, //必传 出生日期
        'birthWeight': weightController.text.trim(), // 犊牛体重（kg）
        'gender': int.parse(selectedGenderID), //必传 性别1：公；2：母
        'kind': int.parse(selectedBreedID), //必传 品种
        'cowHouseId': selectedHouseID, // 必传 string 栋舍
        'date': timesStr.value, //必传 string 时间
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.put("/api/progeny", data: para);
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
}
