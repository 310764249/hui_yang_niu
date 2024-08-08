import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/characters_controller.dart';
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

class CharactersView extends GetView<CharactersController> {
  const CharactersView({Key? key}) : super(key: key);

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
                // gmList: controller.gmList,
                // szjdList: controller.szjdListFiltered,
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
      // CellButton(
      //   isRequired: true,
      //   title: "登记时间",
      //   hint: "请选择",
      //   content: controller.timesStr.value,
      //   onPressed: () {
      //     Picker.showDatePicker(context,
      //         title: '请选择时间',
      //         selectDate: controller.timesStr.value, onConfirm: (date) {
      //       controller.updateTimeStr(
      //           "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
      //     });
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

  //肉质性状
  Widget _meatInfo() {
    return MyCard(children: [
      const CardTitle(title: "肉质性状"),
      CellTextField(
        isRequired: false,
        title: '肌肉PH(5.0-7.0)', //5.0-7.0
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.musclePhController,
        focusNode: controller.musclePhNode,
      ),
      CellTextField(
        isRequired: false,
        title: '肌肉脂肪率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.muscleFatRateController,
        focusNode: controller.muscleFatRateNode,
      ),
      RadioButtonGroup(
          isRequired: false,
          title: '肉色',
          selectedIndex: controller.curMealIndex.value,
          items: controller.mealList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateMeal(value);
          }),
      RadioButtonGroup(
          isRequired: false,
          title: '大理石纹',
          selectedIndex: controller.curMarbleIndex.value,
          items: controller.marbleList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateMarble(value);
          }),
      CellTextField(
        isRequired: false,
        title: '嫩度（N/cm）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.tendernessController,
        focusNode: controller.tendernessNode,
      ),
      CellTextField(
        isRequired: false,
        title: '系水力（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.waterHoldController,
        focusNode: controller.waterHoldNode,
      ),
    ]);
  }

  //胴体性状
  Widget _bodyInfo() {
    return MyCard(children: [
      const CardTitle(title: "胴体性状"),
      CellTextField(
        isRequired: false,
        title: '屠宰率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.deadWeightController,
        focusNode: controller.deadWeightNode,
      ),
      CellTextField(
        isRequired: false,
        title: '净肉率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.pureMeatRateController,
        focusNode: controller.pureMeatRateNode,
      ),
      CellTextField(
        isRequired: false,
        title: '脂肪厚度（mm）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.fatThicknessController,
        focusNode: controller.fatThicknessNode,
      ),
      CellTextField(
        isRequired: false,
        title: '背膘厚度（mm）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.backfatThickController,
        focusNode: controller.backfatThickNode,
      ),
      CellTextField(
        isRequired: false,
        title: '眼肌肉面积（cm²）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.eyeMuscleAreaController,
        focusNode: controller.eyeMuscleAreaNode,
      ),
    ]);
  }

  //繁殖性状
  Widget _propagateInfo() {
    return MyCard(children: [
      const CardTitle(title: "繁殖性状"),
      CellTextField(
        isRequired: false,
        title: '受胎率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.pregnancyController,
        focusNode: controller.pregnancyNode,
      ),
      CellTextField(
        isRequired: false,
        title: '产犊率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.calvRateController,
        focusNode: controller.calvRateNode,
      ),
      CellTextField(
        isRequired: false,
        title: '犊牛断奶成活率（%）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.rateOfWeanController,
        focusNode: controller.rateOfWeanNode,
      ),
    ]);
  }

  // 生长性状
  Widget _growthInfo() {
    return MyCard(children: [
      const CardTitle(title: "生长性状"),
      CellTextField(
        isRequired: false,
        title: '日增重（g）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.dailyController,
        focusNode: controller.dailyNode,
      ),
      CellTextField(
        isRequired: false,
        title: '饲料利用率（%)',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.usageController,
        focusNode: controller.usageNode,
      ),
      CellTextField(
        isRequired: false,
        title: '初生重（kg）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.birthWeightController,
        focusNode: controller.birthWeightNode,
      ),
      CellTextField(
        isRequired: false,
        title: '断奶重（kg）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.weanWeightController,
        focusNode: controller.weanWeightNode,
      ),
      CellTextField(
        isRequired: false,
        title: '断奶后日增重（g）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.weanWeightDayController,
        focusNode: controller.weanWeightDayNode,
      ),
      CellTextField(
        isRequired: false,
        title: '成年体重（kg）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.growUpWeightController,
        focusNode: controller.growUpNode,
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
        title: const Text('性状统计'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(() => PageWrapper(
            config: controller.buildConfig(context),
            child: ListView(children: [
              //操作信息
              _operationInfo(context),
              //生长性状
              _growthInfo(),
              //繁殖性状
              _propagateInfo(),
              //胴体性状
              _bodyInfo(),
              //肉质性状
              _meatInfo(),

              //提交按钮
              _commitButton(),
            ]),
          )),
    );
  }
}
