import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../models/article.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/AssetsImages.dart';
import '../../../../services/colors.dart';
import '../../../../services/constant.dart';
import '../../../../services/load_image.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/information_item.dart';
import '../../../../widgets/refresh_header_footer.dart';
import '../controllers/information_list_controller.dart';

class InformationListView extends GetView<InformationListController> {
  const InformationListView({Key? key}) : super(key: key);

  // 搜索框
  Widget _searchBar() {
    return Container(
      width: ScreenAdapter.width(268),
      height: ScreenAdapter.height(36),
      decoration: BoxDecoration(
        color: SaienteColors.whiteF2F2F2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextField(
        textInputAction: TextInputAction.search,
        onSubmitted: (value) {
          controller.searchStr = value;
          controller.isLoading.value = true;
          controller.searchArticleList();
        },
        style: TextStyle(fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.black28),
        decoration: const InputDecoration(
          hintText: '请输入标题',
          counterText: '', // 禁用默认的计数器文本
          border: InputBorder.none, //移除边框
          prefixIcon: LoadAssetImage(
            AssetsImages.searchPng,
            color: SaienteColors.black33,
          ),
        ),
      ),
    );
    /*
    InkWell(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(18), 0, ScreenAdapter.width(6), 0),
              child: const LoadAssetImage(
                AssetsImages.searchPng,
                color: SaienteColors.black33,
              ),
            ),
            Text(controller.keywords,
                style: TextStyle(
                    color: SaienteColors.black33,
                    fontSize: ScreenAdapter.fontSize(14)))
          ],
        ),
        onTap: () {
          Get.snackbar("提示", "搜索功能正在开发中", snackPosition: SnackPosition.BOTTOM);
        },
      )
    */
  }

  // 分类列表
  Widget _categoryList() {
    return Container(
        color: Colors.white,
        width: ScreenAdapter.width(58),
        height: double.infinity,
        child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
          itemCount: controller.leftCategoryNameList.length,
          itemBuilder: ((BuildContext context, int index) {
            return SizedBox(
              width: double.infinity,
              height: ScreenAdapter.height(72),
              child: Obx(() => InkWell(
                    onTap: () {
                      controller.changeIndex(index, controller.leftCategoryNameList[index] ?? "");
                    },
                    child: Stack(children: [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            width: ScreenAdapter.width(4),
                            height: ScreenAdapter.height(72),
                            decoration: BoxDecoration(
                                color: controller.selectIndex.value == index ? SaienteColors.appMain : Colors.transparent,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10), // 右上角圆角
                                  bottomRight: Radius.circular(10), // 右下角圆角
                                )),
                          )),
                      Padding(
                        padding: EdgeInsets.only(
                          left: ScreenAdapter.width(5),
                        ),
                        child: Center(
                          child: Text(
                            controller.leftCategoryNameList[index],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: controller.selectIndex.value == index ? SaienteColors.title_color : SaienteColors.black80,
                              fontSize: ScreenAdapter.fontSize(14),
                              fontWeight: controller.selectIndex.value == index ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                        ),
                      )
                    ]),
                  )),
            );
          }),
        ));
  }

  Widget _switchItem(String text, int position, Function() onTapEvent) {
    return Container(
      width: ScreenAdapter.width(77),
      height: ScreenAdapter.height(28),
      decoration: BoxDecoration(
        gradient: controller.listTypeIndex.value == position
            ? const LinearGradient(
                colors: [Color(0xFF4D91F5), Color(0xFF2559F3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              )
            : null,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: TextButton(
          onPressed: () {
            onTapEvent();
          },
          style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsets>(
            const EdgeInsets.all(0),
          )),
          child: Text(
            text,
            style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14),
                fontWeight: FontWeight.bold,
                color: controller.listTypeIndex.value == position ? Colors.white : SaienteColors.black80),
          )),
    );
  }

  // 分类切换条: 全部/视频/文章
  Widget _switchBar() {
    return Padding(
      padding: EdgeInsets.only(
        top: ScreenAdapter.height(10),
        bottom: ScreenAdapter.height(10),
      ),
      child: Center(
        child: Container(
            height: ScreenAdapter.height(28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _switchItem("全部", 0, () {
                    controller.changeListTypeIndex(0);
                  }),
                  _switchItem("视频", 1, () {
                    controller.changeListTypeIndex(1);
                  }),
                  _switchItem("文章", 2, () {
                    controller.changeListTypeIndex(2);
                  }),
                ],
              ),
            )),
      ),
    );
  }

  // 列表骨架loading
  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color.fromARGB(255, 184, 185, 227),
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1 / 1.3,
            crossAxisSpacing: ScreenAdapter.width(1),
            mainAxisSpacing: ScreenAdapter.width(8)),
        // 禁止列表滑动
        physics: const NeverScrollableScrollPhysics(),
        // 数量为: 屏幕高度 / item高度 取整数
        itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(100) * 2,
        itemBuilder: (context, index) {
          return Container(
            // height: ScreenAdapter.height(300),
            margin: EdgeInsets.only(right: ScreenAdapter.width(10)),
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

  // 内容列表
  Widget _informationList() {
    return Expanded(
        child: Container(
      color: SaienteColors.whiteECEFF6,
      child: Padding(
        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, 0, 0),
        child: SizedBox(
            height: double.infinity,
            // child: Obx(() => Column(
            child: Column(
              children: [
                // Switcher
                _switchBar(),

                // Information list
                Expanded(
                  child: controller.isLoading.value
                      ? _loadingView()
                      : controller.items.isEmpty
                          ? const EmptyView()
                          : EasyRefresh(
                              controller: controller.refreshController,
                              // 指定刷新时的头部组件
                              header: CustomRefresh.refreshHeader(),
                              // 指定加载时的底部组件
                              footer: CustomRefresh.refreshFooter(),
                              onRefresh: () async {
                                //
                                await controller.searchArticleList();
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
                                await controller.searchArticleList(isRefresh: false);
                                // 设置状态
                                controller.refreshController
                                    .finishLoad(controller.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
                              },
                              child: GridView.builder(
                                  // itemCount: controller.rightCategoryList.length,
                                  itemCount: controller.items.length,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, childAspectRatio: 147 / 198), // 宽高比
                                  itemBuilder: (context, index) {
                                    Article model = controller.items[index];
                                    String isVideo = '';
                                    model.type == 4 ? isVideo = '&poster=true' : isVideo;
                                    return InformationItem(
                                        image: '${Constant.uploadFileUrl}${model.coverImg}$isVideo',
                                        title: model.title ?? '',
                                        userIcon: AssetsImages.avatar,
                                        userName: model.publisher ?? '',
                                        isVideo: model.type == 4,
                                        onPressed: () {
                                          String openURL = "${Constant.articleHost}/${model.type}/${model.id}";
                                          Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
                                        });
                                  }),
                            ),
                )
              ],
            )),
      ),
    ));
  }

  Widget _buildView() {
    return Obx(() => Row(children: [
          // 左侧分类列表
          _categoryList(),
          // 右侧内容列表
          _informationList(),
        ]));
  }

  @override
  Widget build(BuildContext context) {
    // 接收传递参数, 如果没有传递则默认类型是全部
    final Map arguments = Get.arguments ?? {'category': 0, 'type': 0};
    int type = arguments['type'] ?? 0;
    int category = arguments['category'] ?? 0;
    if (type != 0) {
      controller.changeIndex(arguments['type'], '');
    }
    if (category != 0) {
      controller.changeListTypeIndex(arguments['category']);
    }

    if (category == 0 && type == 0) {
      controller.searchArticleList();
    }

    return Scaffold(
        appBar: AppBar(
          title: _searchBar(),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Material(
          child: SafeArea(child: _buildView()),
        ));
  }
}
