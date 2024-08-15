import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/material_management/add_inventory.dart';
import 'package:intellectual_breed/app/modules/material_management/material_item.dart';
import 'package:intellectual_breed/app/modules/material_management/material_records/view/material_records_view.dart';
import 'package:intellectual_breed/app/modules/material_management/material_scrap/controllers/material_scrap_controller.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:intellectual_breed/app/widgets/refresh_header_footer.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:shimmer/shimmer.dart';

class MaterialScrapView extends GetView<MaterialScrapController> {
  const MaterialScrapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('报废'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                AddInventoryView.push(context, addInventoryEnum: AddInventoryEnum.scrap).then(
                  (value) {
                    if (value == true) {
                      controller.refreshController.callRefresh();
                    }
                  },
                );
              },
              child: Text(
                "新增",
                style: TextStyle(color: SaienteColors.blue275CF3, fontSize: ScreenAdapter.fontSize(16)),
              )),
        ],
      ),
      body: GetBuilder<MaterialScrapController>(
        //obx的第三种写法,为了initState方法
        init: controller,
        initState: (state) {
          debugPrint("initState 每次进入页面时触发");
          //实时获取数据
          controller.getMessageList();
        },
        builder: (MaterialScrapController controller) {
          if (controller.isLoading.value) {
            return _loadingView();
          }
          if (controller.items.isEmpty) {
            return const EmptyView();
          }
          return Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), ScreenAdapter.height(0)),
            child: Column(
                // physics: const AlwaysScrollableScrollPhysics(
                //     parent: BouncingScrollPhysics()),
                children: [
                  SizedBox(height: ScreenAdapter.height(6)),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                      child: EasyRefresh(
                        controller: controller.refreshController,
                        // 指定刷新时的头部组件
                        header: CustomRefresh.refreshHeader(),
                        // 指定加载时的底部组件
                        footer: CustomRefresh.refreshFooter(),
                        onRefresh: () async {
                          //
                          await controller.getMessageList();
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
                          await controller.getMessageList(isRefresh: false);
                          // 设置状态
                          controller.refreshController
                              .finishLoad(controller.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
                        },
                        child: controller.items.isEmpty
                            ? const EmptyView()
                            : ListView.builder(
                                itemCount: controller.items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final item = controller.items[index];
                                  // 更加不同的分类显示不同的item样式
                                  return MaterialItem(
                                    title: '单号：${item.no ?? ''}',
                                    content1: item.materialName ?? '',
                                    content2: (item.date?.replaceFirst('T', ' ').substring(0, 10)) ?? '',
                                    content3: item.executor ?? '',
                                    onTap: () {
                                      AddInventoryView.push(
                                        context,
                                        id: item.id,
                                        materialId: item.materialId,
                                        addInventoryEnum: AddInventoryEnum.viewer,
                                      );
                                    },
                                    deleteOnTap: () async {
                                      Toast.showLoading();
                                      await MaterialService.deleteMaterial(
                                        id: item.id ?? '',
                                        rowVersion: item.rowVersion ?? '',
                                        successCallback: () {
                                          Toast.dismiss();
                                          controller.refreshController.callRefresh();
                                        },
                                        errorCallback: (msg) {
                                          Toast.dismiss();
                                          Toast.failure(msg: msg);
                                        },
                                      );
                                    },
                                    editOnTap: () {
                                      AddInventoryView.push(
                                        context,
                                        id: item.id,
                                        rowVersion: item.rowVersion,
                                        materialId: item.materialId,
                                        makeCount: item.count.toString(),
                                        addInventoryEnum: AddInventoryEnum.scrapEdit,
                                        reason: item.reason,
                                      ).then((value) {
                                        if (value == true) {
                                          controller.refreshController.callRefresh();
                                        }
                                      });
                                    },
                                  );
                                },
                              ),
                      ),
                    ),
                  ),
                ]),
          );
        },
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
          itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(126),
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(126),
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
