import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/cupertino.dart';
import 'package:intellectual_breed/app/models/access_token_response.dart';

import '../../network/httpsClient.dart';

class ChatRoomUtils {
  ChatRoomUtils._();

  static const String publicRoomId = '288414127685633';

  static init() async {
    await ChatUIKit.instance.init(
      options: EMOptions.withAppKey('1191250723193069#huiyangniu20250723', debugMode: true),
    );
    await login();
  }

  static Future login() async {
    try {
      HttpsClient httpsClient = HttpsClient();
      var response = await httpsClient.get("/api/user/getimtoken");
      AccessTokenResponse accessToken = AccessTokenResponse.fromJson(response);
      await ChatUIKit.instance.loginWithToken(
        userId: accessToken.user.username,
        token: accessToken.accessToken,
      );
      debugPrint('IM 登录成功');
    } catch (e) {
      debugPrint('IM 登录失败$e');
    }
  }

  //退出登录
  static logout() async {
    await ChatUIKit.instance.logout();
  }
}
