import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/common_service.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../network/apiException.dart';
import '../../../network/file_upload.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/constant.dart';
import '../../../services/event_bus_util.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../services/storage.dart';
import '../../../services/user_info_tool.dart';
import '../../../widgets/toast.dart';

class UserProfileController extends GetxController {
  //TODO: Implement UserProfileController

  //输入框
  TextEditingController nameController = TextEditingController(); 
  TextEditingController remarkController = TextEditingController();
  //
  final FocusNode nameNode = FocusNode();
  final FocusNode remarkNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(nameNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  //头像地址
  RxString iconUrl = AssetsImages.avatar.obs;
  //手机号
  final phoneString = ''.obs;
  //昵称
  final nameString = ''.obs;
  //userId
  String userId = '';
  //rowVersion
  String rowVersion = '';
  //account
  String account = '';

  @override
  void onInit() async {
    super.onInit();
    // 获取用户信息
    var res = await Storage.getData(Constant.userResData);
    userId = res['userId'];
    getUserData(userId);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //更新头像
  void updateHeader(path) async {
    Toast.showLoading();
    try {
      //上传图片
      String ID = await FileUploadTool().uploadWith(path);
      iconUrl.value = '${Constant.uploadFileUrl}$ID';
      //更新
      await httpsClient.post("/api/user/uploadprofilephoto",
          data: {"id": UserInfoTool.userID(), "avatarUrl": ID});
      Toast.dismiss();
      Toast.success(msg: '头像上传成功');
      //通知头像更新
      EventBusUtil.fireEvent(UserIconChangeEvent(ID));
      update();
      await CommonService().requestAllUserInfo();
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
  Future<void> getUserData(String userID) async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get(
        "/api/user/$userID",
      );
      Toast.dismiss();
      //print(response);
      if (ObjectUtil.isNotEmpty(response)) {
        Map<String, dynamic> map = response;
        rowVersion = map['rowVersion'];
        userId = map['id'];
        String? avataID = map['avatarUrl'];
        if (ObjectUtil.isNotEmpty(avataID)) {
          iconUrl.value = Constant.uploadFileUrl + avataID!;
        }
        account = map['account'];
        phoneString.value = map['phone'];
        nameController.text = map['nickName'];
        remarkController.text = map['remark'];
      }
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
    String name = nameController.text.trim();
    if (ObjectUtil.isEmpty(name)) {
      Toast.show('请输入用户昵称');
      return;
    }
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': userId, //ID
        'rowVersion': rowVersion, //事件行版本
        'nickName': name, // 昵称
        'account': account, //账号
        'phone': phoneString.value, //必传 integer 断奶头数
        'remark': remarkController.text.trim(), // 备注
      };

      await httpsClient.put("/api/user", data: para);
      await CommonService().requestAllUserInfo();
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
