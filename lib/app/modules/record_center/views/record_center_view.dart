import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';

import '../../../services/screenAdapter.dart';
import '../../../widgets/cascadeTreePicker.dart';
import '../../../widgets/cell_button.dart';
import '../../../widgets/cell_text_area.dart';
import '../../../widgets/cell_text_field.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/radio_button_group.dart';
import '../controllers/record_center_controller.dart';

class RecordCenterView extends GetView<RecordCenterController> {
  const RecordCenterView({Key? key}) : super(key: key);

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "操作信息"),
      RadioButtonGroup(
          isRequired: true,
          title: '牛场性质',
          selectedIndex: controller.curPassIndex.value,
          items: controller.passNameList,
          showBottomLine: true,
          onChanged: (value) {
            controller.updatePass(value);
          }),
      CellTextField(
        isRequired: true,
        title: '养殖户名称',
        hint: '请输入',
        controller: controller.nameController,
        focusNode: controller.nameNode,
        onChanged: (value) {
          // controller.cost = value;
        },
      ),
      CellTextField(
        isRequired: true,
        title: '养殖户编码',
        hint: '请输入',
        controller: controller.codeController,
        focusNode: controller.codeNode,
        onChanged: (value) {
          // controller.cost = value;
        },
      ),
      CellButton(
        isRequired: true,
        title: "所属机构",
        hint: "请选择",
        content: controller.selOrgName.value,
        onPressed: () {
          CascadeTreePicker.show(context,
              data: controller.orgTreeData,
              labelKey: 'label',
              title: '请选择机构',
              splitString: ' / ', clickCallBack: (selectItem, selectArr) {
            print(selectItem);
            // print(selectArr);
            controller.updateOrgName(selectItem);
          });
        },
      ),
      CellButton(
        isRequired: true,
        title: "所属辖区",
        hint: "请选择",
        content: controller.selAreaName.value,
        onPressed: () {
          CascadeTreePicker.show(context,
              data: controller.areaTreeData,
              labelKey: 'label',
              title: '请选择辖区',
              splitString: ' / ', clickCallBack: (selectItem, selectArr) {
            print(selectItem);
            // print(selectArr);
            controller.updateAreaName(selectItem);
          });
        },
      ),
      CellTextField(
        isRequired: true,
        title: '联系人',
        hint: '请输入',
        controller: controller.peopleController,
        focusNode: controller.peopleNode,
        onChanged: (value) {
          // controller.cost = value;
        },
      ),
      CellTextField(
        isRequired: true,
        title: '联系电话',
        hint: '请输入',
        keyboardType: TextInputType.number,
        controller: controller.phoneController,
        focusNode: controller.phoneNode,
        onChanged: (value) {
          // controller.cost = value;
        },
      ),
      CellButton(
        isRequired: true,
        title: "地址",
        hint: "请选择",
        content: controller.selAddressName.value,
        onPressed: () {
          //判断是否有传参
          Map? para;
          if (ObjectUtil.isNotEmpty(controller.selAddressName.value)) {
            para = {
              'lat': controller.lat,
              'lng': controller.lng,
              'address': controller.selAddressName.value
            };
          }
          Get.toNamed(Routes.MAP_LOCATION, arguments: para)?.then((value) {
            controller.updateAddress(value);
          });
        },
      ),
      CellTextArea(
        isRequired: false,
        title: "养殖户简介",
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
          title: const Text('备案中心'),
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
            )));
  }
}
