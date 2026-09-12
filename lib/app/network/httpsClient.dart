import 'dart:async';

// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
import 'package:dio_logger_plus/dio_logger_plus.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/common_service.dart';

import '../models/authModel.dart';
import '../services/Log.dart';
import '../services/constant.dart';
import '../services/storage.dart';
import '../services/user_info_tool.dart';
import '../widgets/toast.dart';
import 'apiException.dart';
import 'baseModel.dart';

enum RequestMethod {
  GET,
  POST,
  DELETE,
  PUT,
  // 可以添加其他请求方法，如 PUT、DELETE 等
}

/// 网络请求实例
class HttpsClient {
  // 单例
  static final HttpsClient _instance = HttpsClient._internal();

  factory HttpsClient() => _instance;

  static String get domain => Constant.getAPI; // 正式环境地址

  static Dio dio = Dio();

  // 网络视图UI配置
  // Alice alice = Alice(
  //     showNotification: Platform.isAndroid ? true : false,
  //     showInspectorOnShake: true,
  //     darkTheme: Platform.isIOS ? true : false,
  //     navigatorKey: Constant.navigatorKey ?? GlobalKey<NavigatorState>());

  // Token 刷新采用 single-flight：同一时间只允许一个刷新请求，其余请求
  // 等待同一个 Future，避免 401 请求互相重放形成递归/死循环。
  Future<void>? _refreshTokenFuture;
  bool isRefreshing = false; // 刷新 Token 是否正在进行中（保留供调试使用）

  // 构造函数私有化，防止外部直接实例化
  HttpsClient._internal() {
    dio.options.baseUrl = domain;
    //连接服务器超时时间
    dio.options.connectTimeout = const Duration(seconds: 60); //10s
    //接收数据的最长时间
    dio.options.receiveTimeout = const Duration(seconds: 60);
    //仅在非生产环境保留请求摘要。完整响应体（尤其是用户资源和字典）
    //非常大，会刷屏并拖慢 Flutter 主线程，但不会代表接口被重复调用。
    if (!Constant.inProduction) {
      dio.interceptors.add(
        DioLogger(
          requestBody: false,
          responseBody: false,
        ),
      );
      //pretty_dio_logger
      // dio.interceptors.add(PrettyDioLogger());
      // dio.interceptors.add(alice.getDioInterceptor());
      /*
      //配置抓包
      dio.httpClientAdapter = IOHttpClientAdapter()
        ..onHttpClientCreate = (client) {
          // Config the client.
          client.findProxy = (uri) {
            // Forward all request to proxy "localhost:8888".
            return 'PROXY 192.168.1.188:9090';
          };

          ///解决安卓https抓包问题
          client.badCertificateCallback =
              (X509Certificate cert, String host, int port) => true;
          return client;
        };
      */
    }
  }

