import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MessageDetailController extends GetxController {
  String title = '';
  String content = '';
  String time = '';

  void setMessageContent(
      String titleParam, String contentParam, String timeParam) {
    debugPrint('==> $titleParam $contentParam $timeParam');
    title = titleParam;
    content = contentParam;
    time = timeParam;
  }

  @override
  void onInit() {
    super.onInit();
    debugPrint('onInit');
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('onReady');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('onClose');
  }
}
