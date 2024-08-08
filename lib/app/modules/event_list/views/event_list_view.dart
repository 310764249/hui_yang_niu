import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/simple_event.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../controllers/event_list_controller.dart';

class EventListView extends GetView<EventListController> {
  const EventListView({Key? key}) : super(key: key);

  //批次筛选列表
  Widget _batchList() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      // 优先出发isLoading的条件, 如果isLoading是false, 则触发之前的UI加载逻辑
      child: Container(
        padding: EdgeInsets.all(ScreenAdapter.width(10)),
        color: controller.items.isEmpty
            ? Colors.transparent
            : SaienteColors.backGrey,
        child: EasyRefresh(
          controller: controller.refreshController,
          // 指定刷新时的头部组件
          header: CustomRefresh.refreshHeader(),
          // 指定加载时的底部组件
          footer: CustomRefresh.refreshFooter(),
          onRefresh: () async {
            //
            await controller.searchEventsList();
            controller.refreshController.finishRefresh();
            controller.refreshController.resetFooter();
          },
          onLoad: () async {
            // 如果没有更多直接返回
            if (!controller.hasMore) {
              controller.refreshController.finishLoad(IndicatorResult.noMore);
              return;
            }
            // 上拉加载更多数据请求
            await controller.searchEventsList(isRefresh: false);
            // 设置状态
            controller.refreshController.finishLoad(controller.hasMore
                ? IndicatorResult.success
                : IndicatorResult.noMore);
          },
          child: ListView.builder(
            itemCount: controller.items.length,
            itemBuilder: (BuildContext context, int index) {
              SimpleEvent model = controller.items[index];
              return Bounceable(
                onTap: () {
                  debugPrint("点击--$index   detailRouterStr:${controller.argument.detailRouterStr}");
                  if (controller.argument.detailRouterStr != null) {
                    Get.toNamed(controller.argument.detailRouterStr!,
                        arguments: model);
                  }
                },
                child: Container(
                  // height: ScreenAdapter.height(130),
                  margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度
                    borderRadius: BorderRadius.all(
                        Radius.circular(ScreenAdapter.height(10.0))),
                    //设置四周边框
                    border: Border.all(
                        width: ScreenAdapter.width(1.0),
                        color: Colors.transparent),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: ScreenAdapter.height(10)),
                      Row(
                        children: [
                          Container(
                            width: ScreenAdapter.width(3),
                            height: ScreenAdapter.height(13.5),
                            decoration: BoxDecoration(
                              color: SaienteColors.blue275CF3,
                              borderRadius: BorderRadius.circular(
                                  ScreenAdapter.width(1.5)),
                            ),
                          ),
                          SizedBox(width: ScreenAdapter.width(5)),
                          Text(
                            controller.getItemTitle(model),
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
                              controller.argument.title, //,
                              style: TextStyle(
                                  color: SaienteColors.blackE5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.fontSize(14)),
                            ),
                            SizedBox(height: ScreenAdapter.height(3)),
                            Text(
                              '类型',
                              style: TextStyle(
                                  color: SaienteColors.black80,
                                  fontSize: ScreenAdapter.fontSize(14)),
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
                              controller.getTimeString(model),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: SaienteColors.blackE5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.fontSize(14)),
                            ),
                            SizedBox(height: ScreenAdapter.height(3)),
                            Text(
                              ' 日期',
                              style: TextStyle(
                                  color: SaienteColors.black80,
                                  fontSize: ScreenAdapter.fontSize(14)),
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
                              controller.getExecutor(model),
                              style: TextStyle(
                                  color: SaienteColors.blackE5,
                                  fontWeight: FontWeight.w500,
                                  fontSize: ScreenAdapter.fontSize(14)),
                            ),
                            SizedBox(height: ScreenAdapter.height(3)),
                            Text(
                              model.seller == null ? '操作人' : '销售人',
                              style: TextStyle(
                                  color: SaienteColors.black80,
                                  fontSize: ScreenAdapter.fontSize(14)),
                            )
                          ]))
                        ],
                      ),
                      SizedBox(height: ScreenAdapter.height(5)),
                      SizedBox(
                          width: ScreenAdapter.getScreenWidth(),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      // 阴影颜色
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      backgroundColor: MaterialStateProperty
                                          .all(SaienteColors.blueE5EEFF),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              SaienteColors.blue275CF3),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenAdapter.width(
                                                          2.5))))),
                                  onPressed: () {
                                    debugPrint('编辑');
                                    Get.toNamed(controller.argument.routerStr,
                                            arguments: model)
                                        ?.then((value) {
                                      // controller.refreshController
                                      //     .callRefresh();
                                      controller.searchEventsList();
                                    });
                                  },
                                  child: Text(
                                    '编辑',
                                    style: TextStyle(
                                        fontSize: ScreenAdapter.fontSize(14),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: ScreenAdapter.width(10),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                      // 阴影颜色
                                      shadowColor: MaterialStateProperty.all(
                                          Colors.transparent),
                                      backgroundColor: MaterialStateProperty
                                          .all(SaienteColors.blueE5EEFF),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              SaienteColors.blue275CF3),
                                      shape: MaterialStateProperty.all(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      ScreenAdapter.width(
                                                          2.5))))),
                                  onPressed: () {
                                    Alert.showConfirm(
                                      '确定删除该事件?',
                                      onConfirm: () {
                                        //debugPrint('删除');
                                        controller.deleteEvent(model);
                                      },
                                    );
                                  },
                                  child: Text(
                                    '删除',
                                    style: TextStyle(
                                        fontSize: ScreenAdapter.fontSize(14),
                                        fontWeight: FontWeight.w400),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
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
          itemCount:
              ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(132),
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(132),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(10),
                  ScreenAdapter.height(10),
                  ScreenAdapter.width(10),
                  ScreenAdapter.height(0)),
              decoration: BoxDecoration(
                //背景
                color: const Color(0xFFE0E0E0),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(
                    Radius.circular(ScreenAdapter.height(10.0))),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.argument.title),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed(controller.argument.routerStr)?.then((value) {
                  //print('controller.refreshController.callLoad();');
                  //controller.refreshController.callRefresh();
                  controller.searchEventsList();
                });
              },
              child: Text(
                "新增",
                style: TextStyle(
                    color: SaienteColors.blue275CF3,
                    fontSize: ScreenAdapter.fontSize(16)),
              ))
        ],
      ),
      body: Material(
          color: SaienteColors.backGrey,
          child: SafeArea(
            child: Obx(() => Stack(children: [
                  //顶部搜索区域
                  //_topArea(context),
                  const Positioned(child: EmptyView()),
                  controller.isLoading.value
                      ? _loadingView()
                      //批次筛选列表
                      : _batchList(),
                ])),
          )),
    );
  }
}
