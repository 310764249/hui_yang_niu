import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/cell_button.dart';
import '../../../widgets/cell_text_area.dart';
import '../../../widgets/cell_text_field.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/picker.dart';
import '../../../widgets/radio_button_group.dart';
import '../../../services/ex_int.dart';
import '../../../widgets/toast.dart';
import '../controllers/new_batch_controller.dart';

class NewBatchView extends GetView<NewBatchController> {
  const NewBatchView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      RadioButtonGroup(
          isRequired: true,
          title: '批次类型',
          selectedIndex: controller.curTypeIDIndex.value,
          items: controller.typeNameList,
          showBottomLine: true,
          onChanged: (value) {
            if (controller.isEdit.value) {
              //编辑页面无法切换类型
              Toast.show('编辑时无法切换类型');
              return;
            }
            controller.updatePass(value);
          }),
      CellButton(
        isRequired: true,
        title: "批次号（自动生成）",
        showArrow: false,
        showBottomLine: true,
        content: controller.batchNumber.value,
        onPressed: () {
          //点击后重新请求
          controller.requestBatchNumber(1);
        },
      ),
      CellTextField(
        isRequired: true,
        title: '批次总数',
        hint: "请输入",
        keyboardType: TextInputType.number,
        controller: controller.countController,
        focusNode: controller.countNode,
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
      CellButton(
        isRequired: true,
        title: "出生日期",
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
        title: const Text('批次'),
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
              _commitButton(),
            ]),
          )),
    );
  }
}
