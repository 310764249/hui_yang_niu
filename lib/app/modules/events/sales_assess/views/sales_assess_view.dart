import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import '../controllers/sales_assess_controller.dart';

///
/// 出栏评估
///
class SalesAssessView extends GetView<SalesAssessController> {
  const SalesAssessView({Key? key}) : super(key: key);

  // 操作信息
  Widget _operationInfo(context) {
    var lstFormat = [
      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
    ];
    return Obx(() => MyCard(children: [
      controller.isEdit.value ?
      CellButton(
        isRequired: true,
        title: '销售单号',
        hint: '',
        content: controller.event?.no ?? "",
        showArrow: false,
      ):Container(),

      CellButton(
          isRequired: true,
          title: '销售日期',
          hint: '请选择',
          content: controller.assessTime.value,
          onPressed: () {
            Picker.showDatePicker(context,
                title: '请选择时间', selectDate: controller.assessTime.value,
                onConfirm: (date) {
                  controller.assessTime.value =
                  "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
          }),

      CellButton(
        isRequired: true,
        title: '销售类型',
        hint: '请选择',
        content: controller.salesAssess.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.salesAssessNameList,
              selectData: controller.salesAssess.value,
              title: '请选择', onConfirm: (value, position) {
                controller.salesAssessId =
                    int.parse(controller.salesAssessList[position]['value']);
                controller.salesAssess.value = controller.salesAssessNameList[position];
              });
        },
      ),

      CellTextField(
        isRequired: true,
        title: '数量',
        hint: '请输入',
        keyboardType: TextInputType.number,
        //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
        controller: controller.countController,
        focusNode: controller.countNode,
        onChanged: (val){
          controller.autoCalculate();
        },
        onComplete: (){
          controller.countController.text = int.parse(controller.countController.text.trim()).toString();
        },
      ),

      CellTextField(
        isRequired: true,
        title: '单价(元)',
        hint: '请输入',
        inputFormatters: lstFormat,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
        controller: controller.priceController,
        focusNode: controller.priceNode,
        onChanged: (val){
          controller.autoCalculate();
        },
        onComplete: (){
          controller.priceController.text = double.parse(controller.priceController.text.trim()).toString();
        },
      ),
      CellTextField(
        isRequired: true,
        title: '折损(元)',
        hint: '请输入',
        inputFormatters: lstFormat,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
        controller: controller.breakageController,
        focusNode: controller.breakageNode,
        onChanged: (val){
          controller.autoCalculate();
        },
        onComplete: (){
          controller.breakageController.text = double.parse(controller.breakageController.text.trim()).toString();
        },
      ),
      CellTextField(
        isRequired: true,
        title: '总价(元)',
        hint: '请输入',
        inputFormatters: lstFormat,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
        controller: controller.amountController,
        focusNode: controller.amountNode,
        onComplete: (){
          controller.amountController.text = double.parse(controller.amountController.text.trim()).toString();
        },
      ),

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
          title: const Text('出栏'),
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
