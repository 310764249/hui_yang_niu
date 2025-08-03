import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_list_argu.dart';
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
import '../controllers/mating_controller.dart';

class MatingView extends GetView<MatingController> {
  const MatingView({Key? key}) : super(key: key);

  //本交
  Widget _natureLayout(context) {
    return CellButton(
      isRequired: false,
      title: '配种公牛',
      hint: "请选择",
      content: controller.bullCode.value,
      onPressed: () {
        Get.toNamed(
          Routes.CATTLELIST,
          arguments: CattleListArgument(
            goBack: true,
            single: true,
            gmList: controller.gList,
            isFilterInvalid: true,
          ),
        )?.then((value) {
          if (ObjectUtil.isEmpty(value)) {
            return;
          }
          //拿到牛只数组，默认 single: true, 单选
          List<Cattle> list = value as List<Cattle>;
          //保存选中的牛只模型
          controller.selectedBull = list.first;
          //更新耳号显示
          controller.updateBullCodeString(list.first.code ?? '');
        });
      },
    );
  }

  //人工 输精
  Widget _humanLayout(context) {
    return Column(
      children: [
        CellButton(
          isRequired: false,
          title: '精液编号',
          hint: "请选择",
          content: controller.selectNumName.value,
          onPressed: () {
            if (controller.numberNameList.isEmpty) {
              Toast.show('暂无精液');
              return;
            }
            Picker.showSinglePicker(
              context,
              controller.numberNameList,
              title: '请选择精液',
              onConfirm: (value, p) {
                //print('longer >>> 返回数据： ${date.year}-${date.month}-${date.day}');
                controller.updateCurNumber(value, p);
              },
            );
          },
        ),
        CellTextField(
          isRequired: false,
          title: '精液份数',
          hint: "请输入",
          keyboardType: TextInputType.number,
          controller: controller.countController,
          focusNode: controller.countNode,
        ),
      ],
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(
      children: [
        const CardTitle(title: "操作信息"),
        CellButton(
          isRequired: true,
          title: '耳号',
          hint: "请选择",
          content: controller.codeString.value,
          showArrow: !controller.isEdit.value,
          onPressed: () {
            Get.toNamed(
              Routes.CATTLELIST,
              arguments: CattleListArgument(
                goBack: true,
                single: true,
                gmList: controller.mList,
                szjdList: controller.szjdListFiltered,
                isFilterInvalid: true,
              ),
            )?.then((value) {
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
        //   title: "配种时间",
        //   hint: "请选择",
        //   content: controller.timesStr.value,
        //   onPressed: () {
        //     Picker.showDatePicker(context, title: '请选择时间', selectDate: controller.timesStr.value, onConfirm: (date) {
        //       controller.updateTimeStr("${date.year}-${date.month?.addZero()}-${date.day?.addZero()}");
        //     });
        //   },
        // ),
        // 类型
        RadioButtonGroup(
          isRequired: true,
          title: '类型',
          selectedIndex: controller.chooseTypeIndex.value,
          items: controller.chooseTypeNameList,
          showBottomLine: true,
          onChanged: (value) {
            // Toast.show('--> $value');
            controller.updateChooseTypeIndex(value);
          },
        ),
        // 类型
        controller.chooseTypeID.value == '1' ? _natureLayout(context) : _humanLayout(context),
        CellButton(
          isRequired: true,
          title: "配种时间",
          hint: "请选择",
          content: controller.timesStr.value,
          onPressed: () {
            Picker.showDatePicker(
              context,
              title: '请选择时间',
              selectDate: controller.timesStr.value,
              onConfirm: (date) {
                controller.updateTimeStr(
                  "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}",
                );
              },
            );
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
        title: const Text('配种'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(
        () => PageWrapper(
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
      ),
    );
  }
}
