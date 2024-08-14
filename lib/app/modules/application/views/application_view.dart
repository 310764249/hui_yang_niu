import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intellectual_breed/app/modules/event_list/controllers/event_list_controller.dart';

import '../../../models/cattle_list_argu.dart';
import '../../../models/common_data.dart';
import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/application_controller.dart';

class ApplicationView extends GetView<ApplicationController> {
  //手动绑定 MineController 注意移除 binding 中的懒加载
  @override
  final ApplicationController controller = Get.put(ApplicationController());

  ApplicationView({Key? key}) : super(key: key);

  // 模块标题文字
  Widget _titleText(String text) {
    return Text(text,
        textAlign: TextAlign.start,
        style: TextStyle(fontWeight: FontWeight.w500, color: SaienteColors.blackE5, fontSize: ScreenAdapter.fontSize(18)));
  }

  // 统计列表item 任务统计 + 牛只存栏统计
  Widget _statisticsItem(CommonData data, int index, {bool show78Border = false}) {
    return InkWell(
        onTap: () {
          String name = data.name.replaceAll("\n", "");
          switch (name) {
            case '待查情数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(1, '待查情', Routes.RUT));
              break;
            case '待配种数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(2, '待配种', Routes.MATING));
              break;
            case '待孕检数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(3, '待孕检', Routes.PREGCY));
              break;
            case '待产犊数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(4, '待产犊', Routes.CALV));
              break;
            case '待断奶数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(5, '待断奶', Routes.WEAN));
              break;
            case '待淘汰数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(6, '待淘汰', Routes.KNOCK_OUT));
              break;
            case '待出栏数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(7, '待出栏', Routes.SELL_CATTLE));
              break;
            case '待防疫数':
              Get.toNamed(Routes.EVENT_CATTLE_LIST, arguments: EventsCattleListArgument(9, '待防疫', Routes.PREVENTION));
              break;
            default:
          }
        },
        child: Container(
          // 根据不同的index设置item不同位置的边线
          decoration: BoxDecoration(
              border: switch (index) {
            0 || 1 || 2 => const Border(
                right: BorderSide(color: SaienteColors.black40, width: 0.5),
                bottom: BorderSide(color: SaienteColors.black40, width: 0.5)),
            3 => const Border(bottom: BorderSide(color: SaienteColors.black40, width: 0.5)),
            4 || 5 => Border(
                bottom: show78Border
                    ? const BorderSide(color: SaienteColors.black40, width: 0.5)
                    : const BorderSide(color: Colors.transparent, width: 0.5),
                right: const BorderSide(color: SaienteColors.black40, width: 0.5)),
            6 => Border(
                right: const BorderSide(color: SaienteColors.black40, width: 0.5),
                bottom: show78Border
                    ? const BorderSide(color: SaienteColors.black40, width: 0.5)
                    : const BorderSide(color: Colors.transparent, width: 0.5)),
            7 => Border(
                bottom: show78Border
                    ? const BorderSide(color: SaienteColors.black40, width: 0.5)
                    : const BorderSide(color: Colors.transparent, width: 0.5)),
            8 || 9 => const Border(right: BorderSide(color: SaienteColors.black40, width: 0.5)),
            _ => null
          }),
          child: Center(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text(
                data.value ?? '',
                style:
                    TextStyle(fontSize: ScreenAdapter.fontSize(20), fontWeight: FontWeight.bold, color: SaienteColors.blue275CF3),
              ),
              SizedBox(height: ScreenAdapter.height(4)),
              Text(
                data.name,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: ScreenAdapter.fontSize(13), fontWeight: FontWeight.w400, color: SaienteColors.blackB2),
              )
            ]),
          ),
        ));
  }

  // 统计列表
  Widget _statisticsView(String title, List<CommonData> managementList, bool show78Border) {
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
            padding: EdgeInsets.all(ScreenAdapter.width(15)),
            child: GridView.builder(
              shrinkWrap: true,
              // 根据内容自动调整高度
              physics: const NeverScrollableScrollPhysics(),
              // 禁止GridView滚动
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1 / 1),
              itemCount: managementList.length,
              itemBuilder: (BuildContext context, int index) {
                return _statisticsItem(managementList[index], index, show78Border: show78Border);
              },
            ),
          ),
        ),
      ],
    );
  }

  // 个体管理
  Widget _individualManagement1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _titleText("个体管理"),
        SizedBox(height: ScreenAdapter.height(11)),
        // 按钮图片
        Row(children: [
          Expanded(
              child: InkWell(
            onTap: () {
              // Get.snackbar("提示", "--> 档案管理");
              Get.toNamed(
                Routes.NEW_CATTLE,
              );
            },
            child: const LoadAssetImage(
              AssetsImages.fileManagement,
              fit: BoxFit.fitWidth,
            ),
          )),
          SizedBox(width: ScreenAdapter.width(6)),
          Expanded(
              child: InkWell(
            onTap: () {
              // Get.snackbar("提示", "--> 牛只管理");
              Get.toNamed(Routes.CATTLELIST,
                  arguments: CattleListArgument(goBack: false, single: false, szjdList: controller.szjdListFiltered));
            },
            child: const LoadAssetImage(
              AssetsImages.cattleList,
              fit: BoxFit.fitWidth,
            ),
          )),
        ])
      ],
    );
  }

  // 个体管理
  Widget _individualManagement() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        _titleText("档案管理"),
        SizedBox(height: ScreenAdapter.height(11)),
        // 按钮图片
        Row(children: [
          Expanded(
              child: Bounceable(
            onTap: () {
              Get.toNamed(
                Routes.NEW_CATTLE,
              );
            },
            child: Container(
              height: ScreenAdapter.height(60),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  //渐变色背景
                  gradient: LinearGradient(
                    colors: [Color(0xFF0066EA), Color(0xFF19A1FB)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: Text(
                "档案新增",
                style: TextStyle(fontSize: ScreenAdapter.fontSize(16), fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )),
          SizedBox(width: ScreenAdapter.width(6)),
          Expanded(
              child: Bounceable(
            onTap: () {
              Get.toNamed(Routes.CATTLELIST,
                  arguments: CattleListArgument(goBack: false, single: false, szjdList: controller.szjdListFiltered));
            },
            child: Container(
              height: ScreenAdapter.height(60),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  //渐变色背景
                  gradient: LinearGradient(
                    colors: [Color(0xFFFF742D), Color(0xFFF1A22B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )),
              child: Text(
                "牛只列表",
                style: TextStyle(fontSize: ScreenAdapter.fontSize(16), fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )),
          SizedBox(width: ScreenAdapter.width(6)),
          Expanded(
              child: Bounceable(
            onTap: () {
              Get.toNamed(Routes.BATCH_LIST,
                  arguments: BatchListArgument(
                    goBack: false,
                  ));
            },
            child: Container(
              height: ScreenAdapter.height(60),
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                  //渐变色背景
                  gradient: LinearGradient(
                    colors: [Color(0xFF35CF9A), Color(0xFF38DF9F)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )),
              child: Text(
                "批次列表",
                style: TextStyle(fontSize: ScreenAdapter.fontSize(16), fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          )),
        ])
      ],
    );
  }

  // 事件列表item
  Widget _managementItem(CommonData data) {
    return Bounceable(
        onTap: () {
          print("--> ${data.name.replaceAll("\n", "")}  data：${data.id}");
          // Get.snackbar("提示", "--> ${data.name.replaceAll("\n", "")}",
          //     snackPosition: SnackPosition.BOTTOM);
          switch (data.name) {
            case '引种':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/restock', '引种事件', Routes.BUY_IN, detailRouterStr: Routes.BUY_IN_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '选种':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/selstock', '选种事件', Routes.SELECT_CATTLE,
                          detailRouterStr: Routes.SELECT_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '调拨':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments:
                          EventsArgument('/api/Allot', '调拨事件', Routes.ALLOT_CATTLE, detailRouterStr: Routes.ALLOT_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '转群':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/TurnGroup', '转群事件', Routes.CHANGE_GROUP,
                          detailRouterStr: Routes.CHANGE_GROUP_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '淘汰':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments:
                          EventsArgument('/api/WeedOut', '淘汰事件', Routes.KNOCK_OUT, detailRouterStr: Routes.KNOCK_OUT_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '死亡':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments:
                          EventsArgument('/api/Death', '死亡事件', Routes.DIE_CATTLE, detailRouterStr: Routes.DIE_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '销售':
              if (data.id == 2) {
                //效益评估出栏
                Get.toNamed(Routes.EVENT_LIST,
                    arguments:
                        EventsArgument('/api/sales', '销售', Routes.SALES_ASSESS, detailRouterStr: Routes.SALES_ASSESS_DETAIL));
              }
              break;
            case '出栏':
              //生产管理的出栏
              Get.toNamed(Routes.EVENT_LIST,
                      arguments:
                          EventsArgument('/api/Market', '出栏', Routes.SELL_CATTLE, detailRouterStr: Routes.SELL_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });

            case '盘点':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/CowCheck', '盘点事件', Routes.CHECK_CATTLE,
                          detailRouterStr: Routes.CHECK_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '饲喂':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments:
                          EventsArgument('/api/Feed', '饲喂事件', Routes.FEED_CATTLE, detailRouterStr: Routes.FEED_CATTLE_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '采精':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Semen', '采精事件', Routes.SEMEN, detailRouterStr: Routes.SEMEN_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '发情':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Rut', '发情事件', Routes.RUT, detailRouterStr: Routes.RUT_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '禁配':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Ban', '禁配事件', Routes.BAN, detailRouterStr: Routes.BAN_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '解禁':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument(
                    '/api/Pick',
                    '解禁事件',
                    Routes.UN_BAN,
                    detailRouterStr: Routes.UN_BAN_DETAIL,
                  ))?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '配种':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Mating', '配种事件', Routes.MATING, detailRouterStr: Routes.MATING_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '孕检':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Pregcy', '孕检事件', Routes.PREGCY, detailRouterStr: Routes.PREGCY_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '产犊':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/calv', '产犊事件', Routes.CALV, detailRouterStr: Routes.CALV_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '断奶':
              Get.toNamed(Routes.EVENT_LIST,
                      arguments: EventsArgument('/api/Wean', '断奶事件', Routes.WEAN, detailRouterStr: Routes.WEAN_DETAIL))
                  ?.then((value) {
                controller.requestBasicStatistics();
              });
              break;
            case '防疫':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments:
                      EventsArgument('/api/Antidemic', '防疫事件', Routes.PREVENTION, detailRouterStr: Routes.PREVENTION_DETAIL));
              break;
            case '诊疗':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments:
                      EventsArgument('/api/Treatment', '诊疗事件', Routes.TREATMENT, detailRouterStr: Routes.TREATMENT_DETAIL));
              break;
            case '保健':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments:
                      EventsArgument('/api/HealthCare', '保健事件', Routes.HEALTH_CARE, detailRouterStr: Routes.HEALTH_CARE_DETAIL));
              break;
            //育种管理
            case '后裔登记':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments:
                      EventsArgument('/api/progeny', '后裔登记事件', Routes.DESCENDANTS, detailRouterStr: Routes.DESCENDANTS_DETAIL));
              break;
            case '选育测定':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/breedmeasure', '选育测定事件', Routes.ASSAY, detailRouterStr: Routes.ASSAY_DETAIL));
              break;
            case '近交测定':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/inbreedmeasure', '近交测定事件', Routes.INBREEDING,
                      detailRouterStr: Routes.INBREEDING_DETAILS));
              break;
            case '体尺测定':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/bodymeasure', '体尺测定事件', Routes.MEASUREMENT,
                      detailRouterStr: Routes.MEASUREMENT_DETAIL));
              break;
            case '品相评估':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/surfacemeasure', '品相评估事件', Routes.ASSESSMENT,
                      detailRouterStr: Routes.ASSESSMENT_DETAIL));
              break;
            case '性状统计':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/characterstats', '性状统计事件', Routes.CHARACTERS,
                      detailRouterStr: Routes.CHARACTERS_DETAIL));
              break;
            case '育种值统计':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/breedvaluestats', '育种值统计事件', Routes.BREED_VALUE,
                      detailRouterStr: Routes.BREED_VALUE_DETAIL));
              break;

            case '体况评估':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments:
                      EventsArgument('/api/bodyAssess', '体况评估', Routes.BODY_ASSESS, detailRouterStr: Routes.BODY_ASSESS_DETAIL));
              break;
            case '健康评估':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/healthAssess', '健康评估', Routes.HEALTH_ASSESS,
                      detailRouterStr: Routes.HEALTH_ASSESS_DETAIL));
              break;
            case '环境评估':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/environmentAssess', '环境评估', Routes.ENVIRONMENT_ASSESS,
                      detailRouterStr: Routes.ENVIRONMENT_ASSESS_DETAIL));
              break;
            case '繁殖效率评估':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/breedAssess', '繁殖效率评估', Routes.BREED_ASSESS,
                      detailRouterStr: Routes.BREED_ASSESS_DETAIL));
              break;
            case '采购':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/purchase', '采购', Routes.PURCHASE_ASSESS,
                      detailRouterStr: Routes.PURCHASE_ASSESS_DETAIL));
              break;
            case '人工':
              Get.toNamed(Routes.EVENT_LIST,
                  arguments: EventsArgument('/api/manualWork', '人工', Routes.MANUAL_ASSESS,
                      detailRouterStr: Routes.MANUAL_ASSESS_DETAIL));
              break;
            case '入库':
              Get.toNamed(Routes.Warehouse_Entry);
              break;
            case '领用':
              Get.toNamed(Routes.Collect);
              break;
            case '报废':
              Get.toNamed(Routes.MaterialScrap);
              break;
            case '盘存':
              Get.toNamed(Routes.TakeInventory);
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
              style: TextStyle(fontSize: ScreenAdapter.fontSize(13), fontWeight: FontWeight.w500, color: SaienteColors.blackB2),
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
              shrinkWrap: true,
              // 根据内容自动调整高度
              physics: const NeverScrollableScrollPhysics(),
              // 禁止GridView滚动
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4, childAspectRatio: 1 / 1),
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

  // Page view
  Widget _buildView() {
    return Container(
      color: SaienteColors.whiteF8F9FD,
      child: Padding(
        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
        child: Obx(() => ListView(physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()), children: [
              SizedBox(height: ScreenAdapter.height(16)),
              // 牛只存栏统计
              _statisticsView('牛只存栏统计', controller.cattleInventoryStatisticsList, false),
              SizedBox(height: ScreenAdapter.height(16)),
              // 任务统计
              _statisticsView('任务统计', controller.taskStatisticsList, true),
              SizedBox(height: ScreenAdapter.height(16)),
              // 个体管理
              _individualManagement(),
              SizedBox(height: ScreenAdapter.height(16)),
              // 生产管理
              controller.productionManagementList.isNotEmpty
                  ? _managementView("生产管理", controller.productionManagementList)
                  : const SizedBox(),
              // 繁殖管理
              controller.reproductiveManagementList.isNotEmpty
                  ? _managementView("繁殖管理", controller.reproductiveManagementList)
                  : const SizedBox(),
              // 育种管理
              controller.breedingManagementList.isNotEmpty
                  ? _managementView("育种管理", controller.breedingManagementList)
                  : const SizedBox(),
              // 健康管理
              controller.healthManagementList.isNotEmpty
                  ? _managementView("健康管理", controller.healthManagementList)
                  : const SizedBox(),
              // 物资管理
              controller.materialManagementList.isNotEmpty
                  ? _managementView("物资管理", controller.materialManagementList)
                  : const SizedBox(),
              // 养殖评估
              controller.breedingAssessmentList.isNotEmpty
                  ? _managementView("养殖评估", controller.breedingAssessmentList)
                  : const SizedBox(),
              // 效益评估
              controller.benefitAssessmentList.isNotEmpty
                  ? _managementView("收支管理", controller.benefitAssessmentList)
                  : const SizedBox(),
            ])),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '服务',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<ApplicationController>(
          //obx的第三种写法,为了initState方法
          init: controller,
          initState: (state) {
            debugPrint("initState 每次进入【服务】页面时触发");
            // 根据权限刷新UI
            controller.updateUIByPermission();
            //实时获取数据
            controller.requestBasicStatistics();
            //
            controller.updateSzjdListFiltered();
          },
          builder: (controller) {
            return _buildView();
          }),
    );
  }
}
