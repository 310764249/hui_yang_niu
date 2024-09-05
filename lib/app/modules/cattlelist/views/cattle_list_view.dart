import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intellectual_breed/app/services/Log.dart';

import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/down_arrow_button.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:intellectual_breed/app/widgets/main_button.dart';
import 'package:intellectual_breed/app/widgets/search_field.dart';
import 'package:easy_refresh/easy_refresh.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:shimmer/shimmer.dart';

import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/load_image.dart';
import '../../../widgets/alert.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/picker.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/cattle_list_controller.dart';

class CattleListView extends GetView<CattleListController> {
  const CattleListView({Key? key}) : super(key: key);

  //顶部搜索区域
  Widget _topArea(context) {
    return Container(
        // height: ScreenAdapter.height(100),
        // color: Colors.greenAccent,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
        child: Column(
          children: [
            Row(
              children: [
                DownArrowButton(controller.selectedSexName.value, () {
                  Picker.showSinglePicker(
                    context,
                    controller.sexNameList,
                    title: '请选择公母',
                    onConfirm: (data, position) {
                      print(data);
                      controller.selectedSexName.value = data;
                      controller.selectedSexIndex = position;
                      controller.startLoading();
                      controller.searchCowList();
                    },
                  );
                }),
                SizedBox(width: ScreenAdapter.width(10)),
                DownArrowButton(controller.selectedStateName.value, () {
                  /*
                  Picker.showSinglePicker(
                    context,
                    controller.stateNameList,
                    title: '请选择类型',
                    onConfirm: (data, position) {
                      //print(data);
                      controller.selectedStateName.value = data;
                      controller.selectedStateIndex = position;
                      controller.startLoading();
                      controller.searchCowList();
                    },
                  );
                  */
                  //多选
                  Alert.showMultiPicker(
                    controller.stateNameList,
                    context,
                    itemsSelected: List.from(controller.selectedStateIndex),
                    onConfirm: (selected) {
                      if (ObjectUtil.isEmptyList(selected)) {
                        Toast.failure(msg: '请至少选择一种类型');
                        // print('请至少选择一种类型');
                        return;
                      }
                      Log.d('onConfirm' + selected.toString());
                      //这里是数组类型
                      controller.selectedStateIndex = selected;
                      controller.startLoading();
                      controller.searchCowList();
                    },
                  );
                }),
                SizedBox(width: ScreenAdapter.width(10)),
                DownArrowButton(controller.selectedHouseName.value, () {
                  Picker.showSinglePicker(
                    context,
                    controller.houseNameList,
                    title: '请选择栋舍',
                    onConfirm: (data, position) {
                      print(data);
                      controller.selectedHouseName.value = data;
                      controller.selectedHouseIndex = position - 1; //选项中多了一个全部，所以实际上要-1
                      controller.startLoading();
                      controller.searchCowList();
                    },
                  );
                }),
              ],
            ),
            SizedBox(height: ScreenAdapter.height(5)),
            Row(
              children: [
                DownArrowButton(controller.selectedTypeName.value, () {
                  Picker.showSinglePicker(
                    context,
                    controller.typeNameList,
                    title: '请选择品种',
                    onConfirm: (data, position) {
                      print(data);
                      controller.selectedTypeName.value = data;
                      controller.selectedTypeIndex = position;
                      controller.startLoading();
                      controller.searchCowList();
                    },
                  );
                }),
                SizedBox(width: ScreenAdapter.width(10)),
                SearchField(
                  hintText: '搜索牛只耳号',
                  onSubmitted: (value) {
                    print('onSubmitted: $value');
                    controller.cowCode = value;
                    controller.startLoading();
                    controller.searchCowList();
                  },
                ),
              ],
            ),
          ],
        ));
  }

