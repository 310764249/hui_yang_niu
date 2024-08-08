import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cow_batch.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/colors.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/select_cattle_controller.dart';
import '../../../../services/ex_int.dart';

// 选种页面
class SelectCattleView extends GetView<SelectCattleController> {
  const SelectCattleView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellButton(
        isRequired: true,
        title: "批次号",
        hint: "请选择批次号",
        content: controller.batchNumber.value,
        showArrow: !controller.isEdit.value,
        showBottomLine: true,
        onPressed: () {
          Get.toNamed(
            Routes.BATCH_LIST,arguments: BatchListArgument(
              goBack: true,
            )
          )?.then((value) {
            if (ObjectUtil.isEmpty(value)) {
              return;
            }
            //拿到批次号数组
            List<CowBatch> list = value as List<CowBatch>;
            //保存选中的批次模型
            controller.selectedCowBatch = list.first;
            //更新批次号数字显示
            controller.updateBatchNumber(list.first.batchNo ?? '');
          });
        },
      ),
      CellTextField(
        isRequired: true,
        title: '耳号',
        hint: "请输入耳号",
        controller: controller.codeController,
        focusNode: controller.codeNode,
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
            controller.updateBirthday(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      // 类型
      RadioButtonGroup(
          isRequired: true,
          title: '类型',
          selectedIndex: controller.selectedGenderIndex.value,
          items: controller.chooseTypeNameList,
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
        title: "转入栋舍",
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
      CellTextField(
        isRequired: false,
        title: "栏位",
        hint: "请输入",
        controller: controller.columnController,
        focusNode: controller.columnNode,
        onChanged: (value) {
          // print(value);
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
          title: const Text('选种'),
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