  /// Get 请求
  /// @param apiUrl 接口地址
  /// @param queryParameters 请求参数
  Future get(String apiUrl, {Map<String, dynamic>? queryParameters}) async {
    try {
      var response = await _sendAuthenticatedRequest(
        RequestMethod.GET,
        apiUrl,
        queryParameters: queryParameters,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// Post 请求
  /// @param apiUrl 接口地址
  /// @param data 请求参数
  Future post(String apiUrl, {Map? data}) async {
    try {
      var response = await _sendAuthenticatedRequest(RequestMethod.POST, apiUrl,
          data: data);
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// delete 请求
  /// @param apiUrl 接口地址
  /// @param queryParameters 请求参数
  Future delete(String apiUrl,
      {Map<String, dynamic>? queryParameters, Map? data}) async {
    try {
      var response = await _sendAuthenticatedRequest(
        RequestMethod.DELETE,
        apiUrl,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// put 请求
  /// @param apiUrl 接口地址
  /// @param queryParameters 请求参数
  Future put(String apiUrl,
      {Map<String, dynamic>? queryParameters, Map? data}) async {
    try {
      var response = await _sendAuthenticatedRequest(
        RequestMethod.PUT,
        apiUrl,
        queryParameters: queryParameters,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  ///通用请求封装
  Future<dynamic> _sendAuthenticatedRequest(
    RequestMethod method,
    String url, {
    Map? data,
    Map<String, dynamic>? queryParameters,
    bool retryOnUnauthorized = true,
  }) async {
    try {
      Options options = Options();
      // 发送请求前，获取当前有效的 Token
      // var auth = await Storage.getData(Constant.authData);
      if (UserInfoTool.auth != null) {
        // AuthModel authModel = AuthModel.fromJson(auth);
        AuthModel authModel = UserInfoTool.auth!;
        String accessToken = authModel.accessToken;
        // 添加 Token 到请求头中
        options = Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'deviceType': 'Android'
          },
        );
      }

      // 过滤 Map 中值为空字符或者为 null 的项
      queryParameters?.removeWhere(
        (key, value) =>
            (value == null || value.toString().isEmpty) && key != 'attach',
      );
      data?.removeWhere(
        (key, value) =>
            (value == null || value.toString().isEmpty) && key != 'attach',
      );

      // 根据请求方法，选择相应的方法发送请求
      Response response;
      switch (method) {
        case RequestMethod.GET:
          response = await dio.get(url,
              queryParameters: queryParameters, options: options);
          break;
        case RequestMethod.POST:
          response = await dio.post(url, data: data, options: options);
          break;
        case RequestMethod.DELETE:
          response = await dio.delete(
            url,
            queryParameters: queryParameters,
            data: data,
            options: options,
          );
          break;
        case RequestMethod.PUT:
          response = await dio.put(
            url,
            queryParameters: queryParameters,
            data: data,
            options: options,
          );
          break;
        // 可以添加其他请求方法的处理
      }
      if (url.contains('/api/user/getimtoken')) {
        return response.data;
      }
      //首先 Map 转为 BaseModel
      var baseModel = BaseModel.fromJson(response.data);
      // 在这里判断数据是否异常，例如判断返回的状态码或特定字段
      if (baseModel.code != 0) {
        throw ApiException(baseModel.message!);
      }
      return baseModel.data;
    } catch (error) {
      debugPrint('请求异常: $error');
      if (error is DioException && error.response?.statusCode == 401) {
        // 没有 Token、已经重试过一次，或刷新接口本身失败时都直接结束。
        // 不能再次进入刷新逻辑，否则失效 Token 会导致无限重试。
        if (!retryOnUnauthorized || UserInfoTool.auth == null) {
          rethrow;
        }

        await _refreshTokenOnce();
        return _sendAuthenticatedRequest(
          method,
          url,
          data: data,
          queryParameters: queryParameters,
          retryOnUnauthorized: false,
        );
      } else {
        // 处理其他错误情况
        rethrow;
      }
    }
  }

  /// 只执行一次 Token 刷新，其他并发请求等待该 Future 完成。
  Future<void> _refreshTokenOnce() async {
    final running = _refreshTokenFuture;
    if (running != null) {
      return running;
    }

    final future = _performTokenRefresh();
    _refreshTokenFuture = future;
    isRefreshing = true;
    try {
      await future;
    } finally {
      if (identical(_refreshTokenFuture, future)) {
        _refreshTokenFuture = null;
        isRefreshing = false;
      }
    }
  }

  /// 执行实际的 Token 刷新。失败时清理会话并把错误交给原请求，
  /// 不再吞掉异常或重放失败请求。
  Future<void> _performTokenRefresh() async {
    try {
      final auth = await Storage.getData(Constant.authData);
      if (auth == null) {
        throw ApiException('请重新登录');
      }

      final authModel = AuthModel.fromJson(auth);
      if (authModel.refreshToken.isEmpty) {
        throw ApiException('请重新登录');
      }

      final response = await dio.post(
        '/api/auth/refresh',
        data: {
          "client_id": Constant.clientId,
          "client_secret": Constant.clientSecret,
          "grant_type": Constant.grantType,
          "refresh_token": authModel.refreshToken,
        },
      );

      final baseModel = BaseModel.fromJson(response.data);
      if (baseModel.code != 0) {
        final message = baseModel.message ?? '登录状态已失效，请重新登录';
        Log.d('API Exception: $message');
        Toast.failure(msg: message);
        throw ApiException(message);
      }

      final newAuthModel = AuthModel.fromJson(baseModel.data);
      UserInfoTool.auth = newAuthModel;
      await Storage.setData(Constant.authData, newAuthModel);
    } catch (error) {
      Log.w('触发登录页面');
      await CommonService().clearUserData(unbindPush: false);
      if (error is ApiException) {
        rethrow;
      }
      throw ApiException('登录状态已失效，请重新登录');
    }
  }

  static replaceUri(picUrl) {
    String tempUrl = domain + picUrl;
    return tempUrl.replaceAll("\\", "/");
  }
}
