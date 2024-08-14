import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';

class MaterialService {
  MaterialService._();

  //获取字典
  static Future getDic(String code) async {
    HttpsClient httpsClient = HttpsClient();
    return await httpsClient.get('/api/dic/$code');
  }

  //删除物资
  //{
  //   "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //   "rowVersion": "2024-08-14T15:01:16.850Z"
  // }
  static Future deleteMaterial({
    required String id,
    required String rowVersion,
    VoidCallback? successCallback,
    Function(String msg)? errorCallback,
  }) async {
    HttpsClient httpsClient = HttpsClient();
    try {
      await httpsClient.delete(
        '/api/stockrecord/$id',
        data: {
          'rowVersion': rowVersion,
          'id': id,
        },
      );
      successCallback?.call();
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
        errorCallback?.call(error.toString());
        // Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }
}
