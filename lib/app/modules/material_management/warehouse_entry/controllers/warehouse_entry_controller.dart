import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/models/page_info.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';

class WarehouseEntryController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  //
  int pageIndex = 1;
  int pageSize = 14;

  //
  bool hasMore = false;

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true.obs;

  //刷新控件
  late EasyRefreshController refreshController;

  //当前列表
  RxList<MaterialItemModel> items = <MaterialItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    //
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
  }

  //请求轮播数据
  Future<void> getMessageList({bool isRefresh = true}) async {
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
      var response = await httpsClient.get("/api/stockrecord", queryParameters: para);
      Log.d(response.toString());

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<MaterialItemModel> modelList = [];
      for (var item in mapList) {
        MaterialItemModel model = MaterialItemModel.fromJson(item);
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
}
