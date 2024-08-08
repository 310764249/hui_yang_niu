import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:intellectual_breed/app/models/cow_house.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/AssetsImages.dart';
import '../../../../services/colors.dart';
import '../../../../services/load_image.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/alert.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/empty_view.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/refresh_header_footer.dart';
import '../controllers/cattle_house_list_controller.dart';

class CattleHouseListView extends GetView<CattleHouseListController> {
  const CattleHouseListView({Key? key}) : super(key: key);

  //栋舍列表
  Widget _houseList() {
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
                      await controller.searchCowHouse();
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
                      await controller.searchCowHouse(isRefresh: false);
                      // 设置状态
                      controller.refreshController.finishLoad(controller.hasMore
                          ? IndicatorResult.success
                          : IndicatorResult.noMore);
                    },
                    child: ListView.builder(
                      itemCount: controller.items.length,
                      // physics: const AlwaysScrollableScrollPhysics(
                      //     parent: BouncingScrollPhysics()),
                      itemBuilder: (BuildContext context, int index) {
                        CowHouse model = controller.items[index];
                        //是否选中
                        bool isSelected = model.isSelected;
                        return InkWell(
                          onTap: () {
                            //print("点击--$index");
                            controller.selectIndex(index);
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
                              color: isSelected
                                  ? SaienteColors.blueE5EEFF
                                  : Colors.white,
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenAdapter.height(10.0))),
                              //设置四周边框
                              border: isSelected
                                  ? Border.all(
                                      width: ScreenAdapter.width(1.0),
                                      color: SaienteColors.blue275CF3)
                                  : Border.all(
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
                                    Text(
                                      '栋舍名称-',
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.fontSize(14),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      model.name ?? Constant.placeholder,
                                      style: TextStyle(
                                          fontSize: ScreenAdapter.fontSize(14),
                                          fontWeight: FontWeight.w400,
                                          color: Colors.black),
                                    ),
                                    const Spacer(),
                                    isSelected
                                        ? LoadImage(
                                            AssetsImages.checkedPng,
                                            width: ScreenAdapter.width(16),
                                            height: ScreenAdapter.width(16),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                SizedBox(height: ScreenAdapter.height(14)),
                                Row(
                                  children: [
                                    Expanded(
                                        child: Column(children: [
                                      Text(
                                        AppDictList.findLabelByCode(
                                            controller.typeList,
                                            model.type.toString()), //,
                                        style: TextStyle(
                                            color: SaienteColors.blackE5,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                ScreenAdapter.fontSize(16)),
                                      ),
                                      SizedBox(height: ScreenAdapter.height(3)),
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
                                        model.occupied.toString(),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: SaienteColors.blackE5,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                ScreenAdapter.fontSize(16)),
                                      ),
                                      SizedBox(height: ScreenAdapter.height(3)),
                                      Text(
                                        '入住数',
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
                                        model.capacity.toString(),
                                        style: TextStyle(
                                            color: SaienteColors.blackE5,
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                ScreenAdapter.fontSize(16)),
                                      ),
                                      SizedBox(height: ScreenAdapter.height(3)),
                                      Text(
                                        '容纳量',
                                        style: TextStyle(
                                            color: SaienteColors.black80,
                                            fontSize:
                                                ScreenAdapter.fontSize(13)),
                                      )
                                    ])),
                                  ],
                                ),
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

  //顶部搜索区域
  Widget _topArea(context) {
    return Container(
      height: ScreenAdapter.height(60),
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: SaienteColors.gray0D,
          borderRadius: BorderRadius.circular(ScreenAdapter.height(25)),
        ),
        child: TextField(
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(16),
              color: SaienteColors.black28),
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            //print('onSubmitted-$value');
            controller.houseName = value;
            // 搜索条件触发时列表开始loading
            controller.isLoading.value = true;
            controller.searchCowHouse();
          },
          decoration: InputDecoration(
            hintText: '搜索栋舍名称',
            counterText: '', // 禁用默认的计数器文本
            border: InputBorder.none, //移除边框
            //contentPadding: EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
            hintStyle: TextStyle(
                fontSize: ScreenAdapter.fontSize(16),
                color: SaienteColors.black33),
            prefixIcon: const LoadAssetImage(
              AssetsImages.searchPng,
              color: SaienteColors.black33,
            ),
          ),
        ),
      ),
    );
  }

  //底部确认按钮
  Widget _bottomButton() {
    return controller.items.isEmpty
        ? const SizedBox()
        : Container(
            height: ScreenAdapter.height(50),
            width: ScreenAdapter.getScreenWidth(),
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
            // color: Colors.amber,(已选择 1 头牛) 确认选择
            child: MainButton(
                text: "（已选择${controller.selectItems.length}个栋舍）确认选择",
                onPressed: () {
                  if (controller.selectItems.isEmpty) {
                    Alert.showConfirm(
                      '未选择任何栋舍，确认返回？',
                      onConfirm: () {
                        Get.back();
                      },
                    );
                  } else {
                    Get.back(result: controller.selectItems);
                  }
                }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('栋舍列表'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.ADD_CATTLE_HOUSE)?.then((value) {
                  controller.refreshController.callRefresh();
                });
              },
              child: Text(
                "新增栋舍",
                style: TextStyle(
                    color: SaienteColors.blue275CF3,
                    fontSize: ScreenAdapter.fontSize(16)),
              ))
        ],
      ),
      body: Material(
          color: SaienteColors.backGrey,
          child: SafeArea(
            child: Obx(() => Column(children: [
                  //顶部搜索区域
                  _topArea(context),
                  //栋舍列表
                  _houseList(),
                  //底部确认按钮
                  _bottomButton(),
                ])),
          )),
    );
  }
}
