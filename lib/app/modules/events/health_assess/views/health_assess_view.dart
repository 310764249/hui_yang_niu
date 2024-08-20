import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
import '../../../../routes/app_pages.dart';
import '../../../../services/ex_int.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/assess_edit_cow_view.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/picker.dart';
import '../controllers/health_assess_controller.dart';

///
/// 健康评估
///
class HealthAssessView extends GetView<HealthAssessController> {
  const HealthAssessView({Key? key}) : super(key: key);

  // 操作信息
  Widget _operationInfo(context) {
    return Obx(() => MyCard(children: [
          const CardTitle(title: "操作信息"),
          CellButton(
            isRequired: true,
            title: '耳号',
            hint: controller.isEdit.value ? '' : "请选择",
            content: controller.codeString.value,
            showArrow: true,
            onPressed: () {
              //取出公母数组
              var gmList = List.from(AppDictList.searchItems('gm') ?? []);
              //保留母牛
              gmList.removeWhere((item) => item['label'] != '母');
              var szjdList = List.from(AppDictList.searchItems('szjd') ?? []);
              var lst = [];
              szjdList.forEach((element) {
                String label = element['label'];
                if (label.contains("公牛") || label.contains("死亡") || label.contains("销售") || label.contains("淘汰")) {
                } else {
                  lst.add(element);
                }
              });
              Get.toNamed(Routes.CATTLELIST,
                      arguments: CattleListArgument(goBack: true, single: true, gmList: gmList, szjdList: lst))
                  ?.then((value) {
                if (ObjectUtil.isEmpty(value)) {
                  return;
                }
                // 拿到牛只数组，默认 single: true, 单选
                List<Cattle> list = value as List<Cattle>;
                // 保存选中的牛只模型
                controller.setSelectedCow(list.first);
                // 更新耳号显示
                controller.updateCodeString(list.first.code ?? '');
              });
            },
          ),
          CellTextField(
            isRequired: true,
            title: '日龄',
            hint: '请输入',
            keyboardType: TextInputType.number,
            //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            controller: controller.ageController,
            focusNode: controller.ageNode,
            onComplete: () {
              controller.ageController.text = int.parse(controller.ageController.text.trim()).toString();
            },
          ),
          CellTextField(
            isRequired: true,
            title: '胎次',
            hint: '请输入',
            keyboardType: TextInputType.number,
            //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            controller: controller.calvCountController,
            focusNode: controller.calvCountNode,
            onComplete: () {
              controller.calvCountController.text = int.parse(controller.calvCountController.text.trim()).toString();
            },
          ),
          CellTextField(
              isRequired: true,
              title: '历次疾病名称',
              hint: '请输入',
              //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
              controller: controller.illnessController,
              focusNode: controller.illnessNode),
          CellTextField(
            isRequired: true,
            title: '诊疗次数',
            hint: '请输入',
            keyboardType: TextInputType.number,
            //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            controller: controller.treatCountController,
            focusNode: controller.treatCountNode,
            onComplete: () {
              controller.treatCountController.text = int.parse(controller.treatCountController.text.trim()).toString();
            },
          ),
          CellButton(
            isRequired: true,
            title: '健康评估',
            hint: '请选择',
            content: controller.healthAssess.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.healthAssessNameList,
                  selectData: controller.healthAssess.value, title: '请选择', onConfirm: (value, position) {
                controller.healthAssessId = int.parse(controller.healthAssessList[position]['value']);
                controller.healthAssess.value = controller.healthAssessNameList[position];
              });
            },
          ),
          CellButton(
              isRequired: true,
              title: '评估日期',
              hint: '请选择',
              content: controller.assessTime.value,
              onPressed: () {
                Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.assessTime.value, onConfirm: (date) {
                  controller.assessTime.value = "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}";
                });
              }),
          CellTextArea(
              isRequired: false,
              title: "备注信息",
              hint: "请输入",
              showBottomLine: false,
              controller: controller.remarkController,
              focusNode: controller.remarkNode),
          // AssessEditCowView(controller.selectedCow),
        ]));
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
          title: const Text('健康评估'),
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
