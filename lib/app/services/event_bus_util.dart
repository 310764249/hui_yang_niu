import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';

// app 状态事件
class AppStateEvent {
  AppLifecycleState state;
  AppStateEvent(this.state);
}

// 用户登录状态
enum UserState {
  Login,
  Logout,
}

class UserLogInEvent {
  UserState state;

  UserLogInEvent(this.state);
}

// 用户头像更新
class UserIconChangeEvent {
  String ID;

  UserIconChangeEvent(this.ID);
}

class EventBusUtil {
  // 工厂模式
  factory EventBusUtil() => _instance;
  static final EventBusUtil _instance = EventBusUtil._internal();

  static late EventBus _eventBus;

  EventBusUtil._internal() {
    // 创建EventBus实例
    //print("EventBusUtil._internal");
    _eventBus = EventBus();
  }

  // 发送事件
  static void fireEvent(Object event) {
    _eventBus.fire(event);
  }

  // 订阅事件
  static void addListener<T>(void onData(T event)) {
    _eventBus.on<T>().listen((event) {
      if (onData != null) {
        onData(event);
      }
    });
  }

  // 取消订阅
  static void removeListener() {
    _eventBus.destroy();
  }
}
