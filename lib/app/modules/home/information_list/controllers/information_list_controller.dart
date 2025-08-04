import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article.dart';
import 'package:intellectual_breed/route_utils/business_logger.dart';

import '../../../../models/page_info.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../widgets/dict_list.dart';

class InformationListController extends GetxController {
  var keywords = '新生犊牛怎么护理';

  ScrollController scrollController = ScrollController();
  HttpsClient httpsClient = HttpsClient();

  // 是否加载中
  var isLoading = true.obs;

  //刷新控件
  late EasyRefreshController refreshController;

  //
  int pageIndex = 1;
  int pageSize = 8;

  //
  bool hasMore = false;

  //分类0:全部 1：繁殖技术；2：营养调控；3：犊牛护理；4：能繁母牛养殖300问。5:软件使用
  RxInt selectIndex = 0.obs;

  /// 分类顶部分类的,0全部类型 1：图文；2：图片；3：文字；4：视频；5：音频；
  RxInt listTypeIndex = 0.obs;
  int listTypeID = 0; //接口上传使用
  String searchStr = '';

  //当前文章列表
  RxList<Article> items = <Article>[].obs;

  // 左侧分类列表
  List leftCategoryList = [
    {'value': 0, "label": '全部'},
  ];
  List leftCategoryNameList = [];

  List subHeaderList = [
    {"id": 0, "title": "全部"},
    {"id": 1, "title": "视频"},
    {"id": 2, "title": "文章"},
  ];

  String? logPath;

  @override
  void onInit() {
    super.onInit();

    //初始化下拉刷新控制器
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);

    //获取专题合集字典项
    List pzList = AppDictList.searchItems('zthj') ?? [];
    leftCategoryList.addAll(pzList);
    debugPrint('pzList: $pzList');
    leftCategoryNameList.addAll(leftCategoryList.map((item) => item['label']).toList());
    print(leftCategoryNameList);

    //请求数据
    //searchArticleList();
    debugPrint(' -- onInit --${getLogPath()}');
  }

  String? getLogPath() {
    if (selectIndex.value == 0 || listTypeIndex.value == 0) {
      return null;
    }
    String leftCategoryName =
        leftCategoryList.firstWhereOrNull(
          (element) => element['label'] == leftCategoryNameList[selectIndex.value],
        )?['label'];
    String subHeaderName = subHeaderList[listTypeIndex.value]['title'];
    return '$leftCategoryName/$subHeaderName';
  }

  //上次提交的日志
  String? lastLogPath;

  // 点击更新index
  void changeIndex(index, pid) {
    Log.e('----> 分类列表index: $index');
    selectIndex.value = index;
    isLoading.value = true;
    update();
    createLog();
    searchArticleList();
  }

  void createLog() {
    debugPrint(' -- onInit --${getLogPath()}');
    String? logPath = getLogPath();
    if (lastLogPath != null) {
      BusinessLogger.instance.logExit(lastLogPath!);
    }
    if (logPath != null) {
      BusinessLogger.instance.logEnter(logPath);
      lastLogPath = logPath;
    }
  }

  // 点击更新index
  void changeListTypeIndex(index) {
    Log.e('----> 内容列表index: $index');
    listTypeIndex.value = index;
    isLoading.value = true;
    update();
    switch (index) {
      case 1:
        listTypeID = 4;
        break;
      case 2:
        listTypeID = 1;
        break;
      default:
        listTypeID = 0;
    }
    debugPrint(' -- onInit --${getLogPath()}');
    createLog();
    searchArticleList();
  }

  RxList<String> rightCategoryList = <String>[].obs;

  //请求牛只列表数据
  Future<void> searchArticleList({bool isRefresh = true}) async {
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
      //http://154.8.193.14:5657/api/article?pageIndex=1&pageSize=12&classify=zthj&category=5
      Map<String, dynamic> para = {
        'Title': searchStr, //标题
        'classify': 'zthj',
        //leftCategoryList,取值选择devalue
        // 'Category': 5,
        'Category':
            selectIndex.value == 0
                ? ''
                : leftCategoryList.firstWhereOrNull(
                  (element) => element['label'] == leftCategoryNameList[selectIndex.value],
                )?['value'],
        // : selectIndex
        //    .value, //这里 state 为 0 表示筛选条件为全部，设置为空字符串，提交表单时自动移除该 key-value
        'Type': listTypeID == 0 ? '' : listTypeID,
        'PageIndex': tempPageIndex,
        'PageSize': pageSize,
      };
      debugPrint('para: $para');

      var response = await httpsClient.get("/api/article", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      // print(model.itemsCount);

      List mapList = model.list;
      List<Article> modelList = [];
      for (var item in mapList) {
        Article model = Article.fromJson(item);
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
