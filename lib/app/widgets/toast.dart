import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Toast {
  /// 显示提示 2s消失
  static void show(String msg) {
    SmartDialog.showToast(
      msg,
      displayTime: const Duration(seconds: 2),
      alignment: Alignment.center,
      animationType: SmartAnimationType.fade,
      displayType: SmartToastType.normal,
      /*
      builder: (_) {
        return Center(
          child: Container(
            // width: 200,
            // height: 200,
              color: Colors.amber,
              child: Text(
                msg,
                style: TextStyle(color: Colors.red),
              )),
        );
      },
      */
    );
  }

  /// 显示成功
  static void success({String msg = "成功"}) {
    SmartDialog.showNotify(msg: msg, notifyType: NotifyType.success);
  }

  /// 显示成功
  static void failure({String msg = "失败"}) {
    SmartDialog.showNotify(msg: msg, notifyType: NotifyType.failure);
  }

  /// 显示加载
  static void showLoading({msg = "加载中..."}) {
    SmartDialog.showLoading(
      msg: msg,
      animationType: SmartAnimationType.fade,
    );
  }

  /// 关闭弹窗
  static void dismiss() {
    SmartDialog.dismiss();
  }
}
