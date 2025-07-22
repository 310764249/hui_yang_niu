import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:jpush_flutter/jpush_interface.dart';

import '../routes/app_pages.dart';
//https://github.com/jpush/jpush-flutter-plugin/blob/master/documents/APIs.md

class JPushTool {
  //当前设备的 推送 ID
  static String getRegistrationID = '';
  //用户点击的推送消息 附加的参数
  static Map? curExtras;

  // 初始化设置、业务处理
  static void setup() {
    JPushFlutterInterface jpush = JPush.newJPush();
    //注意：addEventHandler 方法建议放到 setup 之前，其他方法需要在 setup 方法之后调用，
    try {
      jpush.addEventHandler(
        // 接收通知回调方法。
        onReceiveNotification: (Map<String, dynamic> message) async {
          print("flutter onReceiveNotification: $message");
        },
        /*
{extras: {newsid: 我是附加字段, _j_data_: {"data_msgtype":1,"push_type":8,"is_vip":0}}, newsid: 我是附加字段, _j_uid: 71490906337, _j_msgid: 18101038069301605, aps: {alert: {title: 我是标题, body: 我是body}, badge: 1, sound: default}, _j_data_: {"data_msgtype":1,"push_type":8,"is_vip":0}, _j_business: 1}

{alert: 我是内容, extras: {cn.jpush.android.ALERT_TYPE: -1, cn.jpush.android.NOTIFICATION_ID: 514786163, cn.jpush.android.MSG_ID: 18101032796713638, cn.jpush.android.ALERT: 我是内容, cn.jpush.android.EXTRA: {"newsid":"我是附加字段"}}, title: 我是标题}
      */
        // 点击通知回调方法。
        onOpenNotification: (Map<String, dynamic> message) async {
          print("flutter onOpenNotification: $message");

          //清除小红点
          jpush.setBadge(0);
          //
          //判断有无参数传递
          var extras = message['extras'];
          if (extras == null) {
            return;
          }
          //处理消息
          if (Platform.isIOS) {
            // ios相关代码
            //先保存住信息，合适的时机处理
            //print('extras--${extras.runtimeType}');
            curExtras = extras;
          } else if (Platform.isAndroid) {
            // android相关代码
            //这里取到的是 JSON 字符串
            var realExtras = extras['cn.jpush.android.EXTRA'];
            //先保存住信息，这里需要把 JSON 转为 Map
            curExtras = json.decode(realExtras);
          } else {
            // 其他平台
          }
          //print('curExtras--${curExtras.runtimeType}');
          Future.delayed(const Duration(milliseconds: 500), () {
            //Alert.showConfirm(JPushTool.curExtras.toString());
            if (JPushTool.curExtras != null) {
              Map temp = JPushTool.curExtras!;
              Get.toNamed(Routes.ACTION_MESSAGE_LIST, arguments: temp['category']);
            }
          });
        },
        // 接收自定义消息回调方法。
        onReceiveMessage: (Map<String, dynamic> message) async {
          print("flutter onReceiveMessage: $message");
        },

        onConnected: (Map<String, dynamic> message) async {
          print('===================> onConnected(): $message');
        },
      );
    } catch (e) {
      print('xxx - 极光sdk配置异常: $e');
    }
    /*
    添加初始化方法，调用 setup 方法会执行两个操作：
      初始化 JPush SDK
      将缓存的事件下发到 dart 环境中。
      注意： 插件版本 >= 0.0.8 android 端支持在 setup 方法中动态设置 channel，动态设置的 channel 优先级比 manifestPlaceholders 中的 JPUSH_CHANNEL 优先级要高。
    */
    jpush.setup(
      appKey: Constant.JPushAppKey,
      channel: "theChannel",
      production: Constant.inProduction, //注意推送环境
      debug: false, // 设置是否打印 debug 日志
    );

    // 获取 registrationId，这个 JPush 运行通过 registrationId 来进行推送.
    jpush.getRegistrationID().then((rid) {
      //保存获取到的 registrationId
      getRegistrationID = rid;

      print('jpush getRegistrationID--$rid');
    });

    //iOS Only
    //申请推送权限，注意这个方法只会向用户弹出一次推送权限请求（如果用户不同意，之后只能用户到设置页面里面勾选相应权限），需要开发者选择合适的时机调用。
    //注意： iOS10+ 可以通过该方法来设置推送是否前台展示，是否触发声音，是否设置应用角标 badge
    jpush.applyPushAuthority(const NotificationSettingsIOS(sound: true, alert: true, badge: true));
    //iOS Only
    //获取 iOS 点击推送启动应用的那条通知。
    jpush.getLaunchAppNotification().then((map) {});
  }
}

/// 推送获取的相关参数
class PushInfo {
  late final String? cowId;
  late final int? category;
  late final int? type;

  PushInfo({
    this.cowId,
    this.category,
    this.type,
  });

  PushInfo.fromJson(Map<String, dynamic> json) {
    cowId = json['cowId'];
    category = json['category'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cowId'] = cowId;
    data['category'] = category;
    data['type'] = type;
    return data;
  }
}
