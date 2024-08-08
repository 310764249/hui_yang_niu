import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../routes/app_pages.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/picker.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_int.dart';
import '../controllers/ban_controller.dart';

class BanView extends GetView<BanController> {
  const BanView({Key? key}) : super(key: key);

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
        title: "开始时间",
        hint: "请选择",
        content: controller.startTimeStr.value,
        onPressed: () {
          Picker.showDatePicker(context,
              title: '请选择开始时间',
              selectDate: controller.startTimeStr.value, onConfirm: (date) {
            controller.updateTimeStr(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      CellButton(
        isRequired: true,
        title: "结束时间",
        hint: "请选择",
        content: controller.endTimeStr.value,
        onPressed: () {
          Picker.showDatePicker(context,
              title: '请选择结束时间',
              isMaxDate: false,
              selectDate: controller.endTimeStr.value, onConfirm: (date) {
            controller.updateEndTimeStr(
                "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
          });
        },
      ),
      RadioButtonGroup(
          isRequired: true,
          title: '禁配原因',
          selectedIndex: controller.curReasonIndex.value,
          items: controller.reasonNameList,
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
        title: const Text('禁配'),
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
