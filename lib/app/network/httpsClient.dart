import 'dart:async';

// import 'package:alice/alice.dart';
import 'package:dio/dio.dart';
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

  // static String domain = "http://nxbreedapi.sdyihewan.com"; // 正式环境地址
  // static String domain = "http://breedapi.sdyihewan.com"; // 测试环境地址
  static String domain = "http://154.8.193.14:5657"; // 正式环境地址
  // static String domain = "http://154.8.193.14:5658"; // 测试环境地址
  static Dio dio = Dio();

  // 网络视图UI配置
  // Alice alice = Alice(
  //     showNotification: Platform.isAndroid ? true : false,
  //     showInspectorOnShake: true,
  //     darkTheme: Platform.isIOS ? true : false,
  //     navigatorKey: Constant.navigatorKey ?? GlobalKey<NavigatorState>());

  final List<Map> _failedRequests = [];
  bool isRefreshing = false; // 刷新 Token 是否正在进行中

  // 构造函数私有化，防止外部直接实例化
  HttpsClient._internal() {
    dio.options.baseUrl = domain;
    //连接服务器超时时间
    dio.options.connectTimeout = const Duration(seconds: 10); //10s
    //接收数据的最长时间
    dio.options.receiveTimeout = const Duration(seconds: 10);
    //非生产环境，开启日志以及抓包
    if (!Constant.inProduction) {
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
  Future get(
    String apiUrl, {
    Map<String, dynamic>? queryParameters,
  }) async {
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
  Future post(
    String apiUrl, {
    Map? data,
  }) async {
    try {
      var response = await _sendAuthenticatedRequest(
        RequestMethod.POST,
        apiUrl,
        data: data,
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }

  /// delete 请求
  /// @param apiUrl 接口地址
  /// @param queryParameters 请求参数
  Future delete(
    String apiUrl, {
    Map<String, dynamic>? queryParameters,
    Map? data,
  }) async {
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
  Future put(
    String apiUrl, {
    Map<String, dynamic>? queryParameters,
    Map? data,
  }) async {
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
  Future<dynamic> _sendAuthenticatedRequest(RequestMethod method, String url,
      {Map? data, Map<String, dynamic>? queryParameters}) async {
    try {
      Options options = Options();
      // 发送请求前，获取当前有效的 Token
      // var auth = await Storage.getData(Constant.authData);
      if (UserInfoTool.auth != null) {
        // AuthModel authModel = AuthModel.fromJson(auth);
        AuthModel authModel = UserInfoTool.auth!;
        String accessToken = authModel.accessToken;
        // 添加 Token 到请求头中
        options = Options(headers: {'Authorization': 'Bearer $accessToken'});
      }

      // 过滤 Map 中值为空字符或者为 null 的项
      queryParameters?.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'attach');
      data?.removeWhere((key, value) => (value == null || value.toString().isEmpty) && key != 'attach');

      // 根据请求方法，选择相应的方法发送请求
      Response response;
      switch (method) {
        case RequestMethod.GET:
          response = await dio.get(url, queryParameters: queryParameters, options: options);
          break;
        case RequestMethod.POST:
          response = await dio.post(url, data: data, options: options);
          break;
        case RequestMethod.DELETE:
          response = await dio.delete(url, queryParameters: queryParameters, data: data, options: options);
          break;
        case RequestMethod.PUT:
          response = await dio.put(url, queryParameters: queryParameters, data: data, options: options);
          break;
        // 可以添加其他请求方法的处理
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
        //缓存业务请求异常的接口
        _failedRequests.add({'method': method, 'url': url, 'data': data, 'queryParameters': queryParameters});

        // 如果请求返回 401 Unauthorized，说明 Token 失效
        // 判断是否正在刷新 Token，如果没有在刷新，则触发刷新
        if (!isRefreshing) {
          isRefreshing = true;
          await refreshToken(); // 刷新 Token
          isRefreshing = false;
        }
      } else {
        // 处理其他错误情况
        rethrow;
      }
    }
  }

  Future<void> refreshToken() async {
    // 发送请求前，获取当前有效的 Token
    var auth = await Storage.getData(Constant.authData);
    if (auth == null) {
      isRefreshing = false;
      throw ApiException("请重新登录");
    }
    AuthModel authModel = AuthModel.fromJson(auth);
    String refreshToken = authModel.refreshToken;
    try {
      // 实现刷新 Token 的逻辑，例如使用 /api/refresh 接口
      Response response = await dio.post('/api/auth/refresh', data: {
        "client_id": Constant.clientId,
        "client_secret": Constant.clientSecret,
        "grant_type": Constant.grantType,
        "refresh_token": refreshToken,
      });

      //首先 Map 转为 Model
      var baseModel = BaseModel.fromJson(response.data);
      // 在这里判断数据是否异常，例如判断返回的状态码或特定字段
      if (baseModel.code == 0) {
        //缓存登录信息
        AuthModel newAuthModel = AuthModel.fromJson(baseModel.data);
        //更新内存记录
        UserInfoTool.auth = newAuthModel;
        await Storage.setData(Constant.authData, newAuthModel);
        //重新请求异常的业务接口
        for (var item in _failedRequests) {
          await _sendAuthenticatedRequest(
            item['method'],
            item['url'],
            data: item['data'],
            queryParameters: item['queryParameters'],
          );
        }
        //请求完成后删除异常的请求
        _failedRequests.clear();
      } else {
        //删除异常的请求
        _failedRequests.clear();
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${baseModel.message!}');
        Toast.failure(msg: baseModel.message!);
        throw ApiException(baseModel.message!);
      }
    } catch (e) {
      //
      Log.w("触发登录页面");
      //删除异常的请求
      _failedRequests.clear();
      //清除登录信息
      CommonService().clearUserData();
    }
  }

  static replaceUri(picUrl) {
    String tempUrl = domain + picUrl;
    return tempUrl.replaceAll("\\", "/");
  }
}
