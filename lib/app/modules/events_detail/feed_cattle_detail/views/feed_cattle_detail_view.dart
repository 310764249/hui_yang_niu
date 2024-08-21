import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';

import '../controllers/feed_cattle_detail_controller.dart';
import '../../../../widgets/cell_button_detail.dart';
import '../../../../widgets/empty_view.dart';
import '../../../../services/AssetsImages.dart';
import '../../../../services/colors.dart';
import '../../../../services/constant.dart';
import '../../../../services/load_image.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_text_area_detail.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/divider_line.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../services/ex_string.dart';

class FeedCattleDetailView extends GetView<FeedCattleDetailController> {
  const FeedCattleDetailView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "事件信息"),
      CellButtonDetail(
        isRequired: true,
        title: '栋舍',
        hint: controller.event!.cowHouseName,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '栋舍牛只数量',
        hint: controller.event!.count.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '选择配方',
        hint: controller.feedsTypeName,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '校正饲喂量',
        hint: controller.dosage,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '饲喂时间',
        hint: controller.event!.date.length > 10 ? controller.event!.date.substring(0, 10) : controller.event!.date,
      ),
      CellButtonDetail(
        isRequired: false,
        title: '操作人',
        hint: controller.event!.executor,
      ),
      CellTextAreaDetail(
        isRequired: false,
        title: '备注',
        content: controller.event!.remark ?? Constant.placeholder,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('饲喂事件详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => PageWrapper(
              child: controller.isLoading.value
                  ? const EmptyView()
                  : ListView(children: [
                      //操作信息
                      _operationInfo(context),
                      //计算饲喂量
                      ObxValue<RxList<FormulaItemModel>>(
                        (value) {
                          if (value.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          return MyCard(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                                child: Text(
                                  '${controller.event?.cowHouseName ?? ''}（头数：${controller.event?.count ?? ''}）',
                                  style: TextStyle(
                                    color: SaienteColors.blackE5,
                                    fontSize: ScreenAdapter.fontSize(16),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              for (var item in value)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${item.name ?? ''}：',
                                        style: TextStyle(
                                          color: SaienteColors.blackE5,
                                          fontSize: ScreenAdapter.fontSize(14),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Text(
                                        '${((item.weight ?? 0) * num.parse('${controller.event?.count ?? '0'}') * num.parse('${controller.event?.dosage ?? '1'}')).toStringAsFixed(2)}kg = '
                                        '${(item.weight ?? 0)}kg * '
                                        '${controller.event?.count ?? '0'}头 * '
                                        '${controller.event?.dosage ?? '1'}',
                                        style: TextStyle(
                                          color: SaienteColors.black333333,
                                          fontSize: ScreenAdapter.fontSize(14),
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          );
                        },
                        controller.modelList,
                      ),
                    ]),
            )));
  }
}