  //牛只筛选列表
  Widget _cattleList() {
    return Obx(() => Expanded(
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
                          await controller.searchCowList();
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
                          await controller.searchCowList(isRefresh: false);
                          // 设置状态
                          controller.refreshController
                              .finishLoad(controller.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
                        },
                        child: GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: ScreenAdapter.width(8),
                              mainAxisSpacing: ScreenAdapter.width(8)),
                          itemCount: controller.items.length,
                          itemBuilder: (BuildContext context, int index) {
                            //是否选中
                            bool isSelected = controller.items[index].isSelected;
                            return Bounceable(
                              onTap: () {
                                //debugPrint("点击--$index");
                                if (controller.argument.goBack) {
                                  controller.selectIndex(index);
                                } else {
                                  if (controller.argument.routerStr == null) {
                                    Get.toNamed(Routes.CATTLE_DETAIL, arguments: controller.items[index])?.then((value) {
                                      if (value != null && value == 1) {
                                        //1 表示更新成功，需要刷新页面
                                        controller.refreshController.callRefresh();
                                      }
                                    });
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  //背景
                                  color: isSelected ? SaienteColors.blueE5EEFF : Colors.white,
                                  //设置四周圆角 角度
                                  borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(5.0))),
                                  //设置四周边框
                                  border: Border.all(
                                      width: ScreenAdapter.width(1.0),
                                      color: isSelected ? SaienteColors.blue275CF3 : Colors.transparent),
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          height: ScreenAdapter.height(20),
                                          padding: EdgeInsets.fromLTRB(
                                            ScreenAdapter.width(5),
                                            ScreenAdapter.width(1),
                                            ScreenAdapter.width(5),
                                            ScreenAdapter.width(0),
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected ? SaienteColors.blue275CF3 : SaienteColors.gray0D,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(ScreenAdapter.width(5.0)),
                                              bottomRight: Radius.circular(ScreenAdapter.width(5.0)),
                                            ),
                                          ),
                                          child: Text(
                                            AppDictList.findLabelByCode(
                                                controller.typeList, controller.items[index].kind.toString()),
                                            style: TextStyle(
                                                color: isSelected ? Colors.white : SaienteColors.black80,
                                                fontSize: ScreenAdapter.fontSize(12)),
                                          ),
                                        ),
                                        const Spacer(),
                                        controller.argument.goBack
                                            ? const SizedBox()
                                            : InkWell(
                                                onTap: () {
                                                  Alert.showConfirm(
                                                    '确定删除${controller.items[index].code}牛只吗?',
                                                    onConfirm: () {
                                                      controller.requestDelete(controller.items[index]);
                                                    },
                                                  );
                                                },
                                                child: const Icon(
                                                  Icons.close_rounded,
                                                  color: SaienteColors.black40,
                                                ),
                                              ),
                                      ],
                                    ),
                                    SizedBox(height: ScreenAdapter.height(2)),
                                    // [牛只图标]根据性别显示不同颜色的牛只icon
                                    controller.items[index].gender == 1
                                        ? const LoadImage(AssetsImages.selection)
                                        : const ColorFiltered(
                                            colorFilter: ColorFilter.mode(Colors.redAccent, BlendMode.srcIn),
                                            child: LoadImage(AssetsImages.selection),
                                          ),
                                    SizedBox(height: ScreenAdapter.height(5)),
                                    Text(
                                      controller.items[index].code ?? Constant.placeholder,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: isSelected ? SaienteColors.blue275CF3 : SaienteColors.blackE5,
                                          fontSize: ScreenAdapter.fontSize(13),
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(height: ScreenAdapter.height(5)),
                                    Text(
                                      '日龄${controller.items[index].ageOfDay}天',
                                      style: TextStyle(
                                          color: isSelected ? SaienteColors.blue275CF3 : SaienteColors.black80,
                                          fontSize: ScreenAdapter.fontSize(13),
                                          fontWeight: FontWeight.w300),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
        ));
  }

  // 列表骨架loading
  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color.fromARGB(255, 184, 185, 227),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.0,
              crossAxisSpacing: ScreenAdapter.width(8),
              mainAxisSpacing: ScreenAdapter.width(8)),
          // 禁止列表滑动
          physics: const NeverScrollableScrollPhysics(),
          // 数量为: 屏幕高度 / item高度 取整数
          itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(104) * 3,
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(104),
              decoration: BoxDecoration(
                //背景
                color: const Color(0xFFE0E0E0),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(5.0))),
              ),
            );
          },
        ),
      ),
    );
  }

  //底部确认按钮
  Widget _bottomButton() {
    return controller.argument.goBack == false
        ? const SizedBox()
        : Container(
            height: ScreenAdapter.height(50),
            width: ScreenAdapter.getScreenWidth(),
            padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
            // color: Colors.amber,(已选择 1 头牛) 确认选择
            child: MainButton(
                text: "（已选择${controller.selectItems.length}头牛）确认选择",
                onPressed: () {
                  if (controller.argument.goBack) {
                    Get.back(result: controller.selectItems);
                  } else {
                    print(controller.argument.routerStr);
                    Get.toNamed(controller.argument.routerStr!);
                  }
                }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('选择牛只'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Material(
        child: SafeArea(
          child: Container(
            color: SaienteColors.backGrey,
            child: Obx(() => Column(children: [
                  //顶部搜索区域
                  _topArea(context),
                  //牛只筛选列表
                  _cattleList(),
                  //底部确认按钮
                  _bottomButton(),
                ])),
          ),
        ),
      ),
    );
  }
}
