import 'package:common_utils/common_utils.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article.dart';
import 'package:intellectual_breed/app/models/authModel.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/event_bus_util.dart';
import 'package:intellectual_breed/app/services/storage.dart';

import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../services/common_service.dart';
import '../../../services/constant.dart';
import '../../../services/user_info_tool.dart';

class HomeController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  //刷新控件
  late EasyRefreshController refreshController;
  //头像
  RxString headerImg = AssetsImages.avatar.obs;
  //轮播图数据
  RxList<String> swipList = <String>[].obs;
  //当前视频列表
  RxList<Article> videoItems = <Article>[].obs;
  //当前文章列表
  RxList<Article> wordItems = <Article>[].obs;

  @override
  void onInit() {
    super.onInit();
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    swipList.value = [
      AssetsImages.bannerTestPng,
      AssetsImages.bannerTestPng,
      AssetsImages.bannerTestPng
    ];

    Future.delayed(Duration(milliseconds: 500), () {
      //请求视频和文章数据
      requestArticle();
    });

    //监听app 进入前台的状态变化
    EventBusUtil.addListener<AppStateEvent>((event) {
      debugPrint("event.state: ${event.state}");
      //回到前台
      if (event.state == AppLifecycleState.resumed) {
        //请求视频和文章数据
        // requestArticle();
        refreshController.callRefresh();
      }
    });

    //监听用户登录状态
    EventBusUtil.addListener<UserLogInEvent>((event) {
      if (event.state == UserState.Login) {
        updateUserIcon();
      }
    });

    //监听用户头像更新
    EventBusUtil.addListener<UserIconChangeEvent>((event) {
      debugPrint('头像更新---${event.ID}');
      //更新头像
      headerImg.value = '${Constant.uploadFileUrl}${event.ID}';
      update();
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    //取消监听
    EventBusUtil.removeListener();
  }

  void updateUserIcon() {
    //图片更新后优先展示 headerImg.value 如果为空则展示默认头像
    //print(UserInfoTool.avatarUrl());
    if (ObjectUtil.isEmptyString(UserInfoTool.avatarUrl())) {
      headerImg.value = AssetsImages.avatar;
    } else {
      headerImg.value = '${Constant.uploadFileUrl}${UserInfoTool.avatarUrl()}';
    }
    update();
  }

  //请求视频和文章数据
  Future<void> requestArticle() async {
    //接口参数
    Map<String, dynamic> para1 = {
      'Type': 1, //类型 1：图文；2：图片；3：文字；4：视频；5：音频；
      'Classify': 'zthj',//业务分类 1: 专题合集[zthj]；99:使用指南[syzn]
      'PageIndex': 1,
      'PageSize': 10,
    };
    try {
      var response =
          await httpsClient.get("/api/article", queryParameters: para1);
      //缓存登录信息
      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<Article> modelList = [];
      for (var item in mapList) {
        Article model = Article.fromJson(item);
        modelList.add(model);
      }
      wordItems.value = modelList;
      update();
    } catch (error) {
      // Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }

    //接口参数
    Map<String, dynamic> para2 = {
      'Type': 4, //类型 1：图文；2：图片；3：文字；4：视频；5：音频；
      'Classify': 'zthj',//业务分类 1: 专题合集[zthj]；99:使用指南[syzn]
      'PageIndex': 1,
      'PageSize': 10,
    };
    try {
      var response =
          await httpsClient.get("/api/article", queryParameters: para2);
      //缓存登录信息
      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<Article> modelList = [];
      for (var item in mapList) {
        Article model = Article.fromJson(item);
        modelList.add(model);
      }
      videoItems.value = modelList;
      update();
    } catch (error) {
      // Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  void requestAnnounceData() async {
    try {
      var response = await httpsClient.get("/api/Announce", queryParameters: {
        "PageIndex": 1,
        "PageSize": 10,
      });
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况
        Log.d('API Exception: ${error.toString()}');
      } else {
        // 处理其他异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
