import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/descendants_controller.dart';
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

class DescendantsView extends GetView<DescendantsController> {
  const DescendantsView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellTextField(
        isRequired: true,
        title: '犊牛耳号',
        hint: '请输入',
        controller: controller.youngCodeController,
        focusNode: controller.youngCodeNode,
        editable: controller.isEdit.value,
        onChanged: (value) {
          //print('犊牛耳号: $value');
        },
      ),
      CellButton(
        isRequired: true,
        title: '母牛耳号',
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
        title: "出生日期",
        hint: "请选择",
        content: controller.birth.value,
        onPressed: () {
          Picker.showDatePicker(context,
              title: '请选择时间',
              selectDate: controller.timesStr.value, onConfirm: (date) {
            controller.updateBirth(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      // 性别
      RadioButtonGroup(
          isRequired: true,
          title: '犊牛性别',
          selectedIndex: controller.selectedGenderIndex.value,
          items: controller.genderNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateCurGender(value);
          }),
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
        isRequired: false,
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
        title: '犊牛体重(kg)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.weightController,
        focusNode: controller.weightNode,
        onChanged: (value) {
          print('犊牛体重: $value');
        },
      ),
      CellButton(
        isRequired: true,
        title: "登记时间",
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
        title: const Text('后裔登记'),
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
