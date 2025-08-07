import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

import 'package:intellectual_breed/app/services/constant.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../models/authModel.dart';
import '../services/storage.dart';
import '../services/user_info_tool.dart';

class FileUploadTool {
  static Dio dio = Dio();

  FileUploadTool() {
    //连接服务器超时时间
    dio.options.connectTimeout = const Duration(seconds: 15); //10s
    //接收数据的最长时间
    dio.options.receiveTimeout = const Duration(seconds: 15);

    //pretty_dio_logger
    //dio.interceptors.add(PrettyDioLogger());
    //配置抓包
    /*
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

  //上传文件接口
  Future<String> uploadWith(String localImagePath) async {
    Options options = Options();
    options.contentType = "multipart/form-data";
    // 发送请求前，获取当前有效的 Token
    AuthModel authModel = UserInfoTool.auth!;
    String accessToken = authModel.accessToken;
    if (accessToken.isNotEmpty) {
      // 添加 Token 到请求头中
      options = Options(headers: {'Authorization': 'Bearer $accessToken'});
    }
    // 根据请求方法，选择相应的方法发送请求
    Map<String, dynamic> para = {
      "projectId": Constant.upProjectId,
      "containsDate": false,
      "isTemp": false,
      "isCompress": true,
    };
    //文件信息
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(localImagePath,
          filename: 'cow_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType.parse('image/jpeg')),
    });


    ///发送post
    Response response = await dio.post(
      '${Constant.uploadFile}/api/file/upload',
      data: formData,
      queryParameters: para,
      options: options,
      onSendProgress: (int progress, int total) {
        ///这里是发送请求回调函数
        ///[progress] 当前的进度
        ///[total] 总进度
        //print("当前进度是 $progress 总进度是 $total");
      },
    );

    ///服务器响应结果
    var data = response.data;
    // print(data['data']);
    return Future.value(data['data']);
  }

  ///使用文件 ID 获取文件路径
  Future<String> requestUploadPath(String ID) async {
    try {
      Options options = Options();
      // 发送请求前，获取当前有效的 Token
      String? accessToken = await Storage.getData(Constant.upAccessToken);
      if (accessToken != null) {
        // 添加 Token 到请求头中
        options = Options(headers: {'Authorization': 'Bearer $accessToken'});
      }
      // 根据请求方法，选择相应的方法发送请求
      Response response = await dio.get(
        '${Constant.uploadFile}/api/Content/$ID',
        options: options,
      );
      Map res = response.data;
      //print(res);
      return Future.value(res['data']['path']);
    } catch (error) {
      // 处理其他错误情况
      rethrow;
    }
  }

  ///获取上传用 token
  Future<void> requestUploadToken() async {
    try {
      Options options = Options();
      options.contentType = "application/x-www-form-urlencoded";
      // 根据请求方法，选择相应的方法发送请求
      Response response = await dio.post(Constant.uploadTokenUrl,
          data: {
            "grant_type": Constant.upGrantType,
            "client_id": Constant.upClientId,
            "client_secret": Constant.upClientSecret,
            "scope": Constant.upScope,
          },
          options: options);
      //print(response);
      Map res = response.data;
      // 存储 token
      await Storage.setData(Constant.upAccessToken, res['access_token']);
    } catch (error) {
      // 处理其他错误情况
      rethrow;
    }
  }
}
