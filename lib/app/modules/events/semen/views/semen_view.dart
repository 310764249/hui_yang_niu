import 'package:flutter/material.dart';

import 'package:get/get.dart';

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
import '../controllers/semen_controller.dart';

class SemenView extends GetView<SemenController> {
  const SemenView({Key? key}) : super(key: key);

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
                gmList: controller.gmList,
                szjdList: controller.szjdListFiltered,
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
      CellButton(
        isRequired: true,
        title: "采精时间",
        hint: "请选择",
        content: controller.timesStr.value,
        onPressed: () {
          Picker.showDatePicker(context,
              title: '请选择时间',
              selectDate: controller.timesStr.value, onConfirm: (date) {
            controller.updateTimeStr(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      CellTextField(
        isRequired: true,
        title: '采精量（ml）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.totalController,
        focusNode: controller.totalNode,
        onChanged: (value) {
          controller.total = value;
        },
      ),
      CellTextField(
        isRequired: true,
        title: '稀释份数',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.countController,
        focusNode: controller.countNode,
        onChanged: (value) {
          controller.count = value;
        },
      ),
      RadioButtonGroup(
          isRequired: true,
          title: '是否合格',
          selectedIndex: controller.curPassIndex.value,
          items: controller.passNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updatePass(value);
          }),
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
        title: const Text('采精'),
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
