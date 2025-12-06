import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/cupertino.dart';
import 'package:intellectual_breed/app/models/page_info.dart';
import 'package:intellectual_breed/app/models/stock_record_day_entity.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record_day_table.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';

import '../../../models/manual_work_day_entity.dart';
import '../../../network/apiException.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../single_day_profit_card.dart';

class StockRecordDayView extends StatefulWidget {
  const StockRecordDayView({super.key});

  @override
  State<StockRecordDayView> createState() => _StockRecordDayViewState();
}

class _StockRecordDayViewState extends State<StockRecordDayView>
    with AutomaticKeepAliveClientMixin {
  HttpsClient httpsClient = HttpsClient();

  //人工按日统计

  int pageIndex = 1;
  int pageSize = 20;

  // 是否加载中, 在[页面初始化]时触发
  var isLoading = true;

  //
  bool hasMore = false;

  List<StockRecordDayEntity> manualWorkDayList = [];

  //刷新控件
  late EasyRefreshController refreshController;

  String api = '/api/stockrecord/daystatistics';

  Future getManualWorkDayStatistics({bool isRefresh = true}) async {
    //使用临时的页码，防止请求失败
    int tempPageIndex = pageIndex;
    if (isRefresh) {
      tempPageIndex = pageIndex = 1;
    } else {
      tempPageIndex++;
    }
    try {
      //接口参数
      Map<String, dynamic> para = {'PageIndex': tempPageIndex, 'PageSize': pageSize};
      var response = await httpsClient.get(api, queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      List mapList = model.list;
      List<StockRecordDayEntity> modelList = [];
      for (var item in mapList) {
        StockRecordDayEntity model = StockRecordDayEntity.fromJson(item);
        modelList.add(model);
      }
      if (mounted) {
        setState(() {
          //更新页面数据
          if (isRefresh) {
            manualWorkDayList = modelList; //下拉刷新
          } else {
            pageIndex++; //上拉加载请求成功后,真实的页码+1
            manualWorkDayList.addAll(modelList); //上拉加载
          }
          //是否可以加载更多
          hasMore = manualWorkDayList.length < model.itemsCount;
          isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
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

  @override
  void initState() {
    super.initState();
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
    getManualWorkDayStatistics();
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return EasyRefresh(
      controller: refreshController,
      // 指定刷新时的头部组件
      header: CustomRefresh.refreshHeader(),
      // 指定加载时的底部组件
      footer: CustomRefresh.refreshFooter(),
      onRefresh: () async {
        //
        await getManualWorkDayStatistics();
        refreshController.finishRefresh();
        refreshController.resetFooter();
      },
      onLoad: () async {
        // 如果没有更多直接返回
        if (!hasMore) {
          refreshController.finishLoad(IndicatorResult.noMore);
          return;
        }
        // 上拉加载更多数据请求
        await getManualWorkDayStatistics(isRefresh: false);
        // 设置状态
        refreshController.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
      },
      child: ListView.builder(
        itemCount: manualWorkDayList.length,
        itemBuilder: (context, index) {
          final item = manualWorkDayList[index];
          return StockRecordDayTable(data: item);
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
