import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/notice.dart';
import '../../../../services/colors.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/down_arrow_button.dart';
import '../../../../widgets/empty_view.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/refresh_header_footer.dart';
import '../controllers/action_message_list_controller.dart';

///
/// 生产任务 & 预警提醒
///
class ActionMessageListView extends GetView<ActionMessageListController> {
  const ActionMessageListView({Key? key}) : super(key: key);
  //批次筛选列表
  Widget _cattleList() {
    return Expanded(
      // 优先出发isLoading的条件, 如果isLoading是false, 则触发之前的UI加载逻辑
      child: controller.isLoading.value
          ? _loadingView()
          : controller.items.isEmpty
              ? const EmptyView()
              : Padding(
                  padding: EdgeInsets.all(ScreenAdapter.width(10)),
                  child: EasyRefresh(
                    controller: controller.refreshController,
                    // 指定刷新时的头部组件
                    header: CustomRefresh.refreshHeader(),
                    // 指定加载时的底部组件
                    footer: CustomRefresh.refreshFooter(),
                    onRefresh: () async {
                      //
                      await controller.searchCowBatch();
                      controller.refreshController.finishRefresh();
                      controller.refreshController.resetFooter();
                    },
                    onLoad: () async {
                      // 如果没有更多直接返回
                      if (!controller.hasMore) {
                        controller.refreshController
                            .finishLoad(IndicatorResult.noMore);
                        return;
                      }
                      // 上拉加载更多数据请求
                      await controller.searchCowBatch(isRefresh: false);
                      // 设置状态
                      controller.refreshController.finishLoad(controller.hasMore
                          ? IndicatorResult.success
                          : IndicatorResult.noMore);
                    },
                    child: ListView.builder(
                      itemCount: controller.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Material(
                          child: InkWell(
                            onTap: () {
                              // 点击事件
                              controller.getCattleDataAndGoToEventDetail(
                                  controller.items[index].type ?? -1,
                                  controller.items[index].cowId);
                            },
                            child: Container(
                              height: ScreenAdapter.height(106),
                              margin: EdgeInsets.only(
                                  bottom: ScreenAdapter.height(10)),
                              padding: EdgeInsets.fromLTRB(
                                  ScreenAdapter.width(10),
                                  0,
                                  ScreenAdapter.width(10),
                                  0),
                              decoration: BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度
                                borderRadius: BorderRadius.all(Radius.circular(
                                    ScreenAdapter.height(10.0))),
                                //设置四周边框
                                border: Border.all(
                                    width: ScreenAdapter.width(1.0),
                                    color: Colors.transparent),
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
                                          borderRadius: BorderRadius.circular(
                                              ScreenAdapter.width(1.5)),
                                        ),
                                      ),
                                      SizedBox(width: ScreenAdapter.width(5)),
                                      // 耳号 / 批次号 / 栋舍
                                      Text(
                                        Notice.getItemTitle(
                                            controller.items[index]),
                                        style: TextStyle(
                                            fontSize:
                                                ScreenAdapter.fontSize(14),
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
                                          // 搜索的类型
                                          Notice.getEventNameByCode(
                                              controller.items[index].type ??
                                                  -1),
                                          style: TextStyle(
                                              color: SaienteColors.blackE5,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  ScreenAdapter.fontSize(16)),
                                        ),
                                        SizedBox(
                                            height: ScreenAdapter.height(3)),
                                        Text(
                                          '类型',
                                          style: TextStyle(
                                              color: SaienteColors.black80,
                                              fontSize:
                                                  ScreenAdapter.fontSize(13)),
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
                                          AppDictList.findLabelByCode(
                                              controller.szjdList,
                                              controller
                                                  .items[index].growthStage
                                                  .toString()),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                              color: SaienteColors.blackE5,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  ScreenAdapter.fontSize(16)),
                                        ),
                                        SizedBox(
                                            height: ScreenAdapter.height(3)),
                                        Text(
                                          '状态',
                                          style: TextStyle(
                                              color: SaienteColors.black80,
                                              fontSize:
                                                  ScreenAdapter.fontSize(13)),
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
                                          AppDictList.findLabelByCode(
                                              controller.gmList,
                                              controller.items[index].gender
                                                  .toString()),
                                          style: TextStyle(
                                              color: SaienteColors.blackE5,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  ScreenAdapter.fontSize(16)),
                                        ),
                                        SizedBox(
                                            height: ScreenAdapter.height(3)),
                                        Text(
                                          '公母',
                                          style: TextStyle(
                                              color: SaienteColors.black80,
                                              fontSize:
                                                  ScreenAdapter.fontSize(13)),
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
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          controller.items[index].cowHouseName
                                              .toString(),
                                          style: TextStyle(
                                              color: SaienteColors.blackE5,
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  ScreenAdapter.fontSize(16)),
                                        ),
                                        SizedBox(
                                            height: ScreenAdapter.height(3)),
                                        Text(
                                          '栋舍',
                                          style: TextStyle(
                                              color: SaienteColors.black80,
                                              fontSize:
                                                  ScreenAdapter.fontSize(13)),
                                        )
                                      ]))
                                    ],
                                  ),
                                ],
                              ),
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
            height: ScreenAdapter.height(106),
            margin: EdgeInsets.fromLTRB(
                ScreenAdapter.width(10),
                ScreenAdapter.height(10),
                ScreenAdapter.width(10),
                ScreenAdapter.height(0)),
            decoration: BoxDecoration(
              //背景
              color: const Color(0xFFE0E0E0),
              //设置四周圆角 角度
              borderRadius:
                  BorderRadius.all(Radius.circular(ScreenAdapter.height(10.0))),
            ),
          );
        },
      ),
    );
  }

  // 顶部切换类型区域
  Widget _topArea(context) {
    return Container(
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10),
          ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
      height: ScreenAdapter.height(64),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          DownArrowButton(controller.selectedTypeName.value, () {
            Picker.showSinglePicker(
              context,
              controller.typeNameList,
              selectData: controller.selectedTypeName.value,
              title: '请选择类型',
              onConfirm: (data, position) {
                debugPrint(data);
                controller.selectedTypeName.value = data;
                controller.selectedTypeIndex = position;
                // 启动骨架loading
                controller.isLoading.value = true;
                // 设置选中的类型
                controller.searchType =
                    controller.typeList[controller.selectedTypeIndex]['value'];
                // 请求查询对应类型数据
                controller.searchCowBatch();
              },
            );
          }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.typeParam == 400 ? '生产任务' : '预警提醒'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Material(
          color: SaienteColors.backGrey,
          child: SafeArea(
            child: Obx(() => Column(children: [
                  //顶部搜索区域
                  _topArea(context),
                  //批次筛选列表
                  _cattleList(),
                ])),
          )),
    );
  }
}
