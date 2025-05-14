import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../services/colors.dart';
import '../controllers/tabs_controller.dart';

class TabsView extends GetView<TabsController> {
  const TabsView({super.key});

  Widget _getCustomItems() {
    List<Widget> items = [];
    for (var i = 0; i < controller.names.length; i++) {
      TextButton item = TextButton.icon(
        icon: Icon(
          controller.icons[i],
          color: controller.currentIndex.value == i ? Colors.red : Colors.grey,
        ),
        label: Text(
          controller.names[i],
          style: TextStyle(color: controller.currentIndex.value == i ? Colors.red : Colors.grey),
        ),
        onPressed: () {
          controller.setCurrentIndex(i);
          //触发 PageView 的滑动
          controller.pageController.jumpToPage(i);
        },
      );
      items.add(item);
    }
    return Row(mainAxisSize: MainAxisSize.max, mainAxisAlignment: MainAxisAlignment.spaceBetween, children: items);
  }

  List<BottomNavigationBarItem> _getItems() {
    List<BottomNavigationBarItem> items = [];
    for (var i = 0; i < controller.names.length; i++) {
      BottomNavigationBarItem temp = BottomNavigationBarItem(
          icon: Badge(
            label: Text("${controller.unReadMsgs}"),
            //显示到第四个消息 tab 上，同时未读消息为 0 时不显示
            isLabelVisible: (i == 3) && (controller.unReadMsgs.value != 0) ? true : false,
            backgroundColor: Colors.red[500],
            child: controller.currentIndex.value == i ? controller.tabFillIcons[i] : controller.tabLineIcons[i],
          ),
          label: controller.names[i]);
      items.add(temp);
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    // 预加载tab图片
    controller.precacheIcons(context);
    return Obx(() => WillPopScope(
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

            // 自定义Bottom bar item
            // bottomNavigationBar: BottomAppBar(
            //   child: _getCustomItems(),
            // ),

            bottomNavigationBar: BottomNavigationBar(
              backgroundColor: Colors.white,
              fixedColor: SaienteColors.appMain, //选中的颜色
              currentIndex: controller.currentIndex.value, //选中第几个
              type: BottomNavigationBarType.fixed, //大于等于 4 个时
              onTap: (index) {
                controller.setCurrentIndex(index);
                //触发 PageView 的滑动
                controller.pageController.jumpToPage(index);
              },
              items: _getItems(),
            ),
          ),
        ));
  }
}
