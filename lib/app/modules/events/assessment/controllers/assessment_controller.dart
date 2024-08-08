import 'package:get/get.dart';
import 'package:flutter/material.dart';

import 'package:common_utils/common_utils.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../../models/cattle.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class AssessmentController extends GetxController {
  //传入的参数
  var argument = Get.arguments;

  //是否是编辑页面
  RxBool isEdit = false.obs;
  //编辑事件传入
  AssessmentModel? event;

  //输入框
  TextEditingController youngCodeController = TextEditingController(); //犊牛耳号
  TextEditingController estimateController = TextEditingController(); //育种值估计
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode youngCodeNode = FocusNode(); //犊牛耳号
  final FocusNode estimateNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(youngCodeNode),
        KeyboardActionsHelper.getDefaultItem(estimateNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //当前选中的牛
  Cattle? selectedCow;
  //母牛耳号
  final codeString = ''.obs;
  //选中的牛只是否是公牛，默认不是
  RxBool isBull = false.obs;

  //给筛选列表限制条件
  List gmList = [];
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  //评估选项
  List pgList = [];
  List<String> pgNameList = [];
  // RxInt selectedPgIndex = 0.obs;
  //前胸
  String frontChestPgID = '';
  RxInt frontChestPgIndex = (-1).obs;
  //四肢
  String legsPgID = '';
  RxInt legsPgIndex = (-1).obs;
  //站立姿势
  String gesturePgID = '';
  RxInt gesturePgIndex = (-1).obs;
  //驱臀
  String buttockPgID = '';
  RxInt buttockPgIndex = (-1).obs;
  //睾丸（公）
  String testicularPgID = '';
  RxInt testicularPgIndex = (-1).obs;
  //乳房（母）
  String breastsPgID = '';
  RxInt breastsPgIndex = (-1).obs;
  //阴户（母）
  String genitaliaPgID = '';
  RxInt genitaliaPgIndex = (-1).obs;

  // "遗传缺陷"
  List flawsList = [];
  List<String> flawsNameList = [];
  String curFlawsID = '';
  RxInt curFlawsIndex = (-1).obs;

  //综合评分
  List<String> finalPGList = ['1', '2', '3', '4', '5'];
  RxInt finalPgIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    //默认当前
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);

    //取出公母数组
    gmList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    gmList.removeWhere((item) => item['label'] == '母');

    // 获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['3', '4']);
    // 评估选项
    pgList = AppDictList.searchItems('pgxx') ?? [];
    pgNameList =
        List<String>.from(pgList.map((item) => item['label']).toList());
        /*
    //前胸
    frontChestPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //四肢
    legsPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //站立姿势
    gesturePgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //驱臀
    buttockPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //睾丸（公）
    testicularPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //乳房（母）
    breastsPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    //阴户（母）
    genitaliaPgID = pgList.isNotEmpty ? pgList.first['value'] : '';
    */
    // 遗传缺陷
    flawsList = AppDictList.searchItems('ycqx') ?? [];
    //curFlawsID = flawsList.isNotEmpty ? flawsList.first['value'] : '';
    flawsNameList =
        List<String>.from(flawsList.map((item) => item['label']).toList());

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
      updateCodeString(selectedCow!.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = AssessmentModel.fromJson(argument.data);
      //填充耳号
      updateCodeString(event?.cowCode ?? '');
      //获取牛只详情
      await getCattleMoreData(event!.cowId);
      //前胸
      frontChestPgID = event!.forebreast.toString(); //提交数据
      frontChestPgIndex.value =
          AppDictList.findIndexByCode(pgList, frontChestPgID); //显示选中项
      //四肢
      legsPgID = event!.allFours.toString(); //提交数据
      legsPgIndex.value = AppDictList.findIndexByCode(pgList, legsPgID); //显示选中项
      //站立姿势
      gesturePgID = event!.stance.toString(); //提交数据
      gesturePgIndex.value =
          AppDictList.findIndexByCode(pgList, gesturePgID); //显示选中项
      //驱臀
      buttockPgID = event!.hipDrive.toString(); //提交数据
      buttockPgIndex.value =
          AppDictList.findIndexByCode(pgList, buttockPgID); //显示选中项
      //睾丸（公）
      testicularPgID = event!.testis.toString(); //提交数据
      testicularPgIndex.value =
          AppDictList.findIndexByCode(pgList, testicularPgID); //显示选中项
      //乳房（母）
      breastsPgID = event!.breast.toString(); //提交数据
      breastsPgIndex.value =
          AppDictList.findIndexByCode(pgList, breastsPgID); //显示选中项
      //阴户（母）
      genitaliaPgID = event!.vulva.toString(); //提交数据
      genitaliaPgIndex.value =
          AppDictList.findIndexByCode(pgList, genitaliaPgID); //显示选中项
      // 遗传缺陷
      curFlawsID = event!.geneticDefect.toString(); //提交数据
      curFlawsIndex.value =
          AppDictList.findIndexByCode(flawsList, curFlawsID); //显示选中项
      // 综合评分
      finalPgIndex.value = event!.score!.toInt() - 1; //提交数据
      //填充时间
      updateTimeStr(event!.date);
      // 备注
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
    if (ObjectUtil.isNotEmpty(selectedCow)) {
      isBull.value = selectedCow!.gender == 1 ? true : false;
    }
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 更新前胸
  void updateFrontChestPg(int index) {
    frontChestPgID = pgList[index]['value'];
    frontChestPgIndex.value = index;
    update();
  }

  //四肢
  void updateLegsPg(int index) {
    legsPgID = pgList[index]['value'];
    legsPgIndex.value = index;
    update();
  }

  //站立姿势
  void updateGesturePg(int index) {
    gesturePgID = pgList[index]['value'];
    gesturePgIndex.value = index;
    update();
  }

  //驱臀
  void updateButtockPg(int index) {
    buttockPgID = pgList[index]['value'];
    buttockPgIndex.value = index;
    update();
  }

  //睾丸（公）
  void updateTesticularPg(int index) {
    testicularPgID = pgList[index]['value'];
    testicularPgIndex.value = index;
    update();
  }

  //乳房（母）
  void updateBreastsPg(int index) {
    breastsPgID = pgList[index]['value'];
    breastsPgIndex.value = index;
    update();
  }

  //遗传缺陷
  void updateFlaws(int index) {
    curFlawsID = flawsList[index]['value'];
    curFlawsIndex.value = index;
    update();
  }

  //阴户（母）
  void updateGenitaliaPg(int index) {
    genitaliaPgID = pgList[index]['value'];
    genitaliaPgIndex.value = index;
    update();
  }

  //综合评分
  void updateFinalPg(int index) {
    finalPgIndex.value = index;
    update();
  }

  // 提交数据
  void requestCommit() async {
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
        'cowId': selectedCow!.id, // 牛只ID
        'date': timesStr.value, // 评估日期
        'forebreast': frontChestPgID, // 前胸
        'allFours': legsPgID, // 四肢
        'stance': gesturePgID, // 站立姿势
        'hipDrive': buttockPgID, // 驱臀
        'testis': isBull.value ? testicularPgID : null, // 睾丸
        'breast': isBull.value ? null : breastsPgID, // 乳房
        'vulva': isBull.value ? null : genitaliaPgID, // 阴户
        'geneticDefect': curFlawsID, // 遗传缺陷 1：有；2：无；
        'score': finalPgIndex.value + 1, // 综合评分 1-5分
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.post("/api/surfacemeasure", data: para);
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

  //新增事件
  void editAction() async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': event!.id, //事件 ID
        'rowVersion': event!.rowVersion, //事件行版本
        'cowId': selectedCow!.id, // 牛只ID
        'date': timesStr.value, // 评估日期
        'forebreast': frontChestPgID, // 前胸
        'allFours': legsPgID, // 四肢
        'stance': gesturePgID, // 站立姿势
        'hipDrive': buttockPgID, // 驱臀
        'testis': isBull.value ? testicularPgID : null, // 睾丸
        'breast': isBull.value ? null : breastsPgID, // 乳房
        'vulva': isBull.value ? null : genitaliaPgID, // 阴户
        'geneticDefect': curFlawsID, // 遗传缺陷 1：有；2：无；
        'score': finalPgIndex.value + 1, // 综合评分 1-5分
        'executor': UserInfoTool.nickName(), // string 技术员
        'remark': remarkController.text.trim(), // 备注
      };
      //print(para);
      await httpsClient.put("/api/surfacemeasure", data: para);
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
