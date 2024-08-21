import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intellectual_breed/app/models/feeds.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/models/page_info.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:intellectual_breed/app/widgets/refresh_header_footer.dart';
import 'package:shimmer/shimmer.dart';

class SelectFeedsView extends StatefulWidget {
  const SelectFeedsView({super.key});

  static Future<FormulaModel?> push(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      constraints: BoxConstraints.loose(Size.fromHeight(MediaQuery.of(context).size.height * 0.8)),
      builder: (context) => const SelectFeedsView(),
    );
  }

  @override
  State<SelectFeedsView> createState() => _SelectFeedsViewState();
}

class _SelectFeedsViewState extends State<SelectFeedsView> {
  HttpsClient httpsClient = HttpsClient();
  final List<Feeds> feedsTypeList = <Feeds>[];

  //配方目标
  List pfmbList = [];

  //
  bool hasMore = false;

  //当前列表
  ValueNotifier<List<FormulaModel>> items = ValueNotifier([]);

  // 是否加载中, 在[页面初始化]和[条件搜索]时触发
  var isLoading = true;

  //
  int pageIndex = 1;
  int pageSize = 8;

  //刷新控件
  late EasyRefreshController refreshController;

  @override
  void initState() {
    super.initState();
    //初始化
    refreshController = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    searchFormula(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('选择配方'),
          centerTitle: true,
        ),
        body: Builder(builder: (context) {
          if (isLoading) {
            return _loadingView();
          }
          return ValueListenableBuilder(
              valueListenable: items,
              builder: (context, value, child) {
                return EasyRefresh(
                  controller: refreshController,
                  // 指定刷新时的头部组件
                  header: CustomRefresh.refreshHeader(),
                  // 指定加载时的底部组件
                  footer: CustomRefresh.refreshFooter(),
                  onRefresh: () async {
                    //
                    await searchFormula();
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
                    await searchFormula(isRefresh: false);
                    // 设置状态
                    refreshController.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
                  },
                  child: ValueListenableBuilder(
                      valueListenable: items,
                      builder: (context, value, child) {
                        return value.isEmpty
                            ? const EmptyView()
                            : ListView.builder(
                                itemCount: value.length,
                                itemBuilder: (BuildContext context, int index) {
                                  FormulaModel model = value[index];
                                  return Bounceable(
                                    onTap: () {
                                      // Get.toNamed(Routes.RECIPE_DETAIL, arguments: model);
                                      Navigator.pop(context, model);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
                                      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), ScreenAdapter.height(10),
                                          ScreenAdapter.width(10), ScreenAdapter.height(10)),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                                      ),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                width: ScreenAdapter.width(3),
                                                height: ScreenAdapter.height(13.5),
                                                decoration: BoxDecoration(
                                                  color: SaienteColors.blue275CF3,
                                                  borderRadius: BorderRadius.circular(ScreenAdapter.width(1.5)),
                                                ),
                                              ),
                                              SizedBox(width: ScreenAdapter.width(5)),
                                              Text(
                                                model.name ?? Constant.placeholder,
                                                style: TextStyle(
                                                    fontSize: ScreenAdapter.fontSize(14),
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: ScreenAdapter.height(14)),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child: Column(children: [
                                                Text(
                                                  AppDictList.findLabelByCode(pfmbList, model.individualType.toString()),
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                      overflow: TextOverflow.ellipsis,
                                                      color: SaienteColors.blackE5,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: ScreenAdapter.fontSize(16)),
                                                ),
                                                SizedBox(height: ScreenAdapter.height(3)),
                                                Text(
                                                  '配方目标',
                                                  style: TextStyle(
                                                      color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(13)),
                                                )
                                              ])),
                                              Container(
                                                color: SaienteColors.separateLine,
                                                width: ScreenAdapter.width(1),
                                                height: ScreenAdapter.height(36),
                                              ),
                                              Expanded(
                                                  child: Column(children: [
                                                Text(
                                                  model.date ?? '',
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      color: SaienteColors.blackE5,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: ScreenAdapter.fontSize(16)),
                                                ),
                                                SizedBox(height: ScreenAdapter.height(3)),
                                                Text(
                                                  '制作日期',
                                                  style: TextStyle(
                                                      color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(13)),
                                                )
                                              ])),
                                              Container(
                                                color: SaienteColors.separateLine,
                                                width: ScreenAdapter.width(1),
                                                height: ScreenAdapter.height(36),
                                              ),
                                              Expanded(
                                                  child: Column(children: [
                                                Text(
                                                  model.executor ?? Constant.placeholder,
                                                  style: TextStyle(
                                                      color: SaienteColors.blackE5,
                                                      fontWeight: FontWeight.w500,
                                                      fontSize: ScreenAdapter.fontSize(16)),
                                                ),
                                                SizedBox(height: ScreenAdapter.height(3)),
                                                Text(
                                                  '制作人',
                                                  style: TextStyle(
                                                      color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(13)),
                                                )
                                              ])),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                      }),
                );
              });
        }),
      ),
    );
  }

  //请求数据
  Future<void> searchFormula({bool isRefresh = true}) async {
    //配方目标
    pfmbList = AppDictList.searchItems('pfmb') ?? [];

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
      var response = await httpsClient.get("/api/formula", queryParameters: para);

      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<FormulaModel> modelList = [];
      for (var item in mapList) {
        FormulaModel model = FormulaModel.fromJson(item);
        modelList.add(model);
      }
      //更新页面数据
      if (isRefresh) {
        items.value = modelList; //下拉刷新
      } else {
        pageIndex++; //上拉加载请求成功后,真实的页码+1
        items.value.addAll(modelList); //上拉加载
      }
      //按时间倒排序
      items.value.sort((a, b) => DateTime.parse(a.created!).isBefore(DateTime.parse(b.created!)) ? 1 : -1);
      //是否可以加载更多
      hasMore = items.value.length < model.itemsCount;
      setState(() {
        isLoading = false;
      });
      // Toast.dismiss();
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

  // 列表初始化加载的骨架loading
  Widget _loadingView() {
    return Container(
      color: SaienteColors.backGrey,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color.fromARGB(255, 184, 185, 227),
        child: ListView.builder(
          // 禁止列表滑动
          physics: const NeverScrollableScrollPhysics(),
          // 数量为: 屏幕高度 / item高度 取整数
          itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(80),
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(80),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), ScreenAdapter.height(0)),
              decoration: BoxDecoration(
                //背景
                color: const Color(0xFFE0E0E0),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(10.0))),
              ),
            );
          },
        ),
      ),
    );
  }
}
