import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';
import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../models/cow_batch.dart';
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
import '../../../batch_list/controllers/batch_list_controller.dart';
import '../controllers/wean_controller.dart';

class WeanView extends GetView<WeanController> {
  const WeanView({Key? key}) : super(key: key);

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

      // CellButton(
      //   isRequired: true,
      //   title: "栋舍",
      //   hint: "请选择",
      //   showBottomLine: true,
      //   content: controller.selectedHouseName.value,
      //   onPressed: () {
      //     Picker.showSinglePicker(context, controller.houseNameList,
      //         title: '请选择栋舍', onConfirm: (value, p) {
      //       controller.updateCurCowHouse(value, p);
      //     });
      //   },
      // ),
      CellButton(
        isRequired: true,
        title: "断奶犊牛批次",
        hint: "请选择",
        content: controller.calveBatchNumber.value,
        showBottomLine: true,
        onPressed: () {
          if (controller.isEdit.value) {
            return;
          }
          //点击后重新请求
          // controller.requestBatchNumber(1);
          //1：犊牛；2：育肥牛；3：引种牛；4：选育牛；5：后备公牛；6：后备母牛
          Get.toNamed(Routes.BATCH_LIST, arguments: BatchListArgument(goBack: true, type: 1))?.then((value) {
            if (ObjectUtil.isEmpty(value)) {
              return;
            }
            //拿到批次号数组
            List<CowBatch> list = value as List<CowBatch>;
            if (list.isNotEmpty) {
              // Log.d(list.first.toJson().toString());
              controller.calveBatchNumber.value = list.first.batchNo ?? '';
              controller.calveBatchCount = list.first.count;
              controller.update();
            }
          });
        },
      ),
      CellTextField(
        isRequired: true,
        title: '头数',
        hint: '请输入',
        keyboardType: TextInputType.number,
        controller: controller.countController,
        focusNode: controller.countNode,
        onChanged: (value) {
          controller.count = value;
        },
      ),

      CellButton(
        isRequired: true,
        title: "育肥牛批次",
        hint: "请选择",
        content: controller.batchNumber.value,
        showBottomLine: true,
        onPressed: () {
          Get.toNamed(Routes.BATCH_LIST, arguments: BatchListArgument(goBack: true, type: 2))?.then((value) {
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
        isRequired: false,
        title: '总重量（kg）',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        controller: controller.weightController,
        focusNode: controller.weightNode,
        onChanged: (value) {
          controller.count = value;
        },
      ),
      CellButton(
        isRequired: true,
        title: "断奶时间",
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
        title: const Text('断奶'),
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
