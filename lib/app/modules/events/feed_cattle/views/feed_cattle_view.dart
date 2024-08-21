import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/modules/events/feed_cattle/select_feeds_view.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../../services/colors.dart';
import '../../../../widgets/cell_text_field.dart';
import '../../../../widgets/radio_button_group.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/picker.dart';
import '../../../../services/ex_int.dart';
import '../controllers/feed_cattle_controller.dart';

class FeedCattleView extends GetView<FeedCattleController> {
  const FeedCattleView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      CellButton(
        isRequired: true,
        title: "栋舍",
        hint: "请选择",
        showBottomLine: true,
        content: controller.selectedHouseName.value,
        showArrow: !controller.isEdit.value,
        onPressed: () {
          Picker.showSinglePicker(context, controller.houseNameList, title: '请选择栋舍', onConfirm: (value, p) {
            controller.updateCurCowHouse(value, p);
          });
        },
      ),
      CellButton(
        isRequired: true,
        title: "栋舍牛只数量",
        showArrow: false,
        content: controller.cowHouseNum.value,
      ),
      CellButton(
        isRequired: true,
        title: "选择配方",
        hint: "请选择",
        showBottomLine: true,
        content: controller.curFeedsType.value,
        onPressed: () {
          if (controller.selectedHouseName.value.isEmpty || controller.selectedHouseName.value == '0') {
            Toast.show('请选择栋舍');
            return;
          }
          if (controller.cowHouseNum.value == '0') {
            Toast.show('栋舍中没有牛只');
            return;
          }
          SelectFeedsView.push(context).then(
            (value) {
              if (value != null) {
                Log.d(value.toJson().toString());
                controller.updateFormulaModel(value);
              }
            },
          );
          // if (controller.feedsTypeList.isEmpty) {
          //   return;
          // }
          // Picker.showSinglePicker(
          //   context,
          //   controller.feedsTypeNameList,
          //   title: '请选择饲料',
          //   onConfirm: (value, p) {
          //     controller.updateCurFeedsType(value, p);
          //   },
          // );
        },
      ),
      CellTextField(
        isRequired: true,
        title: '校正饲喂量',
        hint: '请输入',
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [
          //只能输入金额
          FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,1}')),
        ],
        controller: controller.countController,
        focusNode: controller.countNode,
      ),
      // CellButton(
      //   isRequired: true,
      //   title: "单头饲喂量（kg）",
      //   showArrow: false,
      //   content: controller.feedsSingle.value,
      // ),
      CellButton(
        isRequired: true,
        title: "饲喂时间",
        hint: "请选择",
        showBottomLine: true,
        content: controller.timesStr.value,
        onPressed: () {
          Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.timesStr.value, onConfirm: (date) {
            controller.updateSeldate("${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
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
          title: const Text('饲喂'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => PageWrapper(
              config: controller.buildConfig(context),
              child: ListView(children: [
                //操作信息
                _operationInfo(context),
                //计算饲喂量
                ObxValue<RxList<FormulaItemModel>>(
                  (value) {
                    if (value.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return MyCard(
                      children: [
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(top: ScreenAdapter.height(20)),
                          child: Text(
                            '${controller.selectFormulaModel?.name ?? ''}（头数：${controller.cowHouseNum.value}）',
                            style: TextStyle(
                              color: SaienteColors.blackE5,
                              fontSize: ScreenAdapter.fontSize(16),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        for (var item in value)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                            child: Row(
                              children: [
                                Text(
                                  '${item.name ?? ''}：',
                                  style: TextStyle(
                                    color: SaienteColors.blackE5,
                                    fontSize: ScreenAdapter.fontSize(14),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Text(
                                  '${((item.weight ?? 0) * num.parse(controller.cowHouseNum.value) * num.parse(controller.countController.text)).toStringAsFixed(2)} = '
                                  '${(item.weight ?? 0)}kg * '
                                  '${controller.cowHouseNum.value}头 * '
                                  '${controller.countController.text}',
                                  style: TextStyle(
                                    color: SaienteColors.black333333,
                                    fontSize: ScreenAdapter.fontSize(14),
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    );
                  },
                  controller.modelList,
                ),
                //提交按钮
                _commitButton()
              ]),
            )));
  }
}
