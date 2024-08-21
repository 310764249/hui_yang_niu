import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/ex_int.dart';
import '../../../../services/ex_string.dart';
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
import '../controllers/prevention_controller.dart';

///
/// 防疫
///
class PreventionView extends GetView<PreventionController> {
  const PreventionView({Key? key}) : super(key: key);

  // 操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          const CardTitle(title: "操作信息"),
          RadioButtonGroup(
              isRequired: true,
              title: '防疫方式',
              selectedIndex: controller.typeIndex.value,
              items: controller.preventionTypeList,
              onChanged: (value) {
                if (controller.isEdit.value) {
                  //编辑页面选择种牛的场景，无法切换到批次号列表
                  Toast.show('事件编辑时无法切换品种');
                  return;
                }

                controller.updateTypeIndex(value);
              }),
          // 判断是[批量]还是[个体]
          controller.typeIndex.value == 0
              ? const SizedBox()
              : CellButton(
                  isRequired: true,
                  title: '耳号',
                  hint: controller.isEdit.value ? '' : "请选择",
                  content: controller.codeString.value,
                  showArrow: !controller.isEdit.value,
                  onPressed: () {
                    Get.toNamed(Routes.CATTLELIST,
                        arguments: CattleListArgument(
                          goBack: true,
                          single: true,
                        ))?.then((value) {
                      if (ObjectUtil.isEmpty(value)) {
                        return;
                      }
                      // 拿到牛只数组，默认 single: true, 单选
                      List<Cattle> list = value as List<Cattle>;
                      // 保存选中的牛只模型
                      controller.selectedCow = list.first;
                      controller.setCurrentStage(list.first.growthStage);
                      debugPrint('--->选中的item growthStage: ${list.first.growthStage}');
                      debugPrint('--->选中的item cowHouseId: ${list.first.cowHouseId}');
                      // 更新耳号显示
                      controller.updateCodeString(list.first.code ?? '');
                      // 更新个体防疫牛只的栋舍
                      controller.cowHouseId = list.first.cowHouseId;
                      controller.cowHouse?.value = matchCowHouseById(list.first.cowHouseId);
                    });
                  },
                ),
          controller.typeIndex.value == 0
              ? const SizedBox()
              : CellButton(
                  isRequired: true,
                  title: '当前状态',
                  content: controller.currentStage.value,
                  showArrow: false,
                ),
          CellButton(
            isRequired: true,
            title: '栋舍',
            content: controller.typeIndex.value == 0 ? controller.batchCowHouse?.value : controller.cowHouse?.value,
            // !批量防疫时显示箭头, 个体防疫不显示箭头, -- 另外[编辑]时也不显示箭头
            showArrow: controller.isEdit.value || controller.typeIndex.value == 1 ? false : true,
            onPressed: () {
              // !批量防疫时才能点击选择栋舍
              if (controller.typeIndex.value == 0) {
                if (controller.houseNameList.isNotEmpty) {
                  Picker.showSinglePicker(context, controller.houseNameList,
                      selectData: controller.typeIndex.value == 0 ? controller.batchCowHouse?.value : controller.cowHouse?.value,
                      title: '请选择栋舍', onConfirm: (value, position) {
                    controller.updateCowHouseInfo(value, position);
                  });
                } else {
                  Toast.show('暂无栋舍数据');
                }
              }
            },
          ),
          CellButton(
              isRequired: true,
              title: '防疫时间',
              hint: '请选择',
              content: controller.preventionTime.value,
              onPressed: () {
                Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.preventionTime.value, onConfirm: (date) {
                  controller.preventionTime.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
              }),
          CellButton(
            isRequired: true,
            title: '疫病',
            hint: '请选择',
            content: controller.loimia.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.loimiaNameList, selectData: controller.loimia.value, title: '请选择疫病',
                  onConfirm: (value, position) {
                controller.loimiaId = int.parse(controller.loimiaList[position]['value']);
                controller.loimia.value = controller.loimiaNameList[position];
              });
            },
          ),
          CellButton(
            isRequired: false,
            title: '疫苗',
            hint: '请选择',
            content: controller.vaccine.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.vaccineNameList, selectData: controller.vaccine.value, title: '请选择疫苗',
                  onConfirm: (value, position) {
                controller.vaccineId = int.parse(controller.vaccineList[position]['value']);
                controller.vaccine.value = controller.vaccineNameList[position];
              });
            },
          ),
          CellTextField(
            isRequired: false,
            title: '单头剂量',
            hint: '请输入',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: TextEditingController(text: controller.dosage.value.toString().trim()),
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
              controller.dosageController.text = value;
            },
          ),
          controller.typeIndex.value == 0
              ? CellTextField(
                  isRequired: false,
                  title: '头数',
                  hint: '请输入',
                  keyboardType: TextInputType.number,
                  //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
                  controller: TextEditingController(text: controller.cattleCount.value.toString().trim()),
                  focusNode: controller.cattleCountNode,
                  onChanged: (value) {
                    controller.cattleCountController.text = value;
                  },
                )
              : const SizedBox(),
          CellTextField(
            isRequired: false,
            title: '总剂量',
            hint: '请输入',
            titleOptionContent: controller.unit.value,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            controller: TextEditingController(text: controller.totalDosage.value.toString().trim()),
            focusNode: controller.totalDosageNode,
            onChanged: (value) {
              controller.totalDosageController.text = value;
            },
          ),
          CellTextArea(
              isRequired: false,
              title: "备注信息",
              hint: "请输入",
              showBottomLine: false,
              controller: controller.remarkController,
              focusNode: controller.remarkNode,
              onChanged: (value) => {controller.remarkController.text = value}),
        ]));
  }

  // 根据栋舍id匹配栋舍名称
  String matchCowHouseById(String cowHouseId) {
    String cowHouseName = '';
    for (var element in controller.houseList) {
      if (element.id == cowHouseId) {
        cowHouseName = element.name.orEmpty();
        break;
      }
    }
    return cowHouseName;
  }

  // 提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
          text: "提交",
          onPressed: () async {
            controller.commitPreventionData();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // leading设置屏蔽长按返回键的back toast
          leading: WillPopScope(
            onWillPop: () async {
              // 在这里执行返回按钮的操作
              Navigator.of(context).pop();
              return false; // 返回false禁用弹框提示
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // 在这里执行返回按钮的操作
                Navigator.of(context).pop();
              },
            ),
          ),
          title: const Text('防疫'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: PageWrapper(
          config: controller.buildConfig(context),
          child: ListView(children: [
            // 操作信息
            _operationInfo(context),
            // 提交按钮
            _commitButton()
          ]),
        ));
  }
}
