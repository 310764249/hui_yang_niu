import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/widgets/cell_text_field.dart';

import '../../../../routes/app_pages.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_button.dart';
import '../../../../widgets/cell_text_area.dart';
import '../../../../widgets/main_button.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../widgets/radio_button_group.dart';
import '../controllers/add_cattle_house_controller.dart';

class AddCattleHouseView extends GetView<AddCattleHouseController> {
  const AddCattleHouseView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      // 栋舍名称
      CellTextField(
        isRequired: true,
        title: '栋舍名称',
        hint: "请输入",
        controller: controller.nameController,
        focusNode: controller.nameNode,
        onChanged: (value) {
          //print(value);
        },
      ),
      CellTextField(
        isRequired: true,
        title: '负责人',
        hint: "请输入",
        controller: controller.dutyController,
        focusNode: controller.dutyNode,
        onChanged: (value) {
          //print(value);
        },
      ),
      // 类型
      RadioButtonGroup(
          isRequired: true,
          title: '类型',
          selectedIndex: controller.curTypeIndex.value,
          items: controller.typeNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updateCurType(value);
          }),
      CellTextField(
        isRequired: true,
        title: '容纳量',
        hint: "请输入",
        keyboardType: TextInputType.number,
        controller: controller.capacityController,
        focusNode: controller.capacityNode,
        onChanged: (value) {
          //print(value);
        },
      ),
      CellButton(
        isRequired: false,
        title: '位置信息',
        hint: "请选择经纬度",
        content: controller.locationInfo.value,
        showArrow: true,
        onPressed: () {
          //判断是否有传参
          Map? para;
          if (ObjectUtil.isNotEmpty(controller.locationInfo.value)) {
            para = {
              'lat': controller.latitude,
              'lng': controller.longitude,
              'address': controller.locationInfo.value
            };
          }
          Get.toNamed(Routes.MAP_LOCATION,arguments: para)?.then((value) {
            controller.handleLocation(value);
          });
        },
      ),
      CellTextArea(
        isRequired: false,
        title: "简介",
        hint: "请输入",
        showBottomLine: false,
        controller: controller.descController,
        focusNode: controller.descNode,
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
          title: const Text('栋舍'),
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
