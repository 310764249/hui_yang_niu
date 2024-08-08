import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// 作为 flutter_screenutil 与实际使用的中间层，规避第三方库随时改 API 的问题
class ScreenAdapter {
  static width(num v) {
    return v.w;
  }

  static height(num v) {
    return v.h;
  }

  static fontSize(num v) {
    return v.sp;
  }

  static getScreenWidth() {
    // return  ScreenUtil().screenWidth;
    return 1.sw;
  }

  static getScreenHeight() {
    // return  ScreenUtil().screenHeight;
    return 1.sh;
  }

  //状态栏高度 刘海屏会更高
  static getStatusBarHeight() {
    return ScreenUtil().statusBarHeight;
  }

  //导航栏高度
  static getNavBarHeight() {
    return AppBar().preferredSize.height;
  }

  //底部安全区距离，适用于全面屏下面有按键的
  static getBottomBarHeight() {
    return ScreenUtil().bottomBarHeight;
  }
}
