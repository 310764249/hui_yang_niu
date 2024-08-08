import 'package:easy_refresh/easy_refresh.dart';
import 'package:extended_tabs/extended_tabs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../../../models/cattle_event.dart';
import '../../../models/common_data.dart';
import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/constant.dart';
import '../../../services/ex_string.dart';
import '../../../services/keepAliveWrapper.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/divider_line.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../breeding_info/controllers/breeding_info_controller.dart';
import '../breeding_info/views/breeding_info_view.dart';
import '../controllers/cattle_detail_controller.dart';
import '../widget/action_item_header.dart';

///
/// 牛只详情
///
class CattleDetailView extends GetView<CattleDetailController> {
  const CattleDetailView({Key? key}) : super(key: key);

  // 标签view: "公牛"/"栋舍"
  Widget _labelView(String labelText) {
    return Container(
      height: ScreenAdapter.height(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.genderType.value == 2
              ? [SaienteColors.redFF3D3D, SaienteColors.redFF7F7F]
              : [SaienteColors.blue2559F3, SaienteColors.blue4D91F5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(8), 0, ScreenAdapter.width(8), 0),
        child: Text(
          labelText,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
      ),
    );
  }

  Widget _keyValueView(String title, String value) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: title,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(13),
              color: SaienteColors.black80)),
      TextSpan(
          text: value,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(13),
              fontWeight: FontWeight.w500,
              color: SaienteColors.blackE5))
    ]));
  }

  // 色块
  Widget _colorItem(String title, String value, {String? unit = ''}) {
    return Container(
      color: controller.genderType.value == 2
          ? SaienteColors.redFFE9E9
          : SaienteColors.blueE5EEFF,
      margin: EdgeInsets.fromLTRB(
          ScreenAdapter.width(4),
          ScreenAdapter.height(4),
          ScreenAdapter.width(4),
          ScreenAdapter.height(4)),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          // 自适应内容Box
          FittedBox(
            child: Text.rich(TextSpan(children: [
              TextSpan(
                  text: value,
                  style: TextStyle(
                      color: controller.genderType.value == 2
                          ? SaienteColors.redFF3D3D
                          : SaienteColors.blue275CF3,
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenAdapter.fontSize(20))),
              TextSpan(
                  text: unit,
                  style: TextStyle(
                      color: controller.genderType.value == 2
                          ? SaienteColors.redFF3D3D
                          : SaienteColors.blue275CF3,
                      fontWeight: FontWeight.w600,
                      fontSize: ScreenAdapter.fontSize(10))),
            ])),
          ),
          Text(
            title,
            style: TextStyle(
                color: SaienteColors.blackB2,
                fontSize: ScreenAdapter.fontSize(13)),
          ),
        ]),
      ),
    );
  }

  Widget _loadingView() {
    return Container(
        color: SaienteColors.backGrey,
        child: Shimmer.fromColors(
            baseColor: const Color(0xFFE0E0E0),
            highlightColor: const Color.fromARGB(255, 184, 185, 227),
            child: Column(
              children: [
                Container(
                  height: 166,
                  margin: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(10),
                      ScreenAdapter.height(10),
                      ScreenAdapter.width(10),
                      ScreenAdapter.height(0)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
                Container(
                  height: 168,
                  margin: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(10),
                      ScreenAdapter.height(10),
                      ScreenAdapter.width(10),
                      ScreenAdapter.height(0)),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.fromLTRB(
                        ScreenAdapter.width(10),
                        ScreenAdapter.height(10),
                        ScreenAdapter.width(10),
                        ScreenAdapter.height(0)),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            )));
  }

  // 牛只信息卡片
  Widget _cattleHeaderCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
          ScreenAdapter.width(10),
          ScreenAdapter.height(0)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: controller.genderType.value == 2
                ? [const Color(0xFFFFDDDD), const Color(0xFFFFFFFF)]
                : [const Color(0xFFD5E3FF), const Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(children: [
        // 牛只图片和编号
        Row(mainAxisSize: MainAxisSize.max, children: [
          // 牛只大图
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(20),
                ScreenAdapter.height(6),
                ScreenAdapter.width(20),
                ScreenAdapter.height(5)),
            child: LoadAssetImage(
              controller.genderType.value == 2
                  ? AssetsImages.cow
                  : AssetsImages.bull,
            ),
          ),
          // 牛只耳号/性别/栋舍等信息
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // 耳号
              Text(controller.cattle.code.orEmpty(),
                  style: TextStyle(
                      color: controller.genderType.value == 2
                          ? SaienteColors.redFF3D3D
                          : SaienteColors.blue275CF3,
                      fontSize: ScreenAdapter.fontSize(20),
                      fontWeight: FontWeight.w800)),
              SizedBox(height: ScreenAdapter.height(5)),
              // 公母/栋舍
              SizedBox(
                height: ScreenAdapter.height(20),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _labelView(AppDictList.findLabelByCode(controller.gmList,
                        controller.cattle.gender.toString())),
                    SizedBox(width: ScreenAdapter.width(2)),
                    _labelView('${controller.cattle.cowHouseName}'),
                  ],
                ),
              )
            ]),
          ),
        ]),
        DividerLine(
            color: const Color(0xFFCCCCCC),
            indent: ScreenAdapter.width(11),
            endIndent: ScreenAdapter.width(11)),
        Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(22),
              ScreenAdapter.height(14),
              ScreenAdapter.width(22),
              ScreenAdapter.height(14)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _keyValueView(
                          '状   态: ',
                          AppDictList.findLabelByCode(controller.szjdList,
                              controller.cattle.growthStage.toString())),
                      SizedBox(height: ScreenAdapter.height(6)),
                      _keyValueView('日   龄: ',
                          '${controller.cattle.ageOfDay.toString()}天'),
                    ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _keyValueView(
                          '品   种: ',
                          AppDictList.findLabelByCode(controller.pzList,
                              controller.cattle.kind.toString())),
                      SizedBox(height: ScreenAdapter.height(6)),
                      _keyValueView(
                          '电子耳号: ',
                          controller.cattle.eleCode.orEmpty().trim().isEmpty
                              ? Constant.placeholder
                              : controller.cattle.eleCode.orEmpty().trim()),
                    ]),
              )
            ],
          ),
        ),
      ]),
    );
  }

  // 牛只色块信息
  Widget _cattleColorCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
          ScreenAdapter.width(10),
          ScreenAdapter.height(0)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Obx(() => GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // 禁止GridView滚动
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 80 / 76),
              itemCount: controller.genderType.value == 2
                  ? controller.cowColorSectionList.length
                  : controller.bullColorSectionList.length,
              itemBuilder: (BuildContext context, int index) {
                return _colorItem(
                  controller.genderType.value == 2
                      ? controller.cowColorSectionList[index].name
                      : controller.bullColorSectionList[index].name,
                  controller.genderType.value == 2
                      ? controller.cowColorSectionList[index].value!
                      : controller.bullColorSectionList[index].value!,
                  unit: controller.genderType.value == 2
                      ? controller.cowColorSectionList[index].unit
                      : controller.bullColorSectionList[index].unit,
                );
              },
            )),
      ),
    );
  }

  // 模块标题文字
  Widget _titleText(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            color: SaienteColors.blackE5,
            fontSize: ScreenAdapter.fontSize(18)));
  }

  // 事件列表item
  Widget _managementItem(CommonData data) {
    return InkWell(
        onTap: () {
          switch (data.name) {
            case '引种':
              Get.toNamed(Routes.BUY_IN, arguments: controller.cattle);
              break;
            case '选种':
              Get.toNamed(Routes.SELECT_CATTLE, arguments: controller.cattle);
              break;
            case '调拨':
              Get.toNamed(Routes.ALLOT_CATTLE, arguments: controller.cattle);
              break;
            case '转群':
              Get.toNamed(Routes.CHANGE_GROUP, arguments: controller.cattle);
              break;
            case '淘汰':
              Get.toNamed(Routes.KNOCK_OUT, arguments: controller.cattle);
              break;
            case '死亡':
              Get.toNamed(Routes.DIE_CATTLE, arguments: controller.cattle);
              break;
            case '销售':
              Get.toNamed(Routes.SELL_CATTLE, arguments: controller.cattle);
              break;
            case '盘点':
              Get.toNamed(Routes.CHECK_CATTLE, arguments: controller.cattle);
              break;
            case '饲喂':
              Get.toNamed(Routes.FEED_CATTLE, arguments: controller.cattle);
              break;
            case '采精':
              Get.toNamed(Routes.SEMEN, arguments: controller.cattle);
              break;
            case '发情':
              Get.toNamed(Routes.RUT, arguments: controller.cattle);
              break;
            case '禁配':
              Get.toNamed(Routes.BAN, arguments: controller.cattle);
              break;
            case '解禁':
              Get.toNamed(Routes.UN_BAN, arguments: controller.cattle);
              break;
            case '配种':
              Get.toNamed(Routes.MATING, arguments: controller.cattle);
              break;
            case '孕检':
              Get.toNamed(Routes.PREGCY, arguments: controller.cattle);
              break;
            case '产犊':
              Get.toNamed(Routes.CALV, arguments: controller.cattle);
              break;
            case '断奶':
              Get.toNamed(Routes.WEAN, arguments: controller.cattle);
              break;
            case '防疫':
              Get.toNamed(Routes.PREVENTION, arguments: controller.cattle);
              break;
            case '诊疗':
              Get.toNamed(Routes.TREATMENT, arguments: controller.cattle);
              break;
            case '保健':
              Get.toNamed(Routes.HEALTH_CARE, arguments: controller.cattle);
              break;
            default:
          }
        },
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            LoadAssetImage(
              data.image ?? AssetsImages.fileManagement,
            ),
            SizedBox(height: ScreenAdapter.height(4)),
            Text(
              data.name,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500,
                  color: SaienteColors.blackB2),
            )
          ]),
        ));
  }

  // 管理类列表布局
  Widget _managementView(String title, List<CommonData> managementList) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _titleText(title),
        SizedBox(height: ScreenAdapter.height(11)),
        Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: EdgeInsets.all(ScreenAdapter.width(6)),
            child: GridView.builder(
              shrinkWrap: true, // 根据内容自动调整高度
              physics: const NeverScrollableScrollPhysics(), // 禁止GridView滚动
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, childAspectRatio: 1 / 1),
              itemCount: managementList.length,
              itemBuilder: (BuildContext context, int index) {
                return _managementItem(managementList[index]);
              },
            ),
          ),
        ),
        // 有的角色可能没有对应的模块, 需要整个模块需要做隐藏, SizedBox也需要同时隐藏
        SizedBox(height: ScreenAdapter.height(16)),
      ],
    );
  }

  // 牛只操作模块
  Widget _cattleActionCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
          ScreenAdapter.width(10),
          ScreenAdapter.height(10)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ListView(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(), // 禁止GridView滚动
            children: [
              SizedBox(height: ScreenAdapter.height(16)),
              // 生产管理
              _managementView(
                  "生产管理",
                  controller.genderType.value == 2
                      ? controller.productionManagementList4Cow
                      : controller.productionManagementList4Bull),
              // 繁殖管理
              controller.genderType.value == 2
                  ? _managementView(
                      "繁殖管理", controller.reproductiveManagementList4Cow)
                  : const SizedBox(),
              // _managementView(
              //     "繁殖管理",
              //     controller.genderType.value == 2
              //         ? controller.reproductiveManagementList4Cow
              //         : controller.reproductiveManagementList4Bull),
              // 育种管理
              // _managementView(
              //     "育种管理",
              //     controller.genderType.value == 2
              //         ? controller.breedingManagementList4Cow
              //         : controller.breedingManagementList4Bull),
              // 健康管理
              // _managementView(
              //     "健康管理",
              //     controller.genderType.value == 2
              //         ? controller.healthManagementList4Cow
              //         : controller.healthManagementList4Bull),
            ]),
      ),
    );
  }

  // 牛只[基本信息]
  Widget _cattleInfo() {
    return Obx(() => controller.isLoading.value
        ? _loadingView()
        : Container(
            color: SaienteColors.backGrey,
            child: ListView(
              // physics: const AlwaysScrollableScrollPhysics(
              //     parent: BouncingScrollPhysics()),
              children: [
                // 牛只信息卡片
                _cattleHeaderCard(),
                // 牛只色块信息
                _cattleColorCard(),
                // 牛只操作模块
                _cattleActionCard(),
              ],
            ),
          ));
  }

  // 生产记录列表Item
  Widget _eventItem(CattleEvent event, int position, int totalLength) {
    return Container(
      color: SaienteColors.backGrey,
      padding: EdgeInsets.only(
          top: ScreenAdapter.height(5), bottom: ScreenAdapter.height(5)),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          ActionItemHeader(
            canvasSize: 50,
            circleSize: 10,
            circleColor: controller.genderType.value == 2
                ? SaienteColors.redFF3D3D
                : SaienteColors.blue275CF3,
            lineColor: controller.genderType.value == 2
                ? const Color(0xFFFFCCDD)
                : const Color(0x80275CF3),
            lineWidth: 10,
            dashWidth: 10,
            dashSpace: 10,
            isStart: position == 0,
            isLast: position == totalLength - 1,
          ),
          SizedBox(width: ScreenAdapter.width(10)),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(6)),
              child: Row(mainAxisSize: MainAxisSize.max, children: [
                // 日期
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      event.date.substring(0, event.date.indexOf('-')),
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(10),
                          fontWeight: FontWeight.w500,
                          color: controller.genderType.value == 2
                              ? SaienteColors.redFF3D3D
                              : SaienteColors.blue275CF3),
                    ),
                    Text(
                      event.date.substring(event.date.indexOf('-') + 1),
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(12),
                          fontWeight: FontWeight.w500,
                          color: controller.genderType.value == 2
                              ? SaienteColors.redFF3D3D
                              : SaienteColors.blue275CF3),
                    )
                  ],
                ),
                SizedBox(width: ScreenAdapter.width(10)),
                // 分割线
                Container(
                    height: ScreenAdapter.height(28),
                    width: ScreenAdapter.width(0.5),
                    decoration: const BoxDecoration(
                      color: Color(0xFFD8D8D8),
                    )),
                SizedBox(width: ScreenAdapter.width(10)),
                // 生成内容
                Expanded(
                  child: Text(
                    // 根据type匹配出对应的事件名称
                    AppDictList.findLabelByCode(
                        controller.czztList, event.type.toString()),
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.blackE5),
                  ),
                )
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _eventList() {
    return Obx(() => controller.items.isEmpty
        ? const EmptyView()
        : Container(
            color: SaienteColors.backGrey,
            padding: EdgeInsets.all(ScreenAdapter.width(10)),
            child: EasyRefresh(
              controller: controller.refreshController,
              // 指定刷新时的头部组件
              header: CustomRefresh.refreshHeader(),
              // 指定加载时的底部组件
              footer: CustomRefresh.refreshFooter(),
              onRefresh: () async {
                // 获取时间列表
                await controller.getCattleEventListData();
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
                await controller.getCattleEventListData(isRefresh: false);
                // 设置状态
                controller.refreshController.finishLoad(controller.hasMore
                    ? IndicatorResult.success
                    : IndicatorResult.noMore);
              },
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: controller.items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Material(
                    child: InkWell(
                      onTap: () {
                        // 生产事件list点击事件
                        redirectToDetailPages(controller.items[index].type,
                            controller.items[index]);
                      },
                      child: _eventItem(controller.items[index], index,
                          controller.items.length),
                    ),
                  );
                },
              ),
            ),
          ));
  }

  // 点击跳转各个详情页面
  void redirectToDetailPages(int type, CattleEvent event) {
    switch (type) {
      case 1: // 引种
        // Get.toNamed(Routes.BUY_IN_DETAIL, arguments: event);
        break;
      case 2: // 选种
        Get.toNamed(Routes.SELECT_CATTLE_DETAIL, arguments: event);
        break;
      case 3: // 调拨
        Get.toNamed(Routes.ALLOT_CATTLE_DETAIL, arguments: event);
        break;
      case 4: // 转群
        Get.toNamed(Routes.CHANGE_GROUP_DETAIL, arguments: event);
        break;
      case 5: // 发情
        Get.toNamed(Routes.RUT_DETAIL, arguments: event);
        break;
      case 6: // 采精
        Get.toNamed(Routes.SEMEN_DETAIL, arguments: event);
        break;
      case 7: // 配种
        Get.toNamed(Routes.MATING_DETAIL, arguments: event);
        break;
      case 8: // 禁配
        Get.toNamed(Routes.BAN_DETAIL, arguments: event);
        break;
      case 9: // 解禁
        Get.toNamed(Routes.UN_BAN_DETAIL, arguments: event);
        break;
      case 10: // 孕检
        Get.toNamed(Routes.PREGCY_DETAIL, arguments: event);
        break;
      case 11: // 产犊
        Get.toNamed(Routes.CALV_DETAIL, arguments: event);
        break;
      case 12: // 断奶
        Get.toNamed(Routes.WEAN_DETAIL, arguments: event);
        break;
      case 13: // 淘汰
        Get.toNamed(Routes.KNOCK_OUT_DETAIL, arguments: event);
        break;
      case 14: // 销售
        Get.toNamed(Routes.SELL_CATTLE_DETAIL, arguments: event);
        break;
      case 15: // 死亡
        Get.toNamed(Routes.DIE_CATTLE_DETAIL, arguments: event);
        break;
      case 16: // 盘点
        Get.toNamed(Routes.CHECK_CATTLE_DETAIL, arguments: event);
        break;
      case 17: // 饲喂
        Get.toNamed(Routes.FEED_CATTLE_DETAIL, arguments: event);
        break;
      case 18: // 空怀 不跳转
        // Get.toNamed(Routes.CATTLE_TRANSFER, arguments: event);
        break;
      case 19: // 防疫
        Get.toNamed(Routes.PREVENTION_DETAIL, arguments: event);
        break;
      case 20: // 保健
        Get.toNamed(Routes.HEALTH_CARE_DETAIL, arguments: event);
        break;
      case 21: // 诊疗
        Get.toNamed(Routes.TREATMENT_DETAIL, arguments: event);
        break;
      case 22: // 后裔登记
        Get.toNamed(Routes.DESCENDANTS_DETAIL, arguments: event);
        break;
      case 23: // 选育测定
        Get.toNamed(Routes.ASSAY_DETAIL, arguments: event);
        break;
      default:
        // Get.toNamed(Routes.CATTLE_INFO, arguments: event);
        break;
    }
  }

  Widget _content() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.zero,
            child: Obx(() => Container(
                  color: Colors.white,
                  child: ExtendedTabBar(
                    enableFeedback: true,
                    onTap: (value) {
                      controller.updatePageIndex(value);
                    },
                    tabs: List<Widget>.generate(
                        3,
                        (int index) => Tab(
                                child: Text(
                              controller.tabTitles[index],
                              style: TextStyle(
                                  // Loading时设置上面导航的文字和bar为灰色
                                  color: controller.isLoading.value
                                      ? const Color.fromARGB(255, 208, 204, 204)
                                      : controller.currentIndex.value == index
                                          ? controller.genderType.value == 2
                                              ? SaienteColors.redFF3D3D
                                              : SaienteColors.blue275CF3
                                          : SaienteColors.black1C2023,
                                  fontSize: ScreenAdapter.fontSize(16),
                                  fontWeight: FontWeight.w600),
                            ))).toList(),
                    labelPadding: const EdgeInsets.symmetric(horizontal: 30),
                    indicatorSize: TabBarIndicatorSize.label,
                    mainAxisAlignment: MainAxisAlignment.center,
                    indicator: ExtendedUnderlineTabIndicator(
                        strokeCap: StrokeCap.round,
                        borderSide: BorderSide(
                          // Loading时设置上面导航的文字和bar为灰色
                          color: controller.isLoading.value
                              ? const Color.fromARGB(255, 208, 204, 204)
                              : controller.genderType.value == 2
                                  ? SaienteColors.redFF3D3D
                                  : SaienteColors.blue275CF3,
                          width: 4,
                          style: BorderStyle.solid,
                        )),
                  ),
                )),
          ),
          Expanded(
            child: ExtendedTabBarView(
              physics: const NeverScrollableScrollPhysics(), // 禁止横向滚动
              // controller: TabController(),
              scrollDirection: Axis.horizontal,
              cacheExtent: 1, // 缓存一个页面数据, 避免每次切换tab都去请求api
              children: [
                // 基本信息
                _cattleInfo(),
                // 生产记录
                _eventList(),
                // 生产记录
                const BreedingInfoView(),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    //引入育种详情信息页面
    BreedingInfoController vc = BreedingInfoController();
    vc.cattle = controller.cattle;
    Get.put(vc);
    //
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            '牛只档案',
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            TextButton(
                onPressed: () {
                  // 如果是在Loading, 则不跳转
                  if (controller.isLoading.value) {
                    return;
                  }
                  //跳转编辑页面
                  Get.toNamed(Routes.CATTLE_EDIT, arguments: controller.cattle)
                      ?.then((value) {
                    if (value != null && value == 1) {
                      //执行跳转  回到上级页面，1 表示更新成功，需要继续返回
                      Get.back(result: value);
                    }
                  });
                },
                child: Text(
                  "编辑",
                  style: TextStyle(
                      color: SaienteColors.blue275CF3,
                      fontSize: ScreenAdapter.fontSize(16)),
                ))
          ],
        ),
        body: KeepAliveWrapper(
          child: _content(),
        ));
  }
}
