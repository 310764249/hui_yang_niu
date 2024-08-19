import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../services/colors.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/picker.dart';
import '../../../../services/ex_int.dart';
import '../controllers/check_cattle_controller.dart';

class CheckCattleView extends GetView<CheckCattleController> {
  const CheckCattleView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellButton(
        isRequired: true,
        title: "栋舍",
        hint: "请选择",
        showBottomLine: true,
        content: controller.selectedHouseName.value,
        showArrow: !controller.isEdit.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.houseNameList, title: '请选择栋舍', onConfirm: (value, p) {
            controller.updateCurCowHouse(value, p);
          });
        },
      ),
      CellButton(
        isRequired: true,
        title: "统计数量",
        showArrow: false,
        content: controller.cowHouseNum.value,
      ),
      CellTextField(
        isRequired: true,
        title: '盘点数量',
        hint: '请输入',
        keyboardType: TextInputType.number,
        controller: controller.countController,
        focusNode: controller.countNode,
        onChanged: (value) {
          controller.realNumber = value;
        },
      ),
      CellButton(
        isRequired: true,
        title: "盘点时间",
        hint: "请选择",
        showBottomLine: true,
        content: controller.timesStr.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.timesStr.value, mode: DateMode.YMD,
              onConfirm: (date) {
            controller.updateSeldate("${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
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
    ]);
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
          title: const Text('盘点'),
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
