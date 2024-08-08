import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../controllers/information_detail_controller.dart';

class InformationDetailView extends GetView<InformationDetailController> {
  const InformationDetailView({Key? key}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '详情',
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Material(
        child: SafeArea(
          child: WebViewWidget(controller: controller.webController),
        ),
      )
    );
  }
}
