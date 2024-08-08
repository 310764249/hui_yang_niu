import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/cattle.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../models/cattle_list_argu.dart';
import '../../../../models/cow_batch.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/colors.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/allot_cattle_controller.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/picker.dart';
import '../../../../services/ex_int.dart';

class AllotCattleView extends GetView<AllotCattleController> {
  const AllotCattleView({Key? key}) : super(key: key);

  // 种牛类型
  Widget _oldCowLayout(BuildContext context) {
    return Column(
      children: [
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
                  szjdList: controller.szjdListFiltered,
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
      ],
    );
  }

  // 犊牛/育肥牛
  Widget _youngCowLayout(BuildContext context) {
    return Column(
      children: [
        CellButton(
          isRequired: true,
          title: "批次号",
          hint: "请选择",
          content: controller.batchNumber.value,
          showArrow: !controller.isEdit.value,
          showBottomLine: true,
          onPressed: () {
            Get.toNamed(Routes.BATCH_LIST,
                arguments: BatchListArgument(
                  goBack: true,
                ))?.then((value) {
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
        CellButton(
          isRequired: true,
          title: '批次数量',
          hint: controller.countNum.value.toString(),
          showArrow: false,
        ),
        // CellTextField(
        //   isRequired: true,
        //   title: '数量',
        //   hint: "请输入数量",
        //   keyboardType: TextInputType.number,
        //   controller: controller.countController,
        //   focusNode: controller.countNode,
        // ),
      ],
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      // 类型
      RadioButtonGroup(
          isRequired: true,
          title: '类型',
          selectedIndex: controller.chooseTypeIndex.value,
          items: controller.chooseTypeNameList,
          showBottomLine: true,
          onChanged: (value) {
            if (controller.isEdit.value) {
              //编辑页面选择种牛的场景，无法切换到批次号列表
              Toast.show('事件编辑时无法切换类型');
              return;
            }
            // Toast.show('--> $value');
            controller.updateChooseTypeIndex(value);
          }),
      // 类型
      controller.chooseTypeIndex.value == 0
          ? _oldCowLayout(context)
          : _youngCowLayout(context),
      CellButton(
        isRequired: true,
        title: "接收场",
        hint: "请选择",
        showBottomLine: true,
        content: controller.curFarm.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.farmNameList,
              title: '请选择接收场', onConfirm: (value, p) {
            controller.updateCurFarmIndex(value, p);
          });
        },
      ),
      //
      CellButton(
        isRequired: true,
        title: "接收栋舍",
        hint: "请选择",
        showBottomLine: true,
        content: controller.selectedHouseName.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.houseNameList,
              title: '请选择栋舍', onConfirm: (value, p) {
            controller.updateCurCowHouse(value, p);
          });
        },
      ),
      CellTextField(
        isRequired: false,
        title: "接收栏位",
        hint: "请输入",
        controller: controller.columnController,
        focusNode: controller.columnNode,
        onChanged: (value) {
          //print(value);
        },
      ),
      CellButton(
        isRequired: true,
        title: "调拨时间",
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
          title: const Text('调拨'),
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
