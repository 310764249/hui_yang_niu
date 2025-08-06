import 'package:flutter/material.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  /// 当前是否处于前台活跃状态
  bool isAppActive = true;

  final void Function()? onResumed;
  final void Function()? onPaused;
  final void Function()? onInactive;
  final void Function()? onDetached;

  AppLifecycleObserver({this.onResumed, this.onPaused, this.onInactive, this.onDetached});

  void start() {
    WidgetsBinding.instance.addObserver(this);
  }

  void stop() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        isAppActive = true;
        onResumed?.call();
        break;
      case AppLifecycleState.inactive:
        isAppActive = false;
        onInactive?.call();
        break;
      case AppLifecycleState.paused:
        isAppActive = false;
        onPaused?.call();
        break;
      case AppLifecycleState.detached:
        isAppActive = false;
        onDetached?.call();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }
}
