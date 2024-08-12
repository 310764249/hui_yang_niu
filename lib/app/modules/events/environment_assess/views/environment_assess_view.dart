import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/ex_int.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../controllers/environment_assess_controller.dart';

///
/// 环境评估
///
class EnvironmentAssessView extends GetView<EnvironmentAssessController> {
  const EnvironmentAssessView({Key? key}) : super(key: key);

  // 操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          const CardTitle(title: "操作信息"),
          CellButton(
            isRequired: true,
            title: '环境评估',
            hint: '请选择',
            content: controller.environmentAssess.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.environmentAssessNameList,
                  selectData: controller.environmentAssess.value, title: '请选择', onConfirm: (value, position) {
                controller.environmentAssessId = int.parse(controller.environmentAssessList[position]['value']);
                controller.environmentAssess.value = controller.environmentAssessNameList[position];
              });
            },
          ),
          CellButton(
              isRequired: true,
              title: '评估日期',
              hint: '请选择',
              content: controller.assessTime.value,
              onPressed: () {
                Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.assessTime.value, onConfirm: (date) {
                  controller.assessTime.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
              }),
          CellTextArea(
              isRequired: false,
              title: "备注信息",
              hint: "请输入",
              showBottomLine: false,
              controller: controller.remarkController,
              focusNode: controller.remarkNode),
        ]));
  }

  // 提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
          text: "提交",
          onPressed: () async {
            controller.commitPreventionData();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading设置屏蔽长按返回键的back toast
          leading: WillPopScope(
            onWillPop: () async {
              // 在这里执行返回按钮的操作
              Navigator.of(context).pop();
              return false; // 返回false禁用弹框提示
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // 在这里执行返回按钮的操作
                Navigator.of(context).pop();
              },
            ),
          ),
          title: const Text('环境评估'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: PageWrapper(
          config: controller.buildConfig(context),
          child: ListView(children: [
            // 操作信息
            _operationInfo(context),
            // 提交按钮
            _commitButton()
          ]),
        ));
  }
}
