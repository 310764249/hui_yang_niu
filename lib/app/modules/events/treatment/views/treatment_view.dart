import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../models/cow_batch.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/ex_int.dart';
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
import '../../../batch_list/controllers/batch_list_controller.dart';
import '../../../material_management/select_material_view.dart';
import '../controllers/treatment_controller.dart';

///
/// 诊疗
///
class TreatmentView extends GetView<TreatmentController> {
  const TreatmentView({Key? key}) : super(key: key);

  // 种牛类型
  Widget _oldCowLayout(BuildContext context) {
    return Column(
      children: [
        CellButton(
          isRequired: true,
          title: '耳号',
          hint: controller.isEdit.value ? '' : "请选择",
          content: controller.codeString.value,
          showArrow: !controller.isEdit.value,
          onPressed: () {
            Get.toNamed(
              Routes.CATTLELIST,
              arguments: CattleListArgument(goBack: true, single: false),
            )?.then((value) {
              if (ObjectUtil.isEmpty(value)) {
                return;
              }
              //拿到牛只数组
              List<Cattle> list = value as List<Cattle>;
              //保存选中的牛只模型
              controller.selectedOldCow = list;
              //更新耳号显示
              controller.updateCodeString(list.map((e) => e.code).join(','));
              debugPrint('----------> value: $value');
              // controller.updateCowHouse(list.first);
              // 种牛
              controller.oldCowHouseId = list.first.cowHouseId;
              controller.oldCowHouse.value = list.first.cowHouseName ?? '';
            });
          },
        ),
      ],
    );
  }

  // 犊牛/育肥牛
  Widget _littleCowLayout(BuildContext context) {
    return Column(
      children: [
        CellButton(
          isRequired: true,
          title: "批次号",
          hint: controller.isEdit.value ? '' : "请选择",
          content: controller.batchNumber.value,
          showArrow: !controller.isEdit.value,
          showBottomLine: true,
          onPressed: () {
            Get.toNamed(
              Routes.BATCH_LIST,
              arguments: BatchListArgument(goBack: true),
            )?.then((value) {
              if (ObjectUtil.isEmpty(value)) {
                return;
              }
              //拿到批次号数组
              List<CowBatch> list = value as List<CowBatch>;
              //保存选中的批次模型
              controller.selectedLittleCowBatch = list.first;
              //更新批次号数字显示
              controller.updateBatchNumber(list.first.batchNo ?? '');
              // 犊牛/育肥牛
              controller.littleCowHouseId = list.first.cowHouseId;
              controller.littleCowHouse.value = list.first.cowHouseName ?? '';
              // 头数
              controller.cattleCount.value = list.first.count;
            });
          },
        ),
      ],
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return Obx(
      () => MyCard(
        children: [
          const CardTitle(title: "操作信息"),
          // 类型
          RadioButtonGroup(
            isRequired: true,
            title: '类型',
            selectedIndex: controller.typeIndex.value,
            items: controller.chooseTypeNameList,
            showBottomLine: true,
            onChanged: (value) {
              if (controller.isEdit.value) {
                //编辑页面选择种牛的场景，无法切换到批次号列表
                Toast.show('事件编辑时无法切换类型');
                return;
              }
              controller.updateChooseTypeIndex(value);
            },
          ),
          // 类型
          controller.typeIndex.value == 0
              ? _oldCowLayout(context)
              : _littleCowLayout(context),
          // 如果是编辑, 则隐藏[栋舍]组件
          controller.isEdit.value
              ? const SizedBox()
              : CellButton(
                isRequired: false,
                title: '栋舍',
                content:
                    controller.typeIndex.value == 0
                        ? controller.oldCowHouse.value
                        : controller.littleCowHouse.value,
                showArrow: false,
              ),
          CellButton(
            isRequired: true,
            title: '诊疗时间',
            hint: '请选择',
            content: controller.treatmentTime.value,
            onPressed: () {
              Picker.showDatePicker(
                context,
                title: '请选择时间',
                selectDate: controller.treatmentTime.value,
                onConfirm: (date) {
                  controller.treatmentTime.value =
                      "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                },
              );
            },
          ),
          CellButton(
            isRequired: true,
            title: "疾病名称",
            hint: "请选择",
            showBottomLine: true,
            content: controller.illness.value,
            onPressed: () {
              Picker.showSinglePicker(
                context,
                controller.illnessNameList,
                title: '请选择疾病名称',
                onConfirm: (value, position) {
                  controller.illnessId = int.parse(
                    controller.illnessList[position]['value'],
                  );
                  controller.illness.value =
                      controller.illnessNameList[position];
                },
              );
            },
          ),
          controller.typeIndex.value == 1
              ? CellTextField(
                isRequired: false,
                title: '头数',
                hint: '请输入',
                keyboardType: TextInputType.number,
                controller: TextEditingController(
                  text: controller.cattleCount.value.toString().trim(),
                ),
                focusNode: controller.cattleCountNode,
                onChanged: (value) {
                  controller.cattleCountController.text = value;
                },
              )
              : const SizedBox(),
          CellTextField(
            isRequired: false,
            title: '症状',
            hint: '请输入',
            content: controller.symptom.value,
            controller: controller.symptomController,
            focusNode: controller.symptomNode,
            onChanged: (value) {
              controller.symptom.value = value;
            },
          ),
          // 旧 pharmacy 字段保留兼容，界面改为选择 materialVaccine。
          if (false)
            CellTextField(
              isRequired: false,
              title: '用药',
              hint: '请输入',
              content: controller.pharmacy.value,
              controller: controller.pharmacyController,
              focusNode: controller.pharmacyNode,
              onChanged: (value) {
                controller.pharmacy.value = value;
              },
            ),
          CellButton(
            isRequired: false,
            title: '用药物资',
            hint: '请选择',
            content: controller.materialVaccine.value,
            onPressed: () {
              SelectMaterialView.push(context, vaccineOnly: true).then((item) {
                if (item != null) controller.selectMaterialVaccine(item);
              });
            },
          ),
          CellTextField(
            isRequired: false,
            title: '单头剂量',
            hint: '请输入',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            content:
                controller.dosage.value == 0
                    ? ''
                    : controller.dosage.value.toString().trim(),
            controller: controller.dosageController,
            focusNode: controller.dosageNode,
            showTitleOption: true,
            titleOptionHint: '请选择剂量单位',
            titleOptionContent: controller.unit.value,
            onOptionPressed: () {
              Picker.showSinglePicker(
                context,
                controller.unitNameList,
                title: '选择剂量单位',
                selectData: controller.unit.value,
                onConfirm: (data, position) {
                  controller.updateUnit(data, position);
                },
              );
            },
            onChanged: (value) {
              controller.dosage.value = double.tryParse(value) ?? 0;
            },
          ),
          CellTextField(
            isRequired: false,
            title: '诊疗人员',
            hint: '请输入诊疗人员姓名',
            content: controller.treatmentPerson,
            controller: controller.treatmentPersonController,
            focusNode: controller.treatmentPersonNode,
            onChanged: (value) {
              // controller.treatmentPerson = value;
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
        ],
      ),
    );
  }

  //提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
        text: "提交",
        onPressed: () {
          controller.requestCommit();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('诊疗'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: PageWrapper(
        config: controller.buildConfig(context),
        child: ListView(
          children: [
            //操作信息
            _operationInfo(context),
            //提交按钮
            _commitButton(),
          ],
        ),
      ),
    );
  }
}
