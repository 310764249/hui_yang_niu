import 'package:intellectual_breed/app/models/user_resource.dart';

import '../models/authModel.dart';

class UserInfoTool {
  static UserResource? user;
  static AuthModel? auth;

  //用户是否登录
  static bool isLogin() {
    return user == null ? false : true;
  }

  //用户ID
  static String? userID() {
    return user?.userId;
  }

  //用户昵称
  static String? nickName() {
    return user?.nickName;
  }

  //用户手机号
  static String? phone() {
    return user?.phone;
  }

  //用户头像
  static String? avatarUrl() {
    return user?.avatarUrl;
  }

  //
  static String? farmerId() {
    return user?.farmerId;
  }

  //accessToken
  static String? accessToken() {
    return auth?.accessToken;
  }
}
