import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';

class MessageCountService {
  static final HttpsClient _httpsClient = HttpsClient();

  static Future<int> getUnReadMessageCount() async {
    try {
      var res = await _httpsClient.get('/api/notice/getnoreadnum');
      return res;
    } catch (e) {
      print(e);
    }
    return 0;
  }
}
