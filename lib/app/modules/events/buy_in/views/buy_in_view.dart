import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../../services/ex_int.dart';

import '../../../../services/screenAdapter.dart';
import '../../../../services/ex_int.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../controllers/buy_in_controller.dart';

class BuyInView extends GetView<BuyInController> {
  const BuyInView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellButton(
        isRequired: true,
        title: "批次号（自动生成）",
        showArrow: false,
        showBottomLine: true,
        content: controller.batchNumber.value,
        onPressed: () {
          //点击后重新请求
          controller.requestBatchNumber();
        },
      ),
      CellTextField(
        isRequired: true,
        title: '引种数量',
        hint: "请输入引种数量",
        keyboardType: TextInputType.number,
        controller: controller.countController,
        focusNode: controller.countNode,
      ),
      CellTextField(
        isRequired: false,
        title: '来源场',
        hint: "请输入来源场",
        controller: controller.sourceController,
        focusNode: controller.sourceNode,
      ),
      CellButton(
        isRequired: true,
        title: "入场时间",
        hint: "请选择",
        content: controller.stationedTime.value,
        onPressed: () {
          Picker.showDatePicker(context,
              title: '请选择入场时间', selectDate: '2023-01-01', onConfirm: (date) {
            //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
            controller.updateStationedTime(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      CellButton(
        isRequired: true,
        title: "出生日期",
        hint: "请选择",
        showBottomLine: true,
        content: controller.birthday.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择出生日期', onConfirm: (date) {
            //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
            controller.updateSeldate(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      // 性别
      RadioButtonGroup(
          isRequired: true,
          title: '性别',
          selectedIndex: controller.selectedGenderIndex.value,
          items: controller.genderNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateCurGender(value);
          }),
      // 品种
      RadioButtonGroup(
          isRequired: true,
          title: '品种',
          selectedIndex: controller.selectedBreedIndex.value,
          items: controller.breedNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateCurBreed(value);
          }),
      CellButton(
        isRequired: true,
        title: "栋舍",
        hint: "请选择",
        showBottomLine: true,
        content: controller.selectedHouseName.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.houseNameList,
              title: '请选择栋舍', onConfirm: (value, p) {
            //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
            controller.updateCurCowHouse(value, p);
          });
        },
      ),
      // CellTextField(
      //   isRequired: false,
      //   title: "栏位",
      //   hint: "请输入",
      //   controller: controller.columnController,
      //   focusNode: controller.columnNode,
      //   onChanged: (value) {
      //     print(value);
      //   },
      // ),
      CellTextArea(
        isRequired: false,
        title: "备注信息",
        hint: "请输入",
        showBottomLine: false,
        controller: controller.remarkController,
        focusNode: controller.remarkNode,
      ),
    ]);
  }

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
          title: const Text('引种'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => PageWrapper(
              config: controller.buildConfig(context),
              child: ListView(children: [
                //操作信息
                _operationInfo(context),
                //提交按钮
                _commitButton()
              ]),
            )));
  }
}
