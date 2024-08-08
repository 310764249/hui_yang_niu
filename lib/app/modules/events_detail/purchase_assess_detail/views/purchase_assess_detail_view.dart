import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
import '../controllers/purchase_assess_detail_controller.dart';

class PurchaseAssessDetailView extends GetView<PurchaseAssessDetailController> {
  const PurchaseAssessDetailView({Key? key}) : super(key: key);


  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      CellButtonDetail(
        isRequired: true,
        title: '采购单号',
        hint: controller.event!.no ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '采购时间',
        hint: controller.event!.date,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '采购类型',
        hint: AppDictList.findLabelByCode(controller.purchaseAssessList,
            controller.event!.type.toString()),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '名称',
        hint: controller.event!.name.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '厂家',
        hint: controller.event!.manufacturers,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '单价(元)',
        hint: controller.event!.price.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '总价(元)',
        hint: controller.event!.amount.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '折损(元)',
        hint: controller.event!.breakage.toString(),
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
          title: const Text('采购评估详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => PageWrapper(
              child: controller.isLoading.value
                  ? const EmptyView()
                  : ListView(children: [
                    const SizedBox(),
                      //操作信息
                      _operationInfo(context),
                    ]),
            )));
  }
}
