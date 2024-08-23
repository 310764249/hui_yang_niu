import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/simple_event.dart';
import 'package:intellectual_breed/app/services/constant.dart';

import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../widgets/toast.dart';

//页面传参
class EventsArgument {
  /// 接口
  final String api;

  /// 例如 '引种事件'
  final String title;

  /// 点击新增跳转的路由 例如 '/cattlelist'
  final String routerStr;

  /// 点击跳转详情的路由 例如 '/cattlelist'
  final String? detailRouterStr;

  EventsArgument(this.api, this.title, this.routerStr, {this.detailRouterStr});
}

class EventListController extends GetxController {
  //传入的参数
  EventsArgument argument = Get.arguments;

  HttpsClient httpsClient = HttpsClient();
  //
  int pageIndex = 1;
  int pageSize = 14;

  // 是否加载中, 在[页面初始化]时触发
  var isLoading = true.obs;

  //
  bool hasMore = false;

  //刷新控件
  late EasyRefreshController refreshController;

  //当前列表
  RxList<SimpleEvent> items = <SimpleEvent>[].obs;
  //接口地址
  // String API = '/api/allot';

  @override
  void onInit() {
    super.onInit();
    argument = Get.arguments;
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );

    debugPrint("routerStr--${argument.routerStr}   detailRouterStr:${argument.detailRouterStr}");
    searchEventsList();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('onReady');
  }

  @override
  void onClose() {
    super.onClose();
    //
    refreshController.dispose();
  }

  /// 显示标题盘点
  String getItemTitle(SimpleEvent model) {
    String title = '';
    if (model.cowCode == null) {
      if (model.batchNo == null) {
        if (model.no != null) {
          title = '单号-${model.no}';
        } else if (model.cowHouseName != null) {
          title = '栋舍-${model.cowHouseName}';
        }
      } else {
        title = '批次号-${model.batchNo}';
      }
    } else {
      title = '耳号-${model.cowCode}';
    }
    return title;
  }

  /// 显示操作人
  String getExecutor(SimpleEvent model) {
    String title = Constant.placeholder;
    if (model.executor != null) {
      title = model.executor!;
    } else {
      title = model.seller!;
    }
    return title;
  }

  /// 显示时间
  String getTimeString(SimpleEvent model) {
    String time = '';
    if (model.date == null) {
      time = model.created.substring(0, 10);
    } else {
      time = model.date!.substring(0, 10);
    }
    return time;
  }

  //请求数据
  Future<void> searchEventsList({bool isRefresh = true}) async {
    // Toast.showLoading();
    try {
      //使用临时的页码，防止请求失败
      int tempPageIndex = pageIndex;
      if (isRefresh) {
        tempPageIndex = pageIndex = 1;
      } else {
        tempPageIndex++;
      }

      //接口参数
      Map<String, dynamic> para = {
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      var response = await httpsClient.get(argument.api, queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<SimpleEvent> modelList = [];
      for (var item in mapList) {
        SimpleEvent model = SimpleEvent.fromJson(item);
        modelList.add(model);
      }
      //更新页面数据
      if (isRefresh) {
        items.value = modelList; //下拉刷新
      } else {
        pageIndex++; //上拉加载请求成功后,真实的页码+1
        items.addAll(modelList); //上拉加载
      }
      //是否可以加载更多
      hasMore = items.length < model.itemsCount;
      isLoading.value = false;
      update();
      // Toast.dismiss();
    } catch (error) {
      isLoading.value = false;
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

  //请求数据
  Future<void> deleteEvent(SimpleEvent event) async {
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': event.id,
        'rowVersion': event.rowVersion,
      };
      await httpsClient.delete(argument.api, data: para);
      Toast.dismiss();
      Toast.success(msg: '删除成功');
      refreshController.callRefresh();
      return Future.value();
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value();
    }
  }
}
