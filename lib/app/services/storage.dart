import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  /// 存储指定数据
  /// @param key 存储数据的键
  /// @param value 存储数据
  /// @return 返回存储的数据
  static setData(String key, dynamic value) async {
    var prefs = await SharedPreferences.getInstance();
    //setString这里要转为json
    prefs.setString(key, json.encode(value));
  }

  /// 读取指定数据
  /// @param key 读取数据的键
  /// @return 返回读取到的数据
  static getData(String key) async {
    try {
      var prefs = await SharedPreferences.getInstance();
      String? tempData = prefs.getString(key);
      if (tempData != null) {
        //这里要解析json为 map
        return json.decode(tempData);
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //设置bool值
  static setBool(String key, bool value) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  //获取bool值
  static Future<bool> getBool(String key) async {
    var prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  /// 移除指定数据
  static removeData(String key) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }

  /// 清除所有存储的数据
  static clear() async {
    var prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
