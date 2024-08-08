import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/farmer.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/common_service.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../services/user_info_tool.dart';
import '../../../widgets/dict_list.dart';

class RecordCenterController extends GetxController {
  //输入框
  TextEditingController nameController = TextEditingController(); //养殖户名称
  TextEditingController codeController = TextEditingController(); //养殖户编码
  TextEditingController peopleController = TextEditingController(); //联系人
  TextEditingController phoneController = TextEditingController(); //联系电话
  TextEditingController descController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode nameNode = FocusNode();
  final FocusNode codeNode = FocusNode();
  final FocusNode peopleNode = FocusNode();
  final FocusNode phoneNode = FocusNode();
  final FocusNode descNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(nameNode),
        KeyboardActionsHelper.getDefaultItem(codeNode),
        KeyboardActionsHelper.getDefaultItem(peopleNode),
        KeyboardActionsHelper.getDefaultItem(phoneNode),
        KeyboardActionsHelper.getDefaultItem(descNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //如果有数据表示编辑
  FarmerModel? curData;

  // "牛场性质"可选项
  List passList = [];
  List<String> passNameList = [];
  String curPassID = '';
  RxInt curPassIndex = 0.obs;

  //机构列表
  List orgTreeData = [];
  //选中的机构数据
  Map selOrgData = {};
  //选中的机构数据
  RxString selOrgName = ''.obs;

  //行政区划
  List areaTreeData = [];
  //选中的行政区划数据
  Map selAreaData = {};
  //选中的行政区划数据
  RxString selAreaName = ''.obs;

  //地理位置
  double lat = 0.0;
  double lng = 0.0;
  RxString selAddressName = ''.obs;

  @override
  void onInit() async {
    super.onInit();

    //初始化字典项
    passList = AppDictList.searchItems('ncxz') ?? [];
    curPassID = passList.isNotEmpty ? passList.first['value'] : '';
    passNameList =
        List<String>.from(passList.map((item) => item['label']).toList());

    Toast.showLoading();
    //获取机构列表
    orgTreeData = await CommonService().requestOrgAll();
    //获取行政区划
    areaTreeData = await CommonService().requestAreaAll();
    //备案详情
    await requestDetail();
    //
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

  // 更新表现
  void updatePass(int index) {
    curPassID = passList[index]['value'];
    curPassIndex.value = index;
    update();
  }

  // 更新机构
  void updateOrgName(Map selectItem) {
    selOrgData = selectItem;
    selOrgName.value = selectItem['label'];
    update();
  }

  // 更新行政区划
  void updateAreaName(Map selectItem) {
    selAreaData = selectItem;
    selAreaName.value = selectItem['label'];
    update();
  }

  // 更新地址
  void updateAddress(Map info) {
    lat = info['lat'];
    lng = info['lng'];
    selAddressName.value = info['address'];
    update();
  }

  // 提交数据
  void requestCommit() async {
    String name = nameController.text.trim();
    if (ObjectUtil.isEmpty(name)) {
      Toast.show('请输入养殖户名称');
      return;
    }

    String code = codeController.text.trim();
    if (ObjectUtil.isEmpty(code)) {
      Toast.show('请输入养殖户编码');
      return;
    }

    if (ObjectUtil.isEmpty(selOrgName.value)) {
      Toast.show('请选择所属机构');
      return;
    }

    if (ObjectUtil.isEmpty(selAreaName.value)) {
      Toast.show('请选择所属辖区');
      return;
    }

    String people = peopleController.text.trim();
    if (ObjectUtil.isEmpty(people)) {
      Toast.show('请输入联系人');
      return;
    }

    String phone = phoneController.text.trim();
    if (ObjectUtil.isEmpty(phone)) {
      Toast.show('请输入联系电话');
      return;
    }

    if (ObjectUtil.isEmpty(selAddressName.value)) {
      Toast.show('请选择详细地址');
      return;
    }

    if (curData == null) {
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
        'name': nameController.text.trim(),
        'code': codeController.text.trim(),
        'type': curPassID,
        'principal': peopleController.text.trim(),
        'phone': phoneController.text.trim(),
        'description': descController.text.trim(),
        'lng': lng,
        'lat': lat,
        'orgCode': selOrgData['value'],
        'areaCode': selOrgData['value'],
        'address': selAddressName.value,
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.post("/api/farmer", data: para);
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
        'id': curData!.id, //事件 ID
        'rowVersion': curData!.rowVersion, //事件行版本
        'name': nameController.text.trim(),
        'code': codeController.text.trim(),
        'type': curPassID,
        'principal': peopleController.text.trim(),
        'phone': phoneController.text.trim(),
        'description': descController.text.trim(),
        'lng': lng,
        'lat': lat,
        'orgCode': selOrgData['value'],
        'areaCode': selAreaData['value'],
        'address': selAddressName.value,
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/farmer", data: para);
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

  //请求用户资源数据
  Future<void> requestDetail() async {
    try {
      //print("----------/api/user/resource--------");
      var response =
          await httpsClient.get("/api/farmer/${UserInfoTool.farmerId()}");
      FarmerModel model = FarmerModel.fromJson(response);
      curData = model;
      //填充数据
      //牛场性质
      curPassID = model.type.toString(); //提交数据
      curPassIndex.value =
          AppDictList.findIndexByCode(passList, curPassID); //显示选中项
      nameController.text = model.name ?? '';
      codeController.text = model.code ?? '';
      peopleController.text = model.principal ?? '';
      phoneController.text = model.phone ?? '';
      descController.text = model.description ?? '';
      remarkController.text = model.remark ?? '';
      //机构
      selOrgData = {'value': model.orgCode};
      selOrgName.value =
          getLabelFromValue(orgTreeData[0], model.orgCode!) ?? '';
      //辖区
      selAreaData = {'value': model.areaCode};
      selAreaName.value =
          getLabelFromValue(areaTreeData[0], model.areaCode!) ?? '';
        print('${selAreaName.value} ---- ${model.areaCode}');
      //经纬度、地址
      lat = model.lat ?? 0.0;
      lng = model.lng ?? 0.0;
      selAddressName.value = model.address ?? '';

      update();

      return Future.value();
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //通过value获取label
  String? getLabelFromValue(Map<String, dynamic> data, String targetValue) {
    if (data["value"] == targetValue) {
      return data["label"];
    }

    if (data["children"] != null) {
      for (var child in data["children"]) {
        var result = getLabelFromValue(child, targetValue);
        if (result != null) {
          return result;
        }
      }
    }

    return null;
  }
}
