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
import '../controllers/manual_assess_detail_controller.dart';

class ManualAssessDetailView extends GetView<ManualAssessDetailController> {
  const ManualAssessDetailView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    if(controller.event == null){
      return Container();
    }
    return MyCard(children: [
      CellButtonDetail(
        isRequired: true,
        title: '人工单号',
        hint: controller.event!.no ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '录入日期',
        hint: controller.event!.date,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '人工类型',
        hint: AppDictList.findLabelByCode(
            controller.manualAssessList, controller.event!.type.toString()),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '费用',
        hint: controller.event!.amount.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '员工',
        hint: controller.event!.employee.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '岗位',
        hint: controller.event!.post.toString(),
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
          title: const Text('人工评估详情'),
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
