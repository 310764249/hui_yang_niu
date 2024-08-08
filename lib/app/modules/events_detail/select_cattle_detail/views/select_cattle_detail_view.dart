import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/select_cattle_detail_controller.dart';
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

class SelectCattleDetailView extends GetView<SelectCattleDetailController> {
  const SelectCattleDetailView({Key? key}) : super(key: key);
  
    @override
  Widget build(BuildContext context) {
    Widget _operationInfo(context) {
      return MyCard(children: [
        const CardTitle(title: "事件信息"),
        CellButtonDetail(
          isRequired: true,
          title: '批次号',
          hint: controller.event!.batchNo,
        ),
        CellButtonDetail(
          isRequired: true,
          title: '耳号',
          hint: controller.event!.cowCode,
        ),
        CellButtonDetail(
          isRequired: true,
          title: '出生时间',
          hint: controller.event!.birth,
        ),
        CellButtonDetail(
          isRequired: true,
          title: '类型',
          hint: controller.event!.gender == 1 ? '后备公牛' : '后备母牛',
        ),
        CellButtonDetail(
          isRequired: true,
          title: '品种',
          hint: AppDictList.findLabelByCode(
              controller.pzList, controller.event!.kind.toString()),
        ),
        CellButtonDetail(
          isRequired: true,
          title: '转入栋舍',
          hint: controller.event!.inCowHouseName ?? Constant.placeholder,
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

    return Scaffold(
        appBar: AppBar(
          title: const Text('选种事件详情'),
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
                    ]),
            )));
  }
}
