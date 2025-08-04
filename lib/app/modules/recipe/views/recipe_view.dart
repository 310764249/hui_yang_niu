import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../models/formula.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../controllers/recipe_controller.dart';

///
/// 配方
///
class RecipeView extends GetView<RecipeController> {
  //手动绑定 MineController 注意移除 binding 中的懒加载
  @override
  final RecipeController controller = Get.put(RecipeController());

  RecipeView({super.key});

  // 4个按钮的item
  Widget _headerItem(String icon, String title, Function() onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            LoadImage(icon),
            SizedBox(height: ScreenAdapter.height(10)),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: ScreenAdapter.fontSize(13),
                color: SaienteColors.blackE5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerView() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        ScreenAdapter.width(0),
        ScreenAdapter.height(10),
        ScreenAdapter.width(0),
        ScreenAdapter.height(10),
      ),
      margin: EdgeInsets.fromLTRB(
        ScreenAdapter.width(10),
        ScreenAdapter.height(10),
        ScreenAdapter.width(10),
        ScreenAdapter.height(10),
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _headerItem(AssetsImages.rawMaterial, '原料库', () {
            Toast.show('原料库');
          }),
          _headerItem(AssetsImages.standardLib, '标准库', () {
            Toast.show('标准库');
          }),
          _headerItem(AssetsImages.mineral, '矿物质', () {
            Toast.show('矿物质');
          }),
          _headerItem(AssetsImages.recipeManagement, '配方管理', () {
            Toast.show('配方管理');
          }),
        ],
      ),
    );
  }

  // 创建配方按钮
  Widget _createRecipeButton() {
    return Container(
      width: ScreenAdapter.width(335),
      height: ScreenAdapter.height(45),
      margin: EdgeInsets.only(left: ScreenAdapter.width(20), right: ScreenAdapter.width(20)),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(SaienteColors.appMain),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenAdapter.width(100))),
          ),
        ),
        onPressed: () {
          Get.toNamed(Routes.RECIPE_CREATE);
        },
        child: Text(
          '创建配方',
          style: TextStyle(fontSize: ScreenAdapter.fontSize(17), fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  // 配方列表item
  Widget _recipeListItem(FormulaModel model) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.RECIPE_DETAIL, arguments: model);
      },
      child: Container(
        margin: EdgeInsets.only(top: ScreenAdapter.height(10)),
        padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
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
                    borderRadius: BorderRadius.circular(ScreenAdapter.width(1.5)),
                  ),
                ),
                SizedBox(width: ScreenAdapter.width(5)),
                Text(
                  model.name ?? Constant.placeholder,
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: ScreenAdapter.height(14)),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        AppDictList.findLabelByCode(
                          controller.pfmbList,
                          model.individualType.toString(),
                        ),
                        maxLines: 1,
                        style: TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: SaienteColors.blackE5,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenAdapter.fontSize(16),
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(3)),
                      Text(
                        '配方目标',
                        style: TextStyle(
                          color: SaienteColors.black80,
                          fontSize: ScreenAdapter.fontSize(13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: SaienteColors.separateLine,
                  width: ScreenAdapter.width(1),
                  height: ScreenAdapter.height(36),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        model.date ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: SaienteColors.blackE5,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenAdapter.fontSize(16),
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(3)),
                      Text(
                        '制作日期',
                        style: TextStyle(
                          color: SaienteColors.black80,
                          fontSize: ScreenAdapter.fontSize(13),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  color: SaienteColors.separateLine,
                  width: ScreenAdapter.width(1),
                  height: ScreenAdapter.height(36),
                ),
                Expanded(
                  child: Column(
                    children: [
                      Text(
                        model.executor ?? Constant.placeholder,
                        style: TextStyle(
                          color: SaienteColors.blackE5,
                          fontWeight: FontWeight.w500,
                          fontSize: ScreenAdapter.fontSize(16),
                        ),
                      ),
                      SizedBox(height: ScreenAdapter.height(3)),
                      Text(
                        '制作人',
                        style: TextStyle(
                          color: SaienteColors.black80,
                          fontSize: ScreenAdapter.fontSize(13),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 我的配方列表
  Widget _recipeList() {
    return Obx(
      () => Expanded(
        child: Container(
          padding: EdgeInsets.only(left: ScreenAdapter.width(10), right: ScreenAdapter.width(10)),
          child: EasyRefresh(
            controller: controller.refreshController,
            // 指定刷新时的头部组件
            header: CustomRefresh.refreshHeader(),
            // 指定加载时的底部组件
            footer: CustomRefresh.refreshFooter(),
            onRefresh: () async {
              //
              await controller.searchFormula();
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
              await controller.searchFormula(isRefresh: false);
              // 设置状态
              controller.refreshController.finishLoad(
                controller.hasMore ? IndicatorResult.success : IndicatorResult.noMore,
              );
            },
            child:
                controller.items.isEmpty
                    ? const EmptyView()
                    : ListView.builder(
                      itemCount: controller.items.length,
                      itemBuilder: (BuildContext context, int index) {
                        FormulaModel model = controller.items[index];
                        return _recipeListItem(model);
                      },
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildView() {
    return Container(
      color: SaienteColors.backGrey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 4个按钮
          //_headerView(),
          //SizedBox(height: ScreenAdapter.height(6)),
          SizedBox(height: ScreenAdapter.height(20)),
          // 创建配方按钮
          _createRecipeButton(),
          SizedBox(height: ScreenAdapter.height(20)),
          //
          Text(
            '  我的配方',
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: ScreenAdapter.fontSize(20),
              color: SaienteColors.blackE5,
              fontWeight: FontWeight.w500,
            ),
          ),
          // 我的配方列表
          _recipeList(),
          SizedBox(height: ScreenAdapter.height(5)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '配方',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<RecipeController>(
        //obx的第三种写法,为了initState方法
        init: controller,
        initState: (state) {
          debugPrint("initState 每次进入【配方】页面时触发");
          // 根据权限刷新UI
          controller.searchFormula();
        },
        builder: (controller) {
          return _buildView();
        },
      ),
    );
  }
}
