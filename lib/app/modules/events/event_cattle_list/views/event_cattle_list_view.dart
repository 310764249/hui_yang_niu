import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/AssetsImages.dart';
import '../../../../services/colors.dart';
import '../../../../services/constant.dart';
import '../../../../services/load_image.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/down_arrow_button.dart';
import '../../../../widgets/empty_view.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/refresh_header_footer.dart';
import '../../../../widgets/search_field.dart';
import '../controllers/event_cattle_list_controller.dart';

/// 事件筛查牛只专用，与牛只列表无关！！！！！
class EventCattleListView extends GetView<EventCattleListController> {
  const EventCattleListView({Key? key}) : super(key: key);

  //顶部搜索区域
  Widget _topArea(context) {
    return Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10),
            ScreenAdapter.height(10), ScreenAdapter.width(10), 0),
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
                      controller.searchCowlist();
                    },
                  );
                }),
                SizedBox(width: ScreenAdapter.width(10)),
                DownArrowButton(controller.selectedStateName.value, () {
                  Picker.showSinglePicker(
                    context,
                    controller.stateNameList,
                    title: '请选择类型',
                    onConfirm: (data, position) {
                      print(data);
                      controller.selectedStateName.value = data;
                      controller.selectedStateIndex = position;
                      controller.searchCowlist();
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
                      controller.selectedHouseIndex =
                          position - 1; //选项中多了一个全部，所以实际上要-1
                      controller.searchCowlist();
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
                      controller.searchCowlist();
                    },
                  );
                }),
                SizedBox(width: ScreenAdapter.width(10)),
                SearchField(
                  hintText: '搜索牛只耳号',
                  onSubmitted: (value) {
                    print('onSubmitted: $value');
                    controller.cowCode = value;
                    controller.searchCowlist();
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
          child: controller.items.isEmpty
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
                      await controller.searchCowlist();
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
                      await controller.searchCowlist(isRefresh: false);
                      // 设置状态
                      controller.refreshController.finishLoad(controller.hasMore
                          ? IndicatorResult.success
                          : IndicatorResult.noMore);
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
                        return InkWell(
                          onTap: () {
                            debugPrint("点击--$index");
                            controller.selectIndex(index);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              //背景
                              color: isSelected
                                  ? SaienteColors.blueE5EEFF
                                  : Colors.white,
                              //设置四周圆角 角度
                              borderRadius: BorderRadius.all(
                                  Radius.circular(ScreenAdapter.width(5.0))),
                              //设置四周边框
                              border: Border.all(
                                  width: ScreenAdapter.width(1.0),
                                  color: isSelected
                                      ? SaienteColors.blue275CF3
                                      : Colors.transparent),
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
                                        color: isSelected
                                            ? SaienteColors.blue275CF3
                                            : SaienteColors.gray0D,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(
                                              ScreenAdapter.width(5.0)),
                                          bottomRight: Radius.circular(
                                              ScreenAdapter.width(5.0)),
                                        ),
                                      ),
                                      child: Text(
                                        AppDictList.findLabelByCode(
                                            controller.typeList,
                                            controller.items[index].kind
                                                .toString()),
                                        style: TextStyle(
                                            color: isSelected
                                                ? Colors.white
                                                : SaienteColors.black80,
                                            fontSize:
                                                ScreenAdapter.fontSize(12)),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                SizedBox(height: ScreenAdapter.height(2)),
                                controller.items[index].gender == 1
                                    ? const LoadImage(AssetsImages.selection)
                                    : const ColorFiltered(
                                        colorFilter: ColorFilter.mode(
                                            Colors.redAccent, BlendMode.srcIn),
                                        child:
                                            LoadImage(AssetsImages.selection),
                                      ),
                                SizedBox(height: ScreenAdapter.height(5)),
                                Text(
                                  controller.items[index].code ??
                                      Constant.placeholder,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: isSelected
                                          ? SaienteColors.blue275CF3
                                          : SaienteColors.blackE5,
                                      fontSize: ScreenAdapter.fontSize(13),
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(height: ScreenAdapter.height(5)),
                                Text(
                                  '日龄${controller.items[index].ageOfDay}天',
                                  style: TextStyle(
                                      color: isSelected
                                          ? SaienteColors.blue275CF3
                                          : SaienteColors.black80,
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

  //底部确认按钮
  Widget _bottomButton() {
    return Container(
        height: ScreenAdapter.height(50),
        width: ScreenAdapter.getScreenWidth(),
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
        // color: Colors.amber,(已选择 1 头牛) 确认选择
        child: MainButton(
            text: "（已选择${controller.selectItems.length}头牛）确认选择",
            onPressed: () {
              if (controller.selectItems.isEmpty) {
                Toast.failure(msg: '未选择牛只');
                return;
              }
              //触发跳转
              controller.callRouter();
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.argument.title}牛只'),
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
