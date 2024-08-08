import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../../../../services/constant.dart';

class InformationDetailController extends GetxController {
  //传入的参数
  String? argument = Get.arguments;

  late WebViewController webController;

  @override
  void onInit() async {
    super.onInit();

    String openUrl = argument ?? "";
    //String openUrl = "${Constant.articleHost}/${argument.type}/${argument.id}";
    // String openUrl = "assets/html/JSTest.html";

    // final String contentBase64 = base64Encode(
    //   const Utf8Encoder().convert(kTransparentBackgroundPage),
    // );
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{
          // PlaybackMediaTypes.audio,
          // PlaybackMediaTypes.video
        },
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    webController = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.transparent)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
            debugPrint('WebView is loading (progress : $progress%)');
          },
          onPageStarted: (String url) {
            debugPrint('Page started loading: $url');
          },
          onPageFinished: (String url) {
            debugPrint('Page finished loading: $url');
          },
          // onUrlChange: (UrlChange change) {
          //   debugPrint('url change to ${change.url}');
          // },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
              Page resource error:
              code: ${error.errorCode}
              description: ${error.description}
              errorType: ${error.errorType}
              isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            // if (request.url.startsWith('https://www.baidu.com/')) {
            //   return NavigationDecision.prevent;
            // }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(openUrl));
    // ..loadRequest(
    //   Uri.parse('data:text/html;base64,$contentBase64'),
    // );

    // if (webController.platform is AndroidWebViewController) {
    //   AndroidWebViewController.enableDebugging(true);
    //   (webController.platform as AndroidWebViewController)
    //       .setMediaPlaybackRequiresUserGesture(false);
    // }

    //加载本地数据
    // String fileHtmlContents = await rootBundle.loadString(openUrl);
    // webController.loadHtmlString(fileHtmlContents);
    //JS 能力相关
    webController.addJavaScriptChannel(
      'saientlinkInterface',
      onMessageReceived: (JavaScriptMessage message) {
        //webController.runJavaScript("");
        Map argument = json.decode(message.message);
        String functionName = argument['functionName'];
        debugPrint('调用 JS 能力接口，functionName: $functionName');
        switch (functionName) {
          case 'getUserToken':
            getUserToken(argument);
            break;
          default:
        }
      },
    );
  }

  @override
  void onClose() {
    super.onClose();
  }

  //获取用户 token
  void getUserToken(Map argument) {
    //debugPrint("getUserToken");
    Map responseMap = getResponseMap();
    responseMap['data'] = {'token': UserInfoTool.accessToken() ?? ''};
    //拼装回调
    String js = '${argument['callbackFunc']}(${json.encode(responseMap)});';
    //debugPrint(js);
    webController.runJavaScript(js);
  }

  //
  Map getResponseMap() {
    return {
      'code': 0,
      'data': {},
    };
  }
}
