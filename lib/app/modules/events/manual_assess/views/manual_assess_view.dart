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
import '../controllers/manual_assess_controller.dart';

///
/// 人工评估
///
class ManualAssessView extends GetView<ManualAssessController> {
  const ManualAssessView({Key? key}) : super(key: key);

  // 操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          controller.isEdit.value
              ? CellButton(
                  isRequired: true,
                  title: '人工单号',
                  hint: '',
                  content: controller.event?.no ?? "",
                  showArrow: false,
                )
              : Container(),
          CellButton(
            isRequired: true,
            title: '费用类型',
            hint: '请选择',
            content: controller.manualAssess.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.manualAssessNameList,
                  selectData: controller.manualAssess.value, title: '请选择', onConfirm: (value, position) {
                controller.manualAssessId = int.parse(controller.manualAssessList[position]['value']);
                controller.manualAssess.value = controller.manualAssessNameList[position];
              });
            },
          ),
          CellTextField(
            isRequired: true,
            title: '费用',
            hint: '请输入',
            keyboardType: TextInputType.number,
            //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            controller: controller.amountController,
            focusNode: controller.amountNode,
            onComplete: () {
              controller.amountController.text = int.parse(controller.amountController.text.trim()).toString();
            },
          ),
          CellButton(
              isRequired: true,
              title: '录入日期',
              hint: '请选择',
              content: controller.assessTime.value,
              onPressed: () {
                Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.assessTime.value, onConfirm: (date) {
                  controller.assessTime.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
              }),
          CellTextField(
              isRequired: true,
              title: '人员姓名',
              hint: '请输入',
              controller: controller.employeeController,
              focusNode: controller.employeeNode),
          CellTextField(
              isRequired: false,
              title: '所在岗位',
              hint: '请输入',
              keyboardType: TextInputType.text,
              controller: controller.postController,
              focusNode: controller.postCountNode),
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
          title: const Text('人工'),
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
