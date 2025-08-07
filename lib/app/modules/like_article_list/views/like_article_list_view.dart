import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/article.dart';
import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/constant.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/information_item.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../controllers/like_article_list_controller.dart';

class LikeArticleListView extends GetView<LikeArticleListController> {
  const LikeArticleListView({Key? key}) : super(key: key);

  // 列表初始化加载的骨架loading
  Widget _loadingView() {
    return Shimmer.fromColors(
      baseColor: const Color(0xFFE0E0E0),
      highlightColor: const Color.fromARGB(255, 184, 185, 227),
      child: GridView.builder(
        // 禁止列表滑动
        physics: const NeverScrollableScrollPhysics(),
        // 数量为: 屏幕高度 / item高度 取整数
        itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(106),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 147 / 178,
        ), // 宽高
        itemBuilder: (context, index) {
          return Container(
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
              borderRadius: BorderRadius.all(
                Radius.circular(ScreenAdapter.height(10.0)),
              ),
            ),
          );
        },
      ),
    );
  }

  //列表
  Widget _articleList() {
    return Expanded(
      child:
          controller.isLoading.value
              ? _loadingView()
              : controller.items.isEmpty
              ? const EmptyView()
              : Padding(
                padding: EdgeInsets.all(ScreenAdapter.width(0)),
                child: EasyRefresh(
                  controller: controller.refreshController,
                  // 指定刷新时的头部组件
                  header: CustomRefresh.refreshHeader(),
                  // 指定加载时的底部组件
                  footer: CustomRefresh.refreshFooter(),
                  onRefresh: () async {
                    //
                    await controller.searchArticle();
                    controller.refreshController.finishRefresh();
                    controller.refreshController.resetFooter();
                  },
                  onLoad: () async {
                    // 如果没有更多直接返回
                    if (!controller.hasMore) {
                      controller.refreshController.finishLoad(
                        IndicatorResult.noMore,
                      );
                      return;
                    }
                    // 上拉加载更多数据请求
                    await controller.searchArticle(isRefresh: false);
                    // 设置状态
                    controller.refreshController.finishLoad(
                      controller.hasMore
                          ? IndicatorResult.success
                          : IndicatorResult.noMore,
                    );
                  },
                  child: GridView.builder(
                    itemCount: controller.items.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 147 / 198,
                        ), // 宽高比
                    itemBuilder: (BuildContext context, int index) {
                      var model = controller.items[index];
                      String isVideo = '';
                      if (controller.title.value != '点赞') {
                        model = model as FavoriteModel;
                        model.type == 4 ? isVideo = '&poster=true' : isVideo;
                      } else {
                        model = model as TsanModel;
                        model.type == 4 ? isVideo = '&poster=true' : isVideo;
                      }

                      return InformationItem(
                        image:
                            '${Constant.uploadFileUrl}${model.coverImg}$isVideo',
                        title: model.title ?? '',
                        userIcon: AssetsImages.avatar,
                        userName: model.publisher ?? '',
                        isVideo: model.type == 4,
                        onPressed: () {
                          String openURL = Constant.getCMS(
                            model.type,
                            model.id,
                          );
                          Get.toNamed(
                            Routes.INFORMATION_DETAIL,
                            arguments: openURL,
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.title.value),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Material(
        color: SaienteColors.backGrey,
        child: SafeArea(child: Obx(() => Column(children: [_articleList()]))),
      ),
    );
  }
}
