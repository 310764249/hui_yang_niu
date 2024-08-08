import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/cell_text_field.dart';

import '../../../services/constant.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/cell_button.dart';
import '../../../widgets/cell_text_area.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/picker.dart';
import '../../../widgets/radio_button_group.dart';
import '../../../widgets/toast.dart';
import '../../../services/ex_int.dart';
import '../controllers/cattle_edit_controller.dart';

class CattleEditView extends GetView<CattleEditController> {
  const CattleEditView({super.key});

  // 母牛
  Widget _cowLayout(BuildContext context) {
    return Column(
      children: [
        // 生长阶段
        RadioButtonGroup(
            isRequired: true,
            title: '生长阶段',
            selectedIndex: controller.szjdCurIndex.value,
            items: controller.szjdNameList,
            showBottomLine: true,
            onChanged: (index) {
              controller.updateSZJD(index,1);
            }),
        RadioButtonGroup(
            isRequired: true,
            title: '胎次',
            selectedIndex: controller.pregnancyNumPosition.value,
            items: Constant.pregnancyNumList,
            onChanged: (index) {
              controller.updatePregnancy(index);
            }),
      ],
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellTextField(
        isRequired: true,
        title: '耳号',
        hint: "请输入",
        controller: controller.codeController,
        focusNode: controller.codeNode,
      ),
      // 公母
      RadioButtonGroup(
          isRequired: true,
          title: '公母',
          selectedIndex: controller.gmCurIndex.value,
          items: controller.gmNameList,
          showBottomLine: true,
          onChanged: (index) {
            // Toast.show('--> $value');
            controller.updateGMIndex(index);
          }),

      // 公母-类型
      controller.gmCurIndex.value == 0
          ? // 生长阶段
          RadioButtonGroup(
              isRequired: true,
              title: '生长阶段',
              selectedIndex: controller.szjdCurIndex.value,
              items: controller.gSzjdNameList,
              showBottomLine: true,
              onChanged: (index) {
                controller.updateSZJD(index,0);
              })
          : _cowLayout(context),
      CellTextField(
        isRequired: false,
        title: '电子耳号',
        hint: "请输入",
        controller: controller.eleCodeController,
        focusNode: controller.eleCodeNode,
      ),
      CellButton(
        isRequired: true,
        title: "出生年月",
        hint: "请选择",
        showBottomLine: true,
        content: controller.birthStr.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择时间', onConfirm: (date) {
            //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
            controller.updateBirthday(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),

      // 品种
      RadioButtonGroup(
          isRequired: true,
          title: '品种',
          selectedIndex: controller.pzCurIndex.value,
          items: controller.pzNameList,
          showBottomLine: true,
          onChanged: (index) {
            controller.updatePZ(index);
          }),
      CellButton(
        isRequired: true,
        title: "栋舍",
        hint: "请选择",
        showBottomLine: true,
        content: controller.selectedHouseName.value,
        showArrow: true,
        onPressed: () {
          Picker.showSinglePicker(context, controller.houseNameList,
              title: '请选择栋舍', onConfirm: (value, p) {
            controller.updateCurCowHouse(value, p);
          });
        },
      ),
      CellTextField(
        isRequired: false,
        title: '来源场',
        hint: "请输入",
        controller: controller.sourceController,
        focusNode: controller.sourceNode,
      ),
      CellButton(
        isRequired: true,
        title: "入场时间",
        hint: "请选择",
        showBottomLine: true,
        content: controller.timesStr.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择时间', onConfirm: (date) {
            //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
            controller.updateSeldate(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      CellTextField(
        isRequired: false,
        title: '栏位',
        hint: "请输入",
        controller: controller.columnController,
        focusNode: controller.columnNode,
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
          title: const Text('牛只编辑'),
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
