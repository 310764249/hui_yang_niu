import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';

import '../routes/app_pages.dart';

class LoginMiddleware extends GetMiddleware {
  @override
  // 优先级越低越先执行
  int? get priority => 1;
  @override
  RouteSettings? redirect(String? route) {
    if (UserInfoTool.isLogin()) {
      return super.redirect(route);
    } else {
      return const RouteSettings(name: Routes.LOGIN);
    }
  }
}
