import 'package:flutter/widgets.dart';

import '../app/network/httpsClient.dart';
// 替换为实际的页面标题映射

class BusinessRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  final Set<String> _excludedRoutes = {'/splash', '/onboarding'};
  final Map<String, String> _logSessionMap = {};
  final httpsClient = HttpsClient();

  void _logPageEnter(PageRoute<dynamic> route) async {
    final routeKey = route.settings.name ?? route.runtimeType.toString();
    if (_excludedRoutes.contains(routeKey)) return;

    final pageName = pageNameMap[routeKey] ?? routeKey;

    try {
      final res = await httpsClient.post("/api/businesslog", data: {"pageName": pageName});
      final logId = res?.toString(); // ✅ 这里才是返回的 UUID 字符串

      if (logId != null && logId.isNotEmpty) {
        _logSessionMap[routeKey] = logId;
        print('✅ 页面进入日志成功: $pageName [$routeKey], logId=$logId');
      }
    } catch (e) {
      print("❌ 页面进入日志失败 ($routeKey): $e");
    }
  }

  void _logPageExit(PageRoute<dynamic> route) async {
    final routeKey = route.settings.name ?? route.runtimeType.toString();
    if (_excludedRoutes.contains(routeKey)) return;

    final pageName = pageNameMap[routeKey] ?? routeKey;
    final logId = _logSessionMap[routeKey];

    try {
      await httpsClient.put(
        "/api/businesslog",
        data: {"pageName": pageName, if (logId != null) "id": logId},
      );
      print('✅ 页面退出日志成功: $pageName [$routeKey], logId=$logId');
    } catch (e) {
      print("❌ 页面退出日志失败 ($routeKey): $e");
    } finally {
      _logSessionMap.remove(routeKey);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    if (route is PageRoute) _logPageEnter(route);
    if (previousRoute is PageRoute) _logPageExit(previousRoute);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute is PageRoute) _logPageEnter(previousRoute);
    if (route is PageRoute) _logPageExit(route);
    super.didPop(route, previousRoute);
  }
}

const Map<String, String> pageNameMap = {
  '/login': '登录/退出',
  '/tabs': '首页',
  '/application': '技术课堂',
  '/recipe': '配方设计',
  '/production_guide': '任务提醒',
  '/cattlelist': '生产管理',
  '/mine': '我的',
};
