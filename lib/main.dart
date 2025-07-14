// import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/event_bus_util.dart';
import 'package:intellectual_breed/app/services/storage.dart';

import 'app/routes/app_pages.dart';
import 'app/services/JPush_tool.dart';
import 'app/services/constant.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //配置透明的状态栏
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // 创建一个Alice实例并传入Navigator的key以便路由导航
  // final alice = Alice(
  //     showNotification: Platform.isAndroid ? true : false,
  //     showInspectorOnShake: true,
  //     darkTheme: Platform.isIOS ? true : false,
  //     navigatorKey: GlobalKey<NavigatorState>());
  // Constant.navigatorKey = alice.getNavigatorKey();

  //初始化单例 EventBusUtil
  EventBusUtil();

  //初始化推送服务
  JPushTool.setup();

  // 用flutter_screenutil来自动适配
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  ValueNotifier<bool> isOpenBigFont = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    Storage.getBool(Constant.isOpenBigFont).then((value) {
      isOpenBigFont.value = value;
    });
    EventBusUtil.addListener<String>((event) {
      if (event == 'bigFont') {
        Storage.getBool(Constant.isOpenBigFont).then((value) {
          isOpenBigFont.value = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 813), // 指定设计图尺寸
        minTextAdapt: true, // 是否根据宽度/高度中的最小值适配文字
        splitScreenMode: true, // 支持分屏尺寸
        builder: (context, child) {
          return GetMaterialApp(
            title: "慧养牛",
            initialRoute: AppPages.INITIAL,
            getPages: AppPages.routes,
            debugShowCheckedModeBanner: false,
            // navigatorKey: alice.getNavigatorKey(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: const [
              Locale('zh', 'CH'),
              Locale('en', 'US'),
            ],
            theme: ThemeData(
                primarySwatch: Colors.grey, splashColor: Colors.transparent, scaffoldBackgroundColor: SaienteColors.whiteF8F9FD),
            //页面默认背景色
            defaultTransition: Transition.rightToLeft,
            // Chucker setting
            navigatorObservers: [FlutterSmartDialog.observer],
            builder: FlutterSmartDialog.init(builder: (BuildContext context, Widget? child) {
              //全局文本放大
              return ValueListenableBuilder(
                valueListenable: isOpenBigFont,
                builder: (context, value, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context)
                        .copyWith(textScaler: value ? const TextScaler.linear(1.3) : const TextScaler.linear(1)),
                    child: child!,
                  );
                },
                child: child,
              );
            }),
          );
        });
  }
}
