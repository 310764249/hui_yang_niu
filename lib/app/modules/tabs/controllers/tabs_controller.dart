import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:common_utils/common_utils.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/application/views/application_view.dart';
import 'package:intellectual_breed/app/modules/home/views/home_view.dart';
import 'package:intellectual_breed/app/modules/message/views/message_view.dart';
import 'package:intellectual_breed/app/modules/mine/views/mine_view.dart';
import 'package:intellectual_breed/app/modules/recipe/views/recipe_view.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/event_bus_util.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/common_service.dart';
import '../../../services/constant.dart';
import '../../../services/storage.dart';

class TabsController extends GetxController with WidgetsBindingObserver {
  //切换 index 记录
  RxInt currentIndex = 0.obs;
  //页面控制,默认首页，如果有传值就使用传值
  PageController pageController =
      Get.arguments == null ? PageController(initialPage: 0) : PageController(initialPage: Get.arguments["initialPage"]);

  final List names = [
    "首页",
    "配方",
    "服务",
    "消息",
    "我的",
  ];

  final List<Widget> pages = [
    const HomeView(),
    RecipeView(),
    ApplicationView(),
    MessageView(),
    MineView(),
  ];

  final List<IconData> icons = [Icons.home, Icons.receipt, Icons.medical_services, Icons.message, Icons.people];

  /// 预加载tab图片
  void precacheIcons(BuildContext context) {
    Future.delayed(Duration.zero, () {
      precacheImage(const AssetImage(AssetsImages.homeLine), context);
      precacheImage(const AssetImage(AssetsImages.recipeFill), context);
      precacheImage(const AssetImage(AssetsImages.applicationFill), context);
      precacheImage(const AssetImage(AssetsImages.messageFill), context);
      precacheImage(const AssetImage(AssetsImages.mineFill), context);
    });
  }

  // tab line icons
  final List<Image> tabLineIcons = [
    Image.asset(AssetsImages.homeLine),
    Image.asset(AssetsImages.recipeLine),
    Image.asset(AssetsImages.applicationLine),
    Image.asset(AssetsImages.messageLine),
    Image.asset(AssetsImages.mineLine),
  ];

  // tab fill icons
  final List<Image> tabFillIcons = [
    Image.asset(AssetsImages.homeFill),
    Image.asset(AssetsImages.recipeFill),
    Image.asset(AssetsImages.applicationFill),
    Image.asset(AssetsImages.messageFill),
    Image.asset(AssetsImages.mineFill),
  ];

  //消息中心未读消息数量
  RxInt unReadMsgs = 0.obs;

  // 消息订阅
  late StreamSubscription<ConnectivityResult> subscription;

  //
  void setCurrentIndex(index) {
    //注意切换时要重新赋值
    currentIndex.value = index;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    //2.页面初始化的时候，添加一个状态的监听者
    WidgetsBinding.instance.addObserver(this);

    //实时监听网络状态
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      // Got a new connectivity status!
      if (result == ConnectivityResult.mobile) {
        debugPrint('成功连接移动网络');
        Toast.success(msg: '成功连接移动网络');
      } else if (result == ConnectivityResult.wifi) {
        debugPrint('成功连接WIFI');
        Toast.success(msg: '成功连接WIFI');
      } else if (result == ConnectivityResult.ethernet) {
        debugPrint('成功连接到以太网');
      } else if (result == ConnectivityResult.vpn) {
        debugPrint('成功连接vpn网络');
      } else if (result == ConnectivityResult.bluetooth) {
        debugPrint('成功连接蓝牙');
      } else if (result == ConnectivityResult.other) {
        debugPrint('成功连接除以上以外的网络');
      } else if (result == ConnectivityResult.none) {
        debugPrint('没有连接到任何网络');
        Alert.showConfirm(
          '没有连接到任何网络,请连接网络！',
          confirm: '设置',
          onConfirm: () {
            AppSettings.openAppSettings(type: AppSettingsType.wifi);
          },
        );
      }
    });

    //监听用户登录状态
    EventBusUtil.addListener<UserLogInEvent>((event) {
      if (event.state == UserState.Logout) {
        Get.toNamed(Routes.LOGIN);
      }
    });
    checkUpdate();
  }

  checkUpdate() async {
    HttpsClient httpsClient = HttpsClient();

    var res = await httpsClient.get("/api/appfile/check");
    debugPrint('检查更新: $res');
  }

  @override
  void onClose() {
    subscription.cancel();
    super.onClose();
    //3. 页面销毁时，移出监听者
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void onReady() async {
    super.onReady();

    //每次启动需要请求字典项
    var auth = await Storage.getData(Constant.authData);
    if (auth == null) {
      Get.toNamed(Routes.LOGIN);
    } else {
      //请求用户资源+字典项
      await CommonService().requestAllUserInfo();
    }
  }

  // 当前时间, 用于返回键判断对比
  DateTime? currentBackPressTime;

  /// 处理返回键事件: 返回 true 表示允许退出应用，返回 false 表示阻止退出应用
  Future<bool> onBackPressed(BuildContext context) {
    if (ObjectUtil.isEmpty(currentBackPressTime) ||
        DateTime.now().difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = DateTime.now();
      Toast.show('再次点击返回键退出应用');
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  //一些状态改变监听方法
  //监听程序进入前后台的状态改变的方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        print("应用进入前台======");
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
      default:
        print("应用处于Default case状态======");
        break;
    }
    //发送全局通知
    EventBusUtil.fireEvent(AppStateEvent(state));
  }
}
