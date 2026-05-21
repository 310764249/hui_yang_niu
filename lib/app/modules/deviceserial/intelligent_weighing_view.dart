import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/smart_weight_model.dart';
import 'package:intellectual_breed/app/modules/deviceserial/smart_temp_line_chart.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:shimmer/shimmer.dart';

import '../../models/cattle.dart';
import '../../models/page_info.dart';
import '../../models/smart_ear_tag_model.dart';
import '../../network/apiException.dart';
import '../../routes/app_pages.dart';
import '../../services/Log.dart';
import '../../services/colors.dart';
import '../../services/screenAdapter.dart';
import '../../widgets/empty_view.dart';
import '../../widgets/refresh_header_footer.dart';

class IntelligentWeighingView extends StatefulWidget {
  const IntelligentWeighingView({super.key});

  @override
  State<IntelligentWeighingView> createState() => _IntelligentWeighingViewState();
}

class _IntelligentWeighingViewState extends State<IntelligentWeighingView>
    with AutomaticKeepAliveClientMixin {
  HttpsClient httpsClient = HttpsClient();

  //
  int pageIndex = 1;
  int pageSize = 10;

  //
  bool hasMore = false;

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  bool isLoading = true;

  //刷新控件
  late EasyRefreshController refreshController;
  List<SmartWeightModel> items = [];

  @override
  void initState() {
    super.initState();
    refreshController = EasyRefreshController(controlFinishRefresh: true, controlFinishLoad: true);
    getData();
  }

  //请数据
  Future<void> getData({bool isRefresh = true}) async {
    try {
      //使用临时的页码，防止请求失败
      int tempPageIndex = pageIndex;
      if (isRefresh) {
        tempPageIndex = pageIndex = 1;
      } else {
        tempPageIndex++;
      }

      //接口参数
      Map<String, dynamic> para = {'PageIndex': tempPageIndex, 'PageSize': pageSize};
      var response = await httpsClient.get(
        '/api/intelligenteartag/getweightlist',
        queryParameters: para,
      );

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<SmartWeightModel> modelList = [];

      for (var item in mapList) {
        SmartWeightModel model = SmartWeightModel.fromJson(item);
        modelList.add(model);
      }

      setState(() {
        //更新页面数据
        if (isRefresh) {
          items = modelList; //下拉刷新
        } else {
          pageIndex++; //上拉加载请求成功后,真实的页码+1
          items.addAll(modelList); //上拉加载
        }
        //是否可以加载更多
        hasMore = items.length < model.itemsCount;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
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
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return isLoading
        ? _loadingView()
        : items.isEmpty
        ? const EmptyView()
        : Padding(
          padding: EdgeInsets.all(ScreenAdapter.width(0)),
          child: EasyRefresh(
            controller: refreshController,
            // 指定刷新时的头部组件
            header: CustomRefresh.refreshHeader(),
            // 指定加载时的底部组件
            footer: CustomRefresh.refreshFooter(),
            onRefresh: () async {
              //
              await getData();
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
              await getData(isRefresh: false);
              // 设置状态
              refreshController.finishLoad(
                hasMore ? IndicatorResult.success : IndicatorResult.noMore,
              );
            },
            child: ListView.builder(
              itemCount: items.length,

              itemBuilder: (BuildContext context, int index) {
                var model = items[index];

                return _ItemView(
                  model: model,
                  onTapEarTag: () => onTapEarTag(model),
                  onTapMore: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SmartTempLineChart(
                          records:
                              model.weightRecordList?.map((e) {
                                TempRecord record = TempRecord(value: e.value, date: e.date);
                                return record;
                              }).toList() ??
                              [],
                          unit: 'kg',
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        );
  }

  // 列表初始化加载的骨架loading
  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color.fromARGB(255, 184, 185, 227),
      child: ListView.builder(
        // 禁止列表滑动
        physics: const NeverScrollableScrollPhysics(),
        // 数量为: 屏幕高度 / item高度 取整数
        itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(106),
        itemBuilder: (context, index) {
          return Container(
            height: 200,
            margin: EdgeInsets.fromLTRB(
              ScreenAdapter.width(5),
              ScreenAdapter.height(10),
              ScreenAdapter.width(5),
              ScreenAdapter.height(0),
            ),
            decoration: BoxDecoration(
              //背景
              color: const Color(0xFFE0E0E0),
              //设置四周圆角 角度
              borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(10.0))),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  void onTapEarTag(SmartWeightModel model) async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get("/api/cow/${model.id}");
      var selectedCow = Cattle.fromJson(response);
      Get.toNamed(Routes.CATTLE_DETAIL, arguments: selectedCow);
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
    }
  }
}

class _ItemView extends StatelessWidget {
  const _ItemView({super.key, required this.model, this.onTapMore, this.onTapEarTag});

  final SmartWeightModel model;
  final VoidCallback? onTapMore;

  //点击耳号
  final VoidCallback? onTapEarTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              const Text('场内耳号：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(
                child: GestureDetector(
                  onTap: onTapEarTag,
                  child: Text(
                    model.code,
                    style: const TextStyle(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                      color: SaienteColors.blue275CF3,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('电子耳号：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(child: Text(model.eleCode, style: const TextStyle(fontSize: 14))),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('当前体重：', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Expanded(
                child: Text(
                  (model.weightRecordList ?? []).isEmpty
                      ? '暂无数据'
                      : (model.weightRecordList ?? []).last.dateString,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: onTapMore,
            child: const Text('查看历史体重', style: TextStyle(color: SaienteColors.blue275CF3)),
          ),
        ],
      ),
    );
  }
}
