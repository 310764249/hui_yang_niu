import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';

import '../../../services/colors.dart';
import '../../../services/constant.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/alert.dart';
import '../../../widgets/cell_text_field.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../controllers/recipe_detail_controller.dart';

class RecipeDetailView extends GetView<RecipeDetailController> {
  const RecipeDetailView({Key? key}) : super(key: key);

  // 基础信息中的 key：value
  Widget _basicRow(String leftTitle, String leftTitleValue, String rightTitle,
      String rightTitleValue) {
    return Row(
      children: [
        Expanded(
            child: _keyValueView(
          leftTitle,
          leftTitleValue,
        )),
        Expanded(
            child: _keyValueView(
          rightTitle,
          rightTitleValue,
        )),
      ],
    );
  }

  // 基础信息中的 key：value
  Widget _keyValueView(String title, String value) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: title,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
              color: SaienteColors.black80)),
      TextSpan(
          text: value,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w500,
              color: SaienteColors.blackE5))
    ]));
  }

  //配方基本信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      CardTitle(
          title: "配方名称:${controller.argument!.name ?? Constant.placeholder}"),
      //基本信息
      Container(
        padding: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.width(0),
          ScreenAdapter.width(10),
          ScreenAdapter.width(0),
        ),
        child: Column(children: [
          const DividerLine(),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '配方目标：',
            AppDictList.findLabelByCode(controller.pfmbList,
                controller.argument!.individualType.toString()),
            '个体重量(kg)：',
            controller.argument!.weightType.toString(),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '日增重(kg/d)：',
            controller.argument!.dailyGainWeight.toString(),
            '妊娠月份：',
            controller.argument!.gestationMonths.toString(),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '泌乳月份：',
            controller.argument!.calvingMonths.toString(),
            '泌乳量(kg/d)：',
            controller.argument!.milkProduction.toString(),
          ),
          SizedBox(height: ScreenAdapter.height(10)),
        ]),
      ),
    ]);
  }

  //蓝、红按钮
  Widget _compareButton(bool isLeft, String text) {
    return Container(
      height: ScreenAdapter.height(40),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //背景
        color: isLeft ? SaienteColors.blueE5EEFF : SaienteColors.redFFE9E9,
        //设置四周圆角 角度
        borderRadius:
            BorderRadius.all(Radius.circular(ScreenAdapter.height(5.0))),
        //设置四周边框
        border: isLeft
            ? Border.all(
                width: ScreenAdapter.width(0.5),
                color: SaienteColors.blue275CF3)
            : Border.all(
                width: ScreenAdapter.width(0.5),
                color: SaienteColors.redFF3D3D),
      ),
      child: Text(text,
          style: TextStyle(
              color:
                  isLeft ? SaienteColors.blue275CF3 : SaienteColors.redFF3D3D,
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w400)),
    );
  }

  //物质对比
  Widget _compareCell(String title, String left, String right) {
    return MyCard(children: [
      CardTitle(
        title: title,
      ),
      Row(
        children: [
          SizedBox(width: ScreenAdapter.width(10)),
          Expanded(
            child: _compareButton(true, '生成值：$left'),
          ),
          SizedBox(width: ScreenAdapter.width(10)),
          Expanded(
            child: _compareButton(false, '标准值：$right'),
          ),
          SizedBox(width: ScreenAdapter.width(10)),
        ],
      ),
      SizedBox(height: ScreenAdapter.height(10)),
    ]);
  }

  // 单数组显示
  Widget _compareCellSingle(String title, String value) {
    return MyCard(children: [
      CardTitle(
        title: title,
      ),
      Row(
        children: [
          SizedBox(width: ScreenAdapter.width(10)),
          Expanded(
            child: _compareButton(true, value),
          ),
          SizedBox(width: ScreenAdapter.width(10)),
        ],
      ),
      SizedBox(height: ScreenAdapter.height(10)),
    ]);
  }

  //配方基本物质对比
  Widget _compareInfo() {
    return Column(children: [
      _compareCell('干物质需要量(kg/d)', controller.argument!.dm.toString(),
          controller.argument!.baseDM.toString()),
      _compareCell('粗蛋白需要量(kg/d)', controller.argument!.cp.toString(),
          controller.argument!.baseCP.toString()),
      // _compareCell('粗脂肪需要量(kg)', controller.argument!.fat.toString(),
      //     controller.argument!.baseFat.toString()),
      // _compareCell('钙(kg)', controller.argument!.ca.toString(),
      //     controller.argument!.baseCa.toString()),
      // _compareCell('磷(kg)', controller.argument!.p.toString(),
      //     controller.argument!.baseP.toString()),
      _compareCell('维持净能(Mcal/d)', controller.argument!.nEm.toString(),
          controller.argument!.baseNEm.toString()),
      _compareCell('生长净能(Mcal/d)', controller.argument!.nEg.toString(),
          controller.argument!.baseNEg.toString()),
      _compareCell('代谢蛋白(kg/d)', controller.argument!.mp.toString(),
          controller.argument!.baseMP.toString()),
      _compareCellSingle(
          '干物质占比(%)',
          ((controller.argument!.dm! / controller.argument!.weight!) * 100)
              .toStringAsFixed(2)),
    ]);
  }

  //配方信息表头
  Widget _formHeader() {
    return Container(
      height: ScreenAdapter.height(58),
      color: SaienteColors.blueE5EEFF,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text(
              '原料名称',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '原料分类',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '原料需要量',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '干物质需要量',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '干物质含量',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '粗蛋白',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '钙',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '磷',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '维持净能(Mcal/d)',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '生长净能(Mcal/d)',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
            Container(
              color: Colors.white,
              width: ScreenAdapter.width(0.5),
              height: ScreenAdapter.height(58),
            ),
            Expanded(
                child: Text(
              '代谢蛋白(kg/d)',
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500),
            )),
          ]),
    );
  }

  //配方信息表行--手写-不可滑动
  Widget _formBody(FormulaItemModel model) {
    return Container(
      height: ScreenAdapter.height(50),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
            width: ScreenAdapter.height(1), color: SaienteColors.separateLine),
      )),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
                child: Text(
              model.name ?? Constant.placeholder,
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              AppDictList.findLabelByCode(
                  controller.ylflList, model.type.toString()),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.weight.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.demand.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.dm.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.cp.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.ca.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
            Expanded(
                child: Text(
              model.p.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500),
            )),
          ]),
    );
  }

  List<TableRow> _renderList() {
    List titleList = [
      '原料名称',
      '原料分类',
      '原料需要量(kg/d)',
      // '干物质需要量(kg)',
      // '干物质含量(%鲜样)',
      // '粗蛋白(%鲜样)',
      // '钙(%鲜样)',
      // '磷(%鲜样)'
    ];

    List<Widget> header = [];
    for (String title in titleList) {
      header.add(Container(
        height: ScreenAdapter.height(58),
        color: SaienteColors.blueE5EEFF,
        alignment: Alignment.center,
        child: Text(
          title,
          maxLines: 3,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: SaienteColors.blackE5,
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w500),
        ),
      ));
    }

    List<TableRow> list = [];
    list.add(TableRow(children: header));
    for (var i = 0; i < controller.items.length; i++) {
      FormulaItemModel model = controller.items[i];
      list.add(TableRow(children: [
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.name ?? Constant.placeholder,
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            AppDictList.findLabelByCode(
                controller.ylflList, model.type.toString()),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.weight.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        /*
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.demand.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.dm.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.cp.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.ca.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        Container(
          height: ScreenAdapter.height(40),
          alignment: Alignment.center,
          child: Text(
            model.p.toString(),
            maxLines: 3,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500),
          ),
        ),
        */
      ]));
    }
    return list;
  }

  //配方信息表格--Table 实现，可滑动
  Widget _formInfo1() {
    return MyCard(
      children: [
        Obx(() => SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Table(
                defaultColumnWidth: FixedColumnWidth(ScreenAdapter.width(125)),
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                border: TableBorder.all(
                    color: SaienteColors.separateLine, width: 0.5),
                // columnWidths: {
                //   0: FixedColumnWidth(100),
                //   1: FixedColumnWidth(200),
                //   2: FixedColumnWidth(200),
                // },
                children: _renderList(),
              ),
            )),
      ],
    );
  }

  //配方信息表格
  Widget _formInfo() {
    return Obx(() => controller.items.isEmpty
        ? const SizedBox()
        : MyCard(children: [
            Container(
                //height: ScreenAdapter.height(58),
                decoration: BoxDecoration(
                  //设置四周圆角 角度
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                      Radius.circular(ScreenAdapter.width(10.0))),
                ),
                child: ListView.builder(
                  itemCount: controller.items.length + 1,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    if (index == 0) {
                      return _formHeader();
                    } else {
                      FormulaItemModel model = controller.items[index - 1];
                      return _formBody(model);
                    }
                  },
                ))
          ]));
  }

  Widget _dialogButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      TextButton(
          onPressed: () {
            SmartDialog.dismiss();
          },
          child: Text(
            '取消',
            style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(17)),
          )),
      TextButton(
          onPressed: () {
            controller.saveFormula();
          },
          child: Text(
            '保存',
            style: TextStyle(
                color: SaienteColors.blue275CF3,
                fontSize: ScreenAdapter.fontSize(17)),
          )),
    ]);
  }

  // 保存配方弹窗
  void _showSaveDialog() async {
    SmartDialog.show(
      backDismiss: true,
      clickMaskDismiss: true,
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    '保存配方',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: ScreenAdapter.height(10)),
                  CellTextField(
                    isRequired: true,
                    title: '配方名称',
                    hint: '请输入',
                    controller: TextEditingController(
                        text: controller.dialogFormulaName.value.trim()),
                    focusNode: controller.dialogFormulaNameNode,
                    onChanged: (value) {
                      controller.dialogFormulaNameController.text = value;
                    },
                  ),
                  CellTextField(
                    isRequired: false,
                    title: '饲料说明',
                    hint: '请输入',
                    controller: TextEditingController(
                        text: controller.dialogRecipeInstruction.value.trim()),
                    focusNode: controller.dialogRecipeInstructionNode,
                    onChanged: (value) {
                      controller.dialogRecipeInstructionController.text = value;
                    },
                  ),
                  CellTextField(
                    isRequired: false,
                    title: '禁忌事项',
                    hint: '请输入',
                    controller: TextEditingController(
                        text: controller.dialogTabooItem.value.trim()),
                    focusNode: controller.dialogTabooItemNode,
                    onChanged: (value) {
                      controller.dialogTabooItemController.text = value;
                    },
                  ),
                  SizedBox(height: ScreenAdapter.height(20)),
                  _dialogButtons(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('配方详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            // 判断是否显示'保存'按钮
            controller.argument?.id == null
                ? TextButton(
                    child: Text(
                      "保存",
                      style: TextStyle(
                          color: SaienteColors.blue275CF3,
                          fontSize: ScreenAdapter.fontSize(16)),
                    ),
                    onPressed: () {
                      _showSaveDialog();
                    })
                : TextButton(
                    child: Text(
                      "删除",
                      style: TextStyle(
                          color: SaienteColors.blue275CF3,
                          fontSize: ScreenAdapter.fontSize(16)),
                    ),
                    onPressed: () {
                      // 删除配方弹窗
                      Alert.showConfirm(
                        '确定删除此配方吗?',
                        onConfirm: () {
                          controller.deleteFormula();
                        },
                      );
                    })
          ],
        ),
        body: PageWrapper(
          child: controller.argument == null
              ? const EmptyView()
              : ListView(children: [
                  //配方基本信息
                  _operationInfo(context),
                  //配方信息表格
                  _formInfo1(),
                  //物质比例对比
                  _compareInfo(),
                  SizedBox(height: ScreenAdapter.height(10))
                ]),
        ));
  }
}
