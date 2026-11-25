import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../controllers/tabs_controller.dart';

class TabsView extends GetView<TabsController> {
  const TabsView({super.key});

  Widget _buildTabItem(int index) {
    final bool selected = controller.currentIndex.value == index;
    final Image icon =
        selected
            ? controller.tabFillIcons[index]
            : controller.tabLineIcons[index];

    return Expanded(
      child: InkWell(
        onTap: () {
          controller.setCurrentIndex(index);
          controller.pageController.jumpToPage(index);
        },
        child: SizedBox(
          height: 64,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 24, height: 24, child: icon),
              const SizedBox(height: 3),
              Text(
                controller.names[index],
                style: TextStyle(
                  color:
                      selected
                          ? SaienteColors.appMain
                          : const Color(0xFF999999),
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    final double bottomInset = MediaQuery.paddingOf(context).bottom;

    return SizedBox(
      height: 95 + bottomInset,
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: 31,
            right: 0,
            bottom: 0,
            left: 0,
            child: Material(
              color: Colors.white,
              elevation: 8,
              child: Padding(
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Row(
                  children: [
                    _buildTabItem(0),
                    const SizedBox(width: 92),
                    _buildTabItem(1),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: Semantics(
              button: true,
              label: '牛博士',
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: controller.openCowDoctor,
                child: Container(
                  width: 76,
                  height: 76,
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.14),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AssetsImages.cowDoctor,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 预加载tab图片
    controller.precacheIcons(context);
    return Obx(
      () => WillPopScope(
        onWillPop: () async {
          // 处理返回键事件:返回 true 表示允许退出应用，返回 false 表示阻止退出应用
          return controller.onBackPressed(context);
        },
        child: Scaffold(
          body: PageView(
            controller: controller.pageController,
            physics: const NeverScrollableScrollPhysics(), // 禁止横向滑动
            onPageChanged: (index) {
              controller.setCurrentIndex(index);
            },
            children: controller.pages,
          ),
          bottomNavigationBar: _buildBottomBar(context),
        ),
      ),
    );
  }
}
