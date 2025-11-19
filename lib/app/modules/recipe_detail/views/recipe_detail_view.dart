import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/services/tools.dart';
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
  Widget _basicRow(
    String leftTitle,
    String leftTitleValue,
    String rightTitle,
    String rightTitleValue,
  ) {
    return Row(
      children: [
        Expanded(child: _keyValueView(leftTitle, leftTitleValue)),
        Expanded(child: _keyValueView(rightTitle, rightTitleValue)),
      ],
    );
  }

  // 基础信息中的 key：value
  Widget _keyValueView(String title, String value) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.centerLeft,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: title,
              style: TextStyle(fontSize: ScreenAdapter.fontSize(14), color: SaienteColors.black80),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(14),
                fontWeight: FontWeight.w500,
                color: SaienteColors.blackE5,
              ),
            ),
          ],
        ),
        maxLines: 1,
      ),
    );
  }

  //配方基本信息
  Widget _operationInfo(context) {
    return MyCard(
      children: [
        CardTitle(title: "配方名称:${controller.argument!.name ?? Constant.placeholder}"),
        //基本信息
        Container(
          padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(10),
            ScreenAdapter.width(0),
            ScreenAdapter.width(10),
            ScreenAdapter.width(0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const DividerLine(),
              SizedBox(height: ScreenAdapter.height(10)),
              ...() {
                if (controller.argument!.individualType == 1) {
                  return [
                    _basicRow(
                      '配方目标：',
                      AppDictList.findLabelByCode(
                        controller.pfmbList,
                        controller.argument!.individualType.toString(),
                      ),
                      '妊娠月份：',
                      controller.argument!.gestationMonths.toString(),
                    ),
                    SizedBox(height: ScreenAdapter.height(10)),
                    _basicRow('存栏：', controller.argument!.cowCount.toString(), '', ''),
                  ];
                }
                if (controller.argument!.individualType == 3) {
                  return [
                    _basicRow(
                      '配方目标：',
                      AppDictList.findLabelByCode(
                        controller.pfmbList,
                        controller.argument!.individualType.toString(),
                      ),
                      '哺乳月份：',
                      controller.argument!.calvingMonths.toString(),
                    ),
                    SizedBox(height: ScreenAdapter.height(10)),
                    _basicRow('存栏：', controller.argument!.cowCount.toString(), '', ''),
                  ];
                }
                if (controller.argument!.individualType == 2) {
                  return [
                    _basicRow(
                      '配方目标：',
                      AppDictList.findLabelByCode(
                        controller.pfmbList,
                        controller.argument!.individualType.toString(),
                      ),
                      '个体重量(kg)：',
                      controller.argument!.weightType.toString(),
                    ),
                    SizedBox(height: ScreenAdapter.height(10)),
                    _basicRow(
                      '妊娠月份：',
                      controller.argument!.gestationMonths.toString(),
                      '存栏：',
                      controller.argument!.cowCount.toString(),
                      // '妊娠月份：',
                      // controller.argument!.gestationMonths.toString(),
                    ),
                  ];
                }
                return [
                  _basicRow(
                    '配方目标：',
                    AppDictList.findLabelByCode(
                      controller.pfmbList,
                      controller.argument!.individualType.toString(),
                    ),
                    '个体重量(kg)：',
                    controller.argument!.weightType.toString(),
                  ),
                  SizedBox(height: ScreenAdapter.height(10)),
                  _basicRow(
                    '日增重(kg/d)：',
                    () {
                      String weight = controller.argument!.dailyGainWeight.toString();
                      String? label = Constant.gtKHMap['${weight}kg'];
                      return label == null ? weight : '${weight}kg$label ';
                    }(),
                    '存栏：',
                    controller.argument!.cowCount.toString(),
                    // '妊娠月份：',
                    // controller.argument!.gestationMonths.toString(),
                  ),
                ];
              }(),
              SizedBox(height: ScreenAdapter.height(20)),
              // _basicRow(
              //   '泌乳月份：',
              //   controller.argument!.calvingMonths.toString(),
              //   '泌乳量(kg/d)：',
              //   controller.argument!.milkProduction.toString(),
              // ),
              // SizedBox(height: ScreenAdapter.height(10)),
            ],
          ),
        ),
      ],
    );
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
        borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(5.0))),
        //设置四周边框
        border:
            isLeft
                ? Border.all(width: ScreenAdapter.width(0.5), color: SaienteColors.blue275CF3)
                : Border.all(width: ScreenAdapter.width(0.5), color: SaienteColors.redFF3D3D),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isLeft ? SaienteColors.blue275CF3 : SaienteColors.redFF3D3D,
          fontSize: ScreenAdapter.fontSize(14),
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  //物质对比
  Widget _compareCell(String title, String left, String right) {
    return MyCard(
      children: [
        CardTitle(title: title),
        Row(
          children: [
            SizedBox(width: ScreenAdapter.width(10)),
            Expanded(child: _compareButton(true, '生成值：$left')),
            SizedBox(width: ScreenAdapter.width(10)),
            Expanded(child: _compareButton(false, '参考值：$right')),
            SizedBox(width: ScreenAdapter.width(10)),
          ],
        ),
        SizedBox(height: ScreenAdapter.height(10)),
      ],
    );
  }

  // 单数组显示
  Widget _compareCellSingle(String title, String value) {
    return MyCard(
      children: [
        CardTitle(title: title),
        Row(
          children: [
            SizedBox(width: ScreenAdapter.width(10)),
            Expanded(child: _compareButton(true, value)),
            SizedBox(width: ScreenAdapter.width(10)),
          ],
        ),
        SizedBox(height: ScreenAdapter.height(10)),
      ],
    );
  }

  //配方基本物质对比
  Widget _compareInfo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.onTapCompare();
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: SaienteColors.blue2559F3.withAlpha(20),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(width: ScreenAdapter.height(1), color: SaienteColors.blue2559F3),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  '营养成分详情',
                  style: TextStyle(color: SaienteColors.blue2559F3, fontSize: 16),
                ),
                ValueListenableBuilder(
                  valueListenable: controller.compareExpanded,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      transform: Matrix4.rotationZ(controller.compareExpanded.value ? -pi : 0),
                      transformAlignment: Alignment.center,
                      child: const Icon(
                        Icons.keyboard_double_arrow_down,
                        color: SaienteColors.blue2559F3,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
          valueListenable: controller.compareExpanded,
          builder: (context, value, child) {
            return AnimatedContainer(
              height: value ? 130 * 12 : 0,
              duration: const Duration(milliseconds: 400),
              child: child!,
            );
          },
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: // 13个营养指标展示
                  [
                _compareCell(
                  '干物质采食量(kg/d)',
                  controller.argument!.dm.toString(),
                  controller.argument!.baseDM.toString(),
                ),
                _compareCell(
                  '粗料比(%)',
                  controller.argument!.roughagesPercent.toString(),
                  controller.argument!.baseRoughagesPercent.toString(),
                ),
                _compareCell(
                  '粗蛋白需要量(kg/d)',
                  controller.argument!.cp.toString(),
                  controller.argument!.baseCP.toString(),
                ),
                _compareCell(
                  '瘤胃降解蛋白(kg/d)',
                  controller.argument!.rdp.toString(),
                  controller.argument!.baseRDP.toString(),
                ),
                _compareCell(
                  '瘤胃非降解蛋白(kg/d)',
                  controller.argument!.rup.toString(),
                  controller.argument!.baseRUP.toString(),
                ),
                _compareCell(
                  '代谢蛋白(kg/d)',
                  controller.argument!.mp.toString(),
                  controller.argument!.baseMP.toString(),
                ),
                _compareCell(
                  '代谢赖氨酸(kg/d)',
                  controller.argument!.mLys.toString(),
                  controller.argument!.baseMLys.toString(),
                ),
                _compareCell(
                  '代谢蛋氨酸(kg/d)',
                  controller.argument!.mMet.toString(),
                  controller.argument!.baseMMet.toString(),
                ),
                _compareCell(
                  '代谢能(Mcal/d)',
                  controller.argument!.me.toString(),
                  controller.argument!.baseME.toString(),
                ),
                _compareCell(
                  '维持净能(Mcal/d)',
                  controller.argument!.nEm.toString(),
                  controller.argument!.baseNEm.toString(),
                ),
                _compareCell(
                  '增重净能(Mcal/d)',
                  controller.argument!.nEg.toString(),
                  controller.argument!.baseNEg.toString(),
                ),
                _compareCell(
                  '钙(kg/d)',
                  controller.argument!.ca.toString(),
                  controller.argument!.baseCa.toString(),
                ),
                _compareCell(
                  '磷(kg/d)',
                  controller.argument!.p.toString(),
                  controller.argument!.baseP.toString(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //配方信息表行--手写-不可滑动
  Widget _formBody(FormulaItemModel model) {
    return Container(
      height: ScreenAdapter.height(50),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: ScreenAdapter.height(1), color: SaienteColors.separateLine),
        ),
      ),
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
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              AppDictList.findLabelByCode(controller.ylflList, model.type.toString()),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.weight.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.demand.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.dm.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.cp.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.ca.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              model.p.toString(),
              maxLines: 3,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blackE5,
                fontSize: ScreenAdapter.fontSize(13),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TableRow> _renderList() {
    List titleList = ['粗饲料', '需要量(kg/d)', '占比%', '成本(元)'];

    List<Widget> header =
        titleList.map((title) {
          return Container(
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
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();

    List<TableRow> list = [];
    list.add(TableRow(children: header));

    final cowCount = controller.isFromCreate ? (controller.argument?.cowCount ?? 1) : 1;

    // ✅ 先算总重量、总成本
    double totalWeight = 0;
    double totalCost = 0;
    for (var model in controller.roughages) {
      final weight = (model.weight ?? 0) * cowCount;
      final cost = (model.price ?? 0) * cowCount;
      totalWeight += weight;
      totalCost += cost;
    }

    // ✅ 再计算每行数据
    for (var model in controller.roughages) {
      final weight = (model.weight ?? 0) * cowCount;
      final cost = (model.price ?? 0) * cowCount;
      final percent = totalWeight == 0 ? 0 : (weight / totalWeight * 100);

      list.add(
        TableRow(
          children: [
            _cellText(model.name ?? Constant.placeholder),
            _cellText(Tools.formatNumber(weight.toString())),
            _cellText('${Tools.formatNumber(percent.toStringAsFixed(2))}%'),
            _cellText(Tools.formatNumber(cost.toString())),
          ],
        ),
      );
    }

    // ✅ 添加合计行
    list.add(
      TableRow(
        children: [
          _cellText('合计', isBold: true),
          _cellText(Tools.formatNumber(totalWeight.toString()), isBold: true),
          const SizedBox(),
          _cellText(Tools.formatNumber(totalCost.toString()), isBold: true),
        ],
      ),
    );

    return list;
  }

  /// ✅ 提取公共单元格方法
  Widget _cellText(String text, {bool isBold = false}) {
    return Container(
      height: ScreenAdapter.height(40),
      alignment: Alignment.center,
      child: Text(
        text,
        maxLines: 3,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: SaienteColors.blackE5,
          fontSize: ScreenAdapter.fontSize(13),
          fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
        ),
      ),
    );
  }

  List<TableRow> _concentratedFeedList() {
    List titleList = ['精饲料', '需要量(kg/d)', '占比%', '成本(元)'];

    // Header
    List<Widget> header =
        titleList.map((title) {
          return Container(
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
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }).toList();

    List<TableRow> list = [];
    list.add(TableRow(children: header));

    final cowCount = controller.isFromCreate ? (controller.argument?.cowCount ?? 1) : 1;

    double totalWeight = 0;
    double totalCost = 0;

    // ✅ 第一次遍历计算总数
    for (var model in controller.energyFeed) {
      totalWeight += (model.weight ?? 0) * cowCount;
      totalCost += (model.price ?? 0) * cowCount;
    }

    // ✅ 第二次遍历构建表格
    for (var model in controller.energyFeed) {
      final weight = (model.weight ?? 0) * cowCount;
      final cost = (model.price ?? 0) * cowCount;
      final percent = totalWeight == 0 ? 0 : (weight / totalWeight * 100);

      list.add(
        TableRow(
          children: [
            _cellText(model.name ?? Constant.placeholder),
            _cellText(Tools.formatNumber(weight.toString())),
            _cellText('${Tools.formatNumber(percent.toStringAsFixed(2))} %'),
            _cellText(Tools.formatNumber(cost.toString())),
          ],
        ),
      );
    }

    // ✅ 合计行
    list.add(
      TableRow(
        children: [
          _cellText('合计', isBold: true),
          _cellText(Tools.formatNumber(totalWeight.toString()), isBold: true),
          const SizedBox(),
          _cellText(Tools.formatNumber(totalCost.toString()), isBold: true),
        ],
      ),
    );

    return list;
  }

  //配方信息表格--Table 实现，可滑动
  Widget _formInfo1() {
    return MyCard(
      children: [
        Obx(
          () => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const ClampingScrollPhysics(),
            child: Column(
              children: [
                Table(
                  defaultColumnWidth: FixedColumnWidth(ScreenAdapter.width(90)),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: SaienteColors.separateLine, width: 0.5),
                  children: _renderList(),
                ),
                Table(
                  defaultColumnWidth: FixedColumnWidth(ScreenAdapter.width(90)),
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(color: SaienteColors.separateLine, width: 0.5),
                  children: _concentratedFeedList(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  //配方信息表格
  Widget _formInfo() {
    return Obx(
      () =>
          controller.items.isEmpty
              ? const SizedBox()
              : MyCard(
                children: [
                  Container(
                    //height: ScreenAdapter.height(58),
                    decoration: BoxDecoration(
                      //设置四周圆角 角度
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.width(10.0))),
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
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _dialogButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        TextButton(
          onPressed: () {
            SmartDialog.dismiss();
          },
          child: Text(
            '取消',
            style: TextStyle(color: SaienteColors.blackE5, fontSize: ScreenAdapter.fontSize(17)),
          ),
        ),
        TextButton(
          onPressed: () {
            controller.saveFormula();
          },
          child: Text(
            '保存',
            style: TextStyle(color: SaienteColors.blue275CF3, fontSize: ScreenAdapter.fontSize(17)),
          ),
        ),
      ],
    );
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
                  const Text('保存配方', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
                  SizedBox(height: ScreenAdapter.height(10)),
                  CellTextField(
                    isRequired: true,
                    title: '配方名称',
                    hint: '请输入',
                    controller: TextEditingController(
                      text: controller.dialogFormulaName.value.trim(),
                    ),
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
                      text: controller.dialogRecipeInstruction.value.trim(),
                    ),
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
                      text: controller.dialogTabooItem.value.trim(),
                    ),
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
                    fontSize: ScreenAdapter.fontSize(16),
                  ),
                ),
                onPressed: () {
                  _showSaveDialog();
                },
              )
              : TextButton(
                child: Text(
                  "删除",
                  style: TextStyle(
                    color: SaienteColors.blue275CF3,
                    fontSize: ScreenAdapter.fontSize(16),
                  ),
                ),
                onPressed: () {
                  // 删除配方弹窗
                  Alert.showConfirm(
                    '确定删除此配方吗?',
                    onConfirm: () {
                      controller.deleteFormula();
                    },
                  );
                },
              ),
        ],
      ),
      body: PageWrapper(
        child:
            controller.argument == null
                ? const EmptyView()
                : ListView(
                  children: [
                    //配方基本信息
                    _operationInfo(context),
                    //配方信息表格
                    _formInfo1(),
                    //物质比例对比
                    _compareInfo(),
                    SizedBox(height: ScreenAdapter.height(10)),
                  ],
                ),
      ),
    );
  }
}
