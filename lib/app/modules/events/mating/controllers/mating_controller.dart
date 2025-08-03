import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';
import 'package:intellectual_breed/app/models/stock.dart';
import 'package:intellectual_breed/app/services/common_service.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/ex_string.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class MatingController extends GetxController {
  //TODO: Implement MatingController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  MatingEvent? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;
  //输入框
  TextEditingController countController = TextEditingController(); //份数
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
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
  //时间
  final timesStr = ''.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;

  //当前选中配种的公牛
  late Cattle selectedBull;
  //耳号
  final bullCode = ''.obs;

  // "配种类型"可选项
  List chooseTypeList = [];
  List<String> chooseTypeNameList = [];
  // "配种类型"选中项: 默认第一项
  RxString chooseTypeID = ''.obs;
  RxInt chooseTypeIndex = 0.obs;

  // "编号"可选项
  List<Stock> numberList = <Stock>[];
  List<String> numberNameList = [];
  RxString selectNumName = ''.obs;
  String selectNumVale = '';
  //给筛选列表限制条件 公
  List gList = [];
  //给筛选列表限制条件 母
  List mList = [];

  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  @override
  void onInit() async {
    super.onInit();
    //首先处理传入参数
    handleArgument();
    //默认当前
    timesStr.value = DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //取出公母数组
    mList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除公
    mList.removeWhere((item) => item['label'] == '公');
    //取出公母数组
    gList = List.from(AppDictList.searchItems('gm') ?? []);
    //删除母
    gList.removeWhere((item) => item['label'] == '母');

    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示后备母牛和空怀母牛
    szjdListFiltered = AppDictList.findMapByCode(szjdList, ['3', '4', '7']);

    //初始化字典项
    chooseTypeList = AppDictList.searchItems('pzfs') ?? [];
    chooseTypeID.value = chooseTypeList.isNotEmpty ? chooseTypeList.first['value'] : '';
    chooseTypeNameList = List<String>.from(chooseTypeList.map((item) => item['label']).toList());
    //精液编号
    numberList = await CommonService().requestStockAll(1);
    numberNameList.addAll(numberList.map((item) => item.no ?? '').toList());
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
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = MatingEvent.fromJson(argument.data);
      //获取牛只详情
      selectedCow = await getCattleMoreData(event!.cowId!);
      updateCodeString(event?.cowCode ?? '');
      //填充本交/人工受精
      if (event!.type == 1) {
        updateChooseTypeIndex(0);
        bullCode.value = event!.maleCowCode ?? '';
        //获取公牛详情
        selectedBull = await getCattleMoreData(event!.maleCowId);
      } else {
        updateChooseTypeIndex(1);
        selectNumVale = event!.semenNumber ?? '';
        selectNumName.value = event!.semenNumber ?? '';
        countController.text = event!.copies == 0 ? '' : event!.copies.toString();
      }
      //填充时间
      updateTimeStr(event!.date);
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

  // 更新 公牛耳号
  void updateBullCodeString(String value) {
    bullCode.value = value;
    update();
  }

  void updateTimeStr(String date) {
    timesStr.value = date;
    update();
  }

  // 更新"配种类型"选中项
  void updateChooseTypeIndex(int index) {
    chooseTypeID.value = chooseTypeList[index]['value'];
    chooseTypeIndex.value = index;
    if (chooseTypeID.value == '1') {
      //本交
      selectNumName.value = '';
      selectNumVale = '';
      countController.text = '';
    } else {
      //人工受精
      bullCode.value = '';
    }
    update();
  }

  // 更新"编号"选中项
  void updateCurNumber(String name, int position) {
    selectNumVale = numberList[position].no ?? '';
    selectNumName.value = name;
    update();
  }

  // 提交数据
  void requestCommit() async {
    //母牛
    if (ObjectUtil.isEmpty(codeString.value)) {
      Toast.show('耳号未获取,请点击耳号选择');
      return;
    }

    if (chooseTypeID.value == '1') {
      //本交
      // if (ObjectUtil.isEmpty(bullCode.value)) {
      //   Toast.show('请选择公牛耳号');
      //   return;
      // }
    } else {
      //人工受精
      // if (ObjectUtil.isEmpty(selectNumVale)) {
      //   Toast.show('请选择精液编号');
      //   return;
      // }
      // String count = countController.text.trim();
      // if (ObjectUtil.isEmpty(count)) {
      //   Toast.show('请填写份数');
      //   return;
      // }
    }

    //时间不能小于入场日期
    if (timesStr.value.isBefore(selectedCow.inArea)) {
      Toast.show('配种时间不能早于入场日期');
      return;
    }
    //时间不能小于出生日期
    if (timesStr.value.isBefore(selectedCow.birth)) {
      Toast.show('配种时间不能早于出生日期');
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
        'type': chooseTypeID.value, //必传 integer 配种方式1：本交；2：人工输精；
        'maleCowId': bullCode.value.isEmpty ? '' : selectedBull.id, //必传 string 公牛ID
        'semenNumber': selectNumVale, // string 精液编号
        'copies': countController.text.trim(), //必传 integer 精液份数
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 配种时间
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.post("/api/mating", data: para);
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
        'type': chooseTypeID.value, //必传 integer 配种方式1：本交；2：人工输精；
        'maleCowId': bullCode.value.isEmpty ? '' : selectedBull.id, //必传 string 公牛ID
        'semenNumber': selectNumVale, // string 精液编号
        'copies': countController.text.trim(), //必传 integer 精液份数
        'executor': UserInfoTool.nickName(), // string 技术员
        'date': timesStr.value, //必传 string 配种时间
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/mating", data: para);
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
      var response = await httpsClient.get("/api/cow/$cowId");
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
