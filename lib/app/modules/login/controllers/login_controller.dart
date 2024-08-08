import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../models/authModel.dart';
import '../../../network/httpsClient.dart';
import '../../../services/common_service.dart';
import '../../../services/constant.dart';
import '../../../services/storage.dart';
import '../../../services/user_info_tool.dart';

class LoginController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  TextEditingController telController = TextEditingController();
  TextEditingController passController = TextEditingController();
  //
  final FocusNode telNode = FocusNode();
  final FocusNode passNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      // keyboardBarColor: Colors.grey.shade200,
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: telNode,
          displayDoneButton: true,
        ),
        KeyboardActionsItem(
          focusNode: passNode,
          displayDoneButton: true,
        ),
      ],
    );
  }

  //隐私协议勾选框
  RxBool isAgree = false.obs;

  @override
  void onInit() {
    super.onInit();

    if (!Constant.inProduction) {
      // telController.text = "developer";
      // passController.text = "15000000000";
      telController.text = "15000000000";
      passController.text = "15000000000";
    }
  }

  //请求登录数据
  Future<void> requestLogin() async {
    var response = await httpsClient.post("/api/Auth", data: {
      "client_id": Constant.clientId,
      "client_secret": Constant.clientSecret,
      "grant_type": Constant.grantType,
      "account": telController.text,
      "password": passController.text,
      "remember": false,
    });
    // print("----------/api/Auth--------");
    //缓存登录信息
    AuthModel authModel = AuthModel.fromJson(response);
    //写到内存中，方便使用
    UserInfoTool.auth = authModel;
    await Storage.setData(Constant.authData, authModel);

    //请求用户资源+字典项
    CommonService().requestAllUserInfo();

    return Future.value();
  }

  void checkPZ() {
    print(AppDictList.searchItems("pz"));
  }
}
