import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../models/cattle.dart';
import '../../../models/cow_house.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/common_service.dart';
import '../../../services/constant.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';
import '../../../services/ex_string.dart';

class CattleEditController extends GetxController {
  //TODO: Implement CattleEditController
  //传入的参数
  Cattle? argument = Get.arguments;
  //输入框
  TextEditingController codeController = TextEditingController();
  TextEditingController eleCodeController = TextEditingController(); //电子耳号
  TextEditingController batchController = TextEditingController();
  TextEditingController sourceController = TextEditingController(); //来源
  TextEditingController columnController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode codeNode = FocusNode();
  final FocusNode eleCodeNode = FocusNode();
  final FocusNode batchNode = FocusNode();
  final FocusNode sourceNode = FocusNode();
  final FocusNode columnNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  //
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(codeNode),
        KeyboardActionsHelper.getDefaultItem(eleCodeNode),
        KeyboardActionsHelper.getDefaultItem(batchNode),
        KeyboardActionsHelper.getDefaultItem(sourceNode),
        KeyboardActionsHelper.getDefaultItem(columnNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  //
  HttpsClient httpsClient = HttpsClient();
  //时间
  final timesStr = ''.obs;
  //出生日期
  final birthStr = ''.obs;
  //生长阶段
  late List szjdList;
  late List<String> szjdNameList;
  //公牛生长阶段
  late List gSzjdList;
  late List<String> gSzjdNameList;
  String szjdCurID = '';
  RxInt szjdCurIndex = 0.obs;

  //品种
  late List pzList;
  late List<String> pzNameList;
  String pzCurID = '';
  RxInt pzCurIndex = 0.obs;

  //公母
  late List gmList;
  late List<String> gmNameList;
  String gmCurID = '';
  RxInt gmCurIndex = 0.obs;

  // "栋舍"可选项
  List<CowHouse> houseList = <CowHouse>[];
  List houseNameList = [];
  String selectedHouseID = ''; //选中的栋舍 ID 提交数据使用
  RxString selectedHouseName = ''.obs;

  //胎次
  String pregnancyCurID = '';
  RxInt pregnancyNumPosition = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //初始化字典项
    szjdList = List.from(AppDictList.searchItems('szjd') ?? []);
    szjdCurID = szjdList.isNotEmpty ? szjdList.first['value'] : '';
    szjdNameList =
        List<String>.from(szjdList.map((item) => item['label']).toList());
    //公牛的生长阶段
    List temp = [];
    for (var element in szjdList) {
      if (element['label'].indexOf('母牛') == -1) {
        temp.add(element);
      }
    }
    gSzjdList = temp;
    gSzjdNameList =
        List<String>.from(gSzjdList.map((item) => item['label']).toList());

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
    //胎次
    pregnancyCurID = '0';
    pregnancyNumPosition.value = 0;

    //首先处理传入参数
    handleArgument();

    //栋舍列表
    houseList = await CommonService().requestCowHouse();
    //获取栋舍列表名称用于 Picker 显示
    houseNameList.addAll(houseList.map((item) => item.name).toList());
  }

  //处理传入参数
  //牛只档案编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    if (argument is Cattle) {
      //填充耳号
      codeController.text = argument!.code ?? '';
      //
      updateGMIndex(
          AppDictList.findIndexByCode(gmList, argument!.gender.toString()));
      if (argument!.gender == 1) {
        //公
        updateSZJD(
            AppDictList.findIndexByCode(
                gSzjdList, argument!.growthStage.toString()),
            0);
      } else {
        updateSZJD(
            AppDictList.findIndexByCode(
                szjdList, argument!.growthStage.toString()),
            1);
      }
      updatePZ(AppDictList.findIndexByCode(pzList, argument!.kind.toString()));
      updatePregnancy(argument?.calvNum ?? 0);
      //填充电子耳号
      eleCodeController.text = argument?.eleCode ?? '';
      //填充来源场
      sourceController.text = argument?.sourceFarm ?? '';
      //填充来源场
      columnController.text = argument?.column ?? '';
      //更新栋舍
      selectedHouseID = argument!.cowHouseId;
      selectedHouseName.value = argument?.cowHouseName ?? '';

      //填充入场时间
      updateSeldate(argument?.inArea ?? '');
      //填充出生日期
      updateBirthday(argument?.birth ?? '');

      //填充备注
      remarkController.text = argument?.remark ?? '';
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

  // 胎次
  void updatePregnancy(int index) {
    pregnancyNumPosition.value = index;
    pregnancyCurID = Constant.pregnancyNumList[index];
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

  //更新生长阶段, type 0 是公牛 1 是母牛
  void updateSZJD(int index, int type) {
    szjdCurIndex.value = index;
    if (type == 0) {
      szjdCurID = gSzjdList[index]['value'];
    } else {
      szjdCurID = szjdList[index]['value'];
    }
    update();
  }

  //更新品种
  void updatePZ(int index) {
    pzCurIndex.value = index;
    pzCurID = pzList[index]['value'];
    update();
  }

  //更新公母
  void updateGMIndex(int index) {
    gmCurIndex.value = index;
    gmCurID = gmList[index]['value'];
    //重置生长阶段的值
    szjdCurIndex.value = 0;
    if (index == 0) {
      szjdCurID = gSzjdList[0]['value'];
    } else {
      szjdCurID = szjdList[0]['value'];
    }
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
    String code = codeController.text.trim();
    if (ObjectUtil.isEmpty(code)) {
      Toast.show('请输入耳号');
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
    //
    editAction();
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
          'code': codeController.text.trim(), //耳号
          'eleCode': eleCodeController.text.trim(), //电子耳号
          'birth': birthStr.value, //出生日期
          'column': columnController.text.trim(), //栏位
          'gender': gmCurID, //公母
          'growthStage': szjdCurID, //生长阶段
          'kind': pzCurID, //品种
          'calvNum': pregnancyCurID, //品种
          'inArea': timesStr.value, //入场时间
          'remark': remarkController.text.trim(), // 备注
        };

        //print(para);
        await httpsClient.put("/api/cow", data: para);
        Toast.dismiss();
        Toast.success(msg: '提交成功');
        //执行跳转  回到上级页面，1 表示更新成功，需要继续返回
        Get.back(result: 1);
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
