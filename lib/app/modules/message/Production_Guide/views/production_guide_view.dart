import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/load_image.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/production_puide_controller.dart';

/**
 * 生产指南
 */
class ProductionGuideView extends GetView<ProductionGuideController> {
  const ProductionGuideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SaienteColors.backGrey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // Navigator.of(context).pop();
            Get.back();
          },
        ),
        title: const Text('生产指南'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Material(
        color: SaienteColors.backGrey,
        child: Obx(() {
          if (controller.isLoading.value) {
            return _loadingView();
          }
          if (controller.articleGuideList.isEmpty) {
            return const EmptyView();
          }
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 14).r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: controller.articleGuideList.length,
                itemBuilder: (_, index) {
                  final item = controller.articleGuideList[index];
                  return TextButton(
                    onPressed: () {
                      String openURL = "${Constant.articleHost}/${item.type}/${item.id}";
                      Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
                    },
                    style: TextButton.styleFrom(
                        surfaceTintColor: SaienteColors.appMain,
                        backgroundColor: Colors.white,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        shape: const RoundedRectangleBorder()),
                    child: Row(
                      children: [
                        const LoadAssetImage(
                          AssetsImages.task,
                          fit: BoxFit.cover,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                  color: SaienteColors.blackE5,
                                  fontSize: ScreenAdapter.fontSize(16),
                                  fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              item.desc,
                              style: TextStyle(
                                  color: SaienteColors.black80,
                                  fontSize: ScreenAdapter.fontSize(13),
                                  fontWeight: FontWeight.w400),
                            ),
                          ],
                        )),
                        const Icon(
                          Icons.arrow_forward_ios_outlined,
                          size: 16,
                          color: SaienteColors.black333333,
                        )
                      ],
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const Divider(
                    color: SaienteColors.separateLine,
                    height: 1,
                  );
                },
              ),
            ),
          );
        }),
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
          itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(56),
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(56),
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
