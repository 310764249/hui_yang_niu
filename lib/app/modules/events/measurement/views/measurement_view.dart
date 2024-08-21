import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/measurement_controller.dart';
import 'package:common_utils/common_utils.dart';
import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_int.dart';

class MeasurementView extends GetView<MeasurementController> {
  const MeasurementView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellButton(
        isRequired: true,
        title: '耳号',
        hint: "请选择",
        content: controller.codeString.value,
        showArrow: !controller.isEdit.value,
        onPressed: () {
          Get.toNamed(Routes.CATTLELIST,
              arguments: CattleListArgument(
                goBack: true,
                single: true,
                //szjdList: controller.szjdListFiltered,
                isFilterInvalid: true,
              ))?.then((value) {
            if (ObjectUtil.isEmpty(value)) {
              return;
            }
            //拿到牛只数组，默认 single: true, 单选
            List<Cattle> list = value as List<Cattle>;
            //保存选中的牛只模型
            controller.selectedCow = list.first;
            //更新耳号显示
            controller.updateCodeString(list.first.code ?? '');
          });
        },
      ),
      CellTextField(
        isRequired: false,
        title: '额宽(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.foreheadWidthController,
        focusNode: controller.foreheadWidthNode,
        onChanged: (value) {
          print('额宽: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '体高(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.heightController,
        focusNode: controller.heightNode,
        onChanged: (value) {
          print('体高: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '体长(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.lengthController,
        focusNode: controller.lengthNode,
        onChanged: (value) {
          print('体长: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '体斜长(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.geologyController,
        focusNode: controller.geologyNode,
        onChanged: (value) {
          print('体斜长: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '胸宽(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.chestWidthController,
        focusNode: controller.chestWidthNode,
        onChanged: (value) {
          print('胸宽: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '胸深(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.chestDepthController,
        focusNode: controller.chestDepthNode,
        onChanged: (value) {
          print('胸深: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '胸围(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.chestSizeController,
        focusNode: controller.chestSizeNode,
        onChanged: (value) {
          print('胸围: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '腰角宽(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.waistWidthController,
        focusNode: controller.waistWidthNode,
        onChanged: (value) {
          print('腰角宽: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '管围(cm)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.perimeterController,
        focusNode: controller.perimeterNode,
        onChanged: (value) {
          print('管围: $value');
        },
      ),
      CellTextField(
        isRequired: false,
        title: '体重(kg)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.weightController,
        focusNode: controller.weightNode,
        onChanged: (value) {
          print('体重: $value');
        },
      ),
      CellButton(
        isRequired: true,
        title: "测定时间",
        hint: "请选择",
        content: controller.timesStr.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.timesStr.value, onConfirm: (date) {
            controller.updateTimeStr("${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
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
        title: const Text('体尺测定'),
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
