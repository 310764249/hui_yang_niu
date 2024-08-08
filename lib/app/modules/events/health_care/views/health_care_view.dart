import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../services/screenAdapter.dart';
import '../../../../services/ex_int.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/toast.dart';
import '../controllers/health_care_controller.dart';

///
/// 保健
///
class HealthCareView extends GetView<HealthCareController> {
  const HealthCareView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          const CardTitle(title: "操作信息"),
          CellButton(
            isRequired: true,
            title: '栋舍',
            content: controller.cowHouse?.value,
            showArrow: controller.isEdit.value ? false : true,
            onPressed: () {
              if (controller.houseNameList.isNotEmpty) {
                Picker.showSinglePicker(context, controller.houseNameList,
                    selectData: controller.cowHouse?.value,
                    title: '请选择栋舍', onConfirm: (value, position) {
                  controller.cowHouseId = controller.houseList[position].id;
                  controller.cowHouse?.value = value;
                  controller.cattleCount.value =
                      controller.houseList[position].occupied; // occupied: 入驻数
                  controller.calculateTotalDosage();
                });
              } else {
                Toast.show('暂无栋舍数据');
              }
            },
          ),
          CellButton(
              isRequired: true,
              title: '保健时间',
              hint: '请选择',
              content: controller.healthTime.value,
              onPressed: () {
                Picker.showDatePicker(context,
                    title: '请选择时间',
                    selectDate: controller.healthTime.value, onConfirm: (date) {
                  controller.healthTime.value =
                      "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
              }),
          CellButton(
            isRequired: true,
            title: "保健类型",
            hint: "请选择",
            showBottomLine: true,
            content: controller.healthType.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.healthTypeNameList,
                  title: '请选择保健类型', onConfirm: (value, position) {
                controller.healthTypeId =
                    controller.healthTypeList[position]['value'];
                controller.healthType.value =
                    controller.healthTypeNameList[position];
              });
            },
          ),
          CellTextField(
            isRequired: false,
            title: '用药',
            hint: '请输入',
            content: controller.pharmacy.value,
            controller: controller.pharmacyController,
            focusNode: controller.pharmacyNode,
            onChanged: (value) {
              controller.pharmacy.value = value;
            },
          ),
          CellTextField(
            isRequired: false,
            title: '单头剂量',
            hint: '请输入',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: TextEditingController(
                text: controller.dosage.value.toString().trim()),
            focusNode: controller.dosageNode,
            showTitleOption: true,
            titleOptionHint: '请选择剂量单位',
            titleOptionContent: controller.unit.value,
            onOptionPressed: () {
              Picker.showSinglePicker(
                context,
                controller.unitNameList,
                title: '选择剂量单位',
                selectData: controller.unit.value,
                onConfirm: (data, position) {
                  controller.updateUnit(data, position);
                },
              );
            },
            onChanged: (value) {
              controller.dosageController.text = value;
            },
          ),
          CellTextField(
            isRequired: false,
            title: '头数',
            hint: '请输入',
            keyboardType: TextInputType.number,
            //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            controller: TextEditingController(
                text: controller.cattleCount.value.toString().trim()),
            focusNode: controller.cattleCountNode,
            onChanged: (value) {
              controller.cattleCountController.text = value;
            },
          ),
          CellTextField(
            isRequired: false,
            title: '总剂量',
            hint: '请输入',
            titleOptionContent: controller.unit.value,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: TextEditingController(
                text: controller.totalDosage.value.toString().trim()),
            focusNode: controller.totalDosageNode,
            onChanged: (value) {
              controller.totalDosageController.text = value;
            },
          ),
          CellTextArea(
            isRequired: false,
            title: "备注信息",
            hint: "请输入",
            showBottomLine: false,
            controller: controller.remarkController,
            focusNode: controller.remarkNode,
          ),
        ]));
  }

  //提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
          text: "提交",
          onPressed: () {
            controller.requestCommit();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('保健'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: PageWrapper(
          config: controller.buildConfig(context),
          child: ListView(children: [
            //操作信息
            _operationInfo(context),
            //提交按钮
            _commitButton()
          ]),
        ));
  }
}
