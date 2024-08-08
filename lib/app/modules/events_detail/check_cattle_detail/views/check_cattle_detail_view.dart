import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/check_cattle_detail_controller.dart';
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

class CheckCattleDetailView extends GetView<CheckCattleDetailController> {
  const CheckCattleDetailView({Key? key}) : super(key: key);

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
        title: '盘点数量',
        hint: controller.event!.count.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '盘点时间',
        hint: controller.event!.date,
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
          title: const Text('盘点事件详情'),
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
