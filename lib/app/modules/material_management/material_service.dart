// class MaterialService {
//   MaterialService._();
//
//   static Future<void> getStockrecordList({bool isRefresh = true}) async {
//     // Toast.showLoading();
//     try {
//       //使用临时的页码，防止请求失败
//       int tempPageIndex = pageIndex;
//       if (isRefresh) {
//         tempPageIndex = pageIndex = 1;
//       } else {
//         tempPageIndex++;
//       }
//
//       //接口参数
//       Map<String, dynamic> para = {
//         'PageIndex': tempPageIndex,
//         'PageSize': pageSize,
//       };
//       var response = await httpsClient.get("/api/notice", queryParameters: para);
//
//       PageInfo model = PageInfo.fromJson(response);
//       //print(model.itemsCount);
//       List mapList = model.list;
//       List<Notice> modelList = [];
//       for (var item in mapList) {
//         Notice model = Notice.fromJson(item);
//         modelList.add(model);
//       }
//       //更新页面数据
//       if (isRefresh) {
//         items.value = modelList; //下拉刷新
//       } else {
//         pageIndex++; //上拉加载请求成功后,真实的页码+1
//         items.addAll(modelList); //上拉加载
//       }
//       //是否可以加载更多
//       hasMore = items.length < model.itemsCount;
//       isLoading.value = false;
//       update();
//       // Toast.dismiss();
//     } catch (error) {
//       isLoading.value = false;
//       // Toast.dismiss();
//       if (error is ApiException) {
//         // 处理 API 请求异常情况 code不为 0 的场景
//         Log.d('API Exception: ${error.toString()}');
//       } else {
//         // HTTP 请求异常情况
//         Log.d('Other Exception: $error');
//       }
//     }
//   }
// }
