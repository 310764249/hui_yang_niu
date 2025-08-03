import 'package:flutter/foundation.dart';

import '../app/network/httpsClient.dart';

class BusinessLogger {
  static final BusinessLogger _instance = BusinessLogger._internal();
  factory BusinessLogger() => _instance;
  BusinessLogger._internal();

  static BusinessLogger get instance => _instance;

  final HttpsClient _http = HttpsClient();
  final Map<String, String> _logMap = {}; // pageName -> logId

  /// 页面进入时调用（只需 pageName）
  Future<void> logEnter(String pageName) async {
    try {
      final res = await _http.post("/api/businesslog", data: {"pageName": pageName});
      final logId = res?.toString();
      if (logId != null && logId.isNotEmpty) {
        _logMap[pageName] = logId;
        debugPrint("✅ 页面进入日志成功: $pageName, logId=$logId");
      }
    } catch (e) {
      debugPrint("❌ 页面进入日志失败 ($pageName): $e");
    }
  }

  /// 页面退出时调用（pageName 必传）
  Future<void> logExit(String pageName) async {
    final logId = _logMap[pageName];
    if (logId == null) return;

    try {
      await _http.put("/api/businesslog", data: {"pageName": pageName, "id": logId});
      debugPrint("✅ 页面退出日志成功: $pageName, logId=$logId");
    } catch (e) {
      debugPrint("❌ 页面退出日志失败 ($pageName): $e");
    } finally {
      _logMap.remove(pageName);
    }
  }

  /// 页面切换时调用：from -> to
  Future<void> switchPage({required String from, required String to}) async {
    await logExit(from);
    await logEnter(to);
  }

  void clear() => _logMap.clear();
}
