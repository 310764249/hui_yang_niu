import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/raw_material.dart';
import 'package:intellectual_breed/app/modules/recipe_create/views/select_recipe.dart';
import 'package:intellectual_breed/app/modules/recipe_verify/recipe_verify_controller.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/cell_button.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../models/formula.dart';
import '../../network/httpsClient.dart';
import '../../services/screenAdapter.dart';
import '../../widgets/my_card.dart';
import '../../widgets/picker.dart';
import 'feed_details_info_view.dart';

class RecipeVerifyPage extends GetView<RecipeVerifyController> {
  const RecipeVerifyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: GetBuilder<RecipeVerifyController>(
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text('验证配方'),
              centerTitle: true,
              actions: [
                if (controller.formulaModel != null)
                  TextButton(
                    onPressed: () {
                      if (ObjectUtil.isNotEmpty(controller.formulaModel)) {
                        Get.toNamed(Routes.RECIPE_DETAIL, arguments: controller.formulaModel);
                      }
                    },
                    child: const Text('保存配方'),
                  ),
              ],
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('配方基本信息'),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TextButton(
                        onPressed: () {
                          controller.selectHaveFormula(true);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              controller.isSelectExistFormula
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.circle_outlined,
                            ),
                            const Text(
                              '选择已有配方',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.selectHaveFormula(false);
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              !controller.isSelectExistFormula
                                  ? Icons.radio_button_checked_outlined
                                  : Icons.circle_outlined,
                            ),
                            const Text(
                              '手动输入配方',
                              style: TextStyle(fontSize: 16, color: Colors.black87),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (controller.isSelectExistFormula)
                          CellButton(
                            isRequired: true,
                            title: '选择配方',
                            content:
                                controller.formulaModelExist == null
                                    ? '请选择配方'
                                    : controller.formulaModelExist?.name ?? '',
                            onPressed: () async {
                              final result = await Get.toNamed(
                                Routes.RECIPE,
                                arguments: {'isPick': true},
                              );

                              if (result != null && result is FormulaModel) {
                                controller.currentFormula(result);
                              }
                            },
                          ),
                        CellButton(
                          isRequired: true,
                          title: '牛只类型',
                          content: controller.currentLabel,
                          onPressed: () {
                            if (controller.gtlxList.isEmpty) {
                              Toast.show('配方目标类型获取失败');
                              return;
                            }
                            Picker.showSinglePicker(
                              context,
                              controller.labels,
                              selectData: controller.currentItem['label'],
                              title: '请选择个体类型',
                              onConfirm: (value, position) {
                                controller.currentCowType(value, position);
                              },
                            );
                          },
                        ),
                        if (controller.showNuWeight)
                          CellButton(
                            title: '牛只重量',
                            content: controller.nuWeightLabel,
                            onPressed: () {
                              Picker.showSinglePicker(
                                context,
                                controller.nuWeightLabels,
                                selectData: controller.nuWeightLabel,
                                title: '请选择牛只重量',
                                onConfirm: (value, position) {
                                  // setState(() {
                                  //   currentNuWeight = nuWeight[position];
                                  // });
                                  controller.currentWeight(value, position);
                                },
                              );
                            },
                            isRequired: true,
                          ),
                        if (controller.showNuDailyWeight)
                          CellButton(
                            title: '牛只日增重',
                            content: controller.nuDailyWeight,
                            onPressed: () {
                              if (controller.currentNuWeight == null) {
                                Toast.show('请选择牛只重量');
                                return;
                              }
                              final Map<int, List<double>> weightRangeMap = {
                                240: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                                280: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                                320: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                                360: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                400: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                440: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                480: [0.0, 1.0, 1.2, 1.4, 1.6, 1.8],
                                520: [0.0, 1.0, 1.2, 1.4, 1.6, 1.8],
                                560: [0.0, 1.0, 1.2, 1.4, 1.6, 1.8],
                                600: [0.0, 1.0, 1.2, 1.4, 1.6, 1.8],
                                640: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                680: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                720: [0.0, 0.8, 1.0, 1.2, 1.4, 1.6],
                                760: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                                800: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                                840: [0.0, 0.6, 0.8, 1.0, 1.2, 1.4],
                              };

                              final weightStr = controller.nuWeightLabel.replaceAll('kg', '');
                              debugPrint('当前选择: $weightStr');
                              final weight = int.tryParse(weightStr);

                              if (weight != null && weightRangeMap.containsKey(weight)) {
                                final range = weightRangeMap[weight]!;

                                // 统一格式：整数显示 "1kg"，小数显示 "1.2kg"
                                final filteredList =
                                    range.map((e) {
                                      return e % 1 == 0 ? '${e.toInt()}kg' : '${e}kg';
                                    }).toList();

                                if (filteredList.isEmpty) {
                                  debugPrint('当前体重无可选日增重区间');
                                  return;
                                }

                                // 弹出选择器
                                Picker.showSinglePicker(
                                  context,
                                  filteredList,
                                  selectData: controller.nuDailyWeight,
                                  title: '请选择日增重',
                                  onConfirm: (value, position) {
                                    controller.currentDailyWeight(value, position, filteredList);
                                  },
                                );
                              } else {
                                debugPrint('未找到对应体重的区间范围');
                              }
                            },
                            isRequired: true,
                          ),
                        if (controller.showNuPregnancyMonth)
                          CellButton(
                            title: '妊娠月份',
                            isRequired: true,
                            content: controller.rsyfLabel,
                            onPressed: () {
                              Picker.showSinglePicker(
                                context,
                                controller.rsyfLabels,
                                selectData: controller.rsyfLabel,
                                title: '请选择妊娠月份',
                                onConfirm: (value, position) {
                                  // setState(() {
                                  //   currentRsyf = rsyfList[position];
                                  // });
                                  controller.currentRsyfVoid(value, position);
                                },
                              );
                            },
                          ),
                        if (controller.showNuBreastMonth)
                          CellButton(
                            title: '哺乳月份',
                            content: controller.rsyfLabel,
                            isRequired: true,
                            onPressed: () {
                              Picker.showSinglePicker(
                                context,
                                controller.rsyfLabels,
                                selectData: controller.rsyfLabel,
                                title: '请选择哺乳月份',
                                onConfirm: (value, position) {
                                  // setState(() {
                                  //   currentRsyf = rsyfList[position];
                                  // });
                                  controller.currentRsyfVoid(value, position);
                                },
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      '原料组成（kg）',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                  // ...controller.addRawMaterialList.map((e) {
                  //   return _RawMaterialInfoItem(
                  //     rawMaterial: e,
                  //     onTapDelete: () {
                  //       // setState(() {
                  //       //   addRawMaterialList.remove(e);
                  //       // });
                  //       controller.removeRawMaterial(e);
                  //     },
                  //   );
                  // }),
                  FeedDetailsInfoView(
                    title: '粗饲料总量',
                    totalWeightController: controller.czlzlController,
                    list: controller.addRawMaterialList,
                    onDelete: (e) {
                      controller.removeRawMaterial(e);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ).copyWith(top: 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          //列表移除已经添加的原料
                          List<RawMaterial> showRawMaterialLabels = List.from(
                            controller.rawMaterialList
                                .where((element) => element.type == 1)
                                .toList(),
                          );
                          for (var o in controller.addRawMaterialList) {
                            showRawMaterialLabels.remove(o);
                          }
                          Alert.showMultiPicker(
                            showRawMaterialLabels.map((e) => e.name).toList(),
                            context,

                            title: '请选择要添加的原料',
                            onConfirm: (List selected) {
                              final List<RawMaterial> addRawMaterialList = [];
                              for (var i = 0; i < selected.length; i++) {
                                addRawMaterialList.add(showRawMaterialLabels[selected[i]]);
                              }
                              controller.addRawMaterialAll(addRawMaterialList);
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SaienteColors.dark_app_main.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: const Text(
                            '+粗饲料',
                            style: TextStyle(fontSize: 14, color: SaienteColors.dark_app_main),
                          ),
                        ),
                      ),
                    ),
                  ),
                  FeedDetailsInfoView(
                    title: '精饲料总量',
                    totalWeightController: controller.jzlzlController,
                    list: controller.addFeedRawMaterialList,
                    onDelete: (e) {
                      controller.removeFeedRawMaterial(e);
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ).copyWith(top: 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(bottom: Radius.circular(12)),
                    ),
                    child: Center(
                      child: TextButton(
                        onPressed: () {
                          //列表移除已经添加的原料
                          List<RawMaterial> showRawMaterialLabels = List.from(
                            controller.rawMaterialList
                                .where((element) => element.type != 1)
                                .toList(),
                          );
                          for (var o in controller.addRawMaterialList) {
                            showRawMaterialLabels.removeWhere((e) => o.name == e.name);
                          }
                          Alert.showMultiPicker(
                            showRawMaterialLabels.map((e) => e.name).toList(),
                            context,

                            title: '请选择要添加的原料',
                            onConfirm: (List selected) {
                              final List<RawMaterial> addRawMaterialList = [];
                              for (var i = 0; i < selected.length; i++) {
                                addRawMaterialList.add(showRawMaterialLabels[selected[i]]);
                              }
                              controller.addFeedRawMaterialAll(addRawMaterialList);
                            },
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: SaienteColors.dark_app_main.withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: const Text(
                            '+精饲料',
                            style: TextStyle(fontSize: 14, color: SaienteColors.dark_app_main),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(SaienteColors.appMain),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        controller.verifyRecipe();
                      },
                      child: Center(
                        child: Text(
                          '验证配方',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(17),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (controller.formulaModel != null)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: SaienteColors.appMain.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                    '单头每日成本',
                                    style: TextStyle(
                                      color: SaienteColors.title_color,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '¥ ${controller.formulaModel?.price ?? 0.0}',
                                    style: const TextStyle(
                                      color: SaienteColors.appMain,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (controller.formulaModel != null) _compareInfo(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  //配方基本物质对比
  Widget _compareInfo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            controller.compareExpanded.value = !controller.compareExpanded.value;
          },
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                  style: TextStyle(color: SaienteColors.blue2559F3, fontSize: 14),
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
              height: value ? 130 * 14 : 0,
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
                  controller.formulaModel!.dm.toString(),
                  controller.formulaModel!.baseDM.toString(),
                ),
                _compareCell(
                  '粗料比(%)',
                  controller.formulaModel!.roughagesPercent.toString(),
                  controller.formulaModel!.baseRoughagesPercent.toString(),
                ),
                _compareCell(
                  '粗蛋白需要量(kg/d)',
                  controller.formulaModel!.cp.toString(),
                  controller.formulaModel!.baseCP.toString(),
                ),
                _compareCell(
                  '瘤胃降解蛋白(kg/d)',
                  controller.formulaModel!.rdp.toString(),
                  controller.formulaModel!.baseRDP.toString(),
                ),
                _compareCell(
                  '瘤胃非降解蛋白(kg/d)',
                  controller.formulaModel!.rup.toString(),
                  controller.formulaModel!.baseRUP.toString(),
                ),
                _compareCell(
                  '代谢蛋白(kg/d)',
                  controller.formulaModel!.mp.toString(),
                  controller.formulaModel!.baseMP.toString(),
                ),
                _compareCell(
                  '代谢赖氨酸(kg/d)',
                  controller.formulaModel!.mLys.toString(),
                  controller.formulaModel!.baseMLys.toString(),
                ),
                _compareCell(
                  '代谢蛋氨酸(kg/d)',
                  controller.formulaModel!.mMet.toString(),
                  controller.formulaModel!.baseMMet.toString(),
                ),
                _compareCell(
                  '代谢能(Mcal/d)',
                  controller.formulaModel!.me.toString(),
                  controller.formulaModel!.baseME.toString(),
                ),
                _compareCell(
                  '维持净能(Mcal/d)',
                  controller.formulaModel!.nEm.toString(),
                  controller.formulaModel!.baseNEm.toString(),
                ),
                _compareCell(
                  '增重净能(Mcal/d)',
                  controller.formulaModel!.nEg.toString(),
                  controller.formulaModel!.baseNEg.toString(),
                ),
                _compareCell(
                  '钙(kg/d)',
                  controller.formulaModel!.ca.toString(),
                  controller.formulaModel!.baseCa.toString(),
                ),
                _compareCell(
                  '磷(kg/d)',
                  controller.formulaModel!.p.toString(),
                  controller.formulaModel!.baseP.toString(),
                ),
              ],
            ),
          ),
        ),
      ],
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
}

class _RawMaterialInfoItem extends StatefulWidget {
  const _RawMaterialInfoItem({super.key, required this.rawMaterial, required this.onTapDelete});

  final RawMaterial rawMaterial;
  final VoidCallback onTapDelete;

  @override
  State<_RawMaterialInfoItem> createState() => _RawMaterialInfoItemState();
}

class _RawMaterialInfoItemState extends State<_RawMaterialInfoItem> {
  TextEditingController verifyWeightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    verifyWeightController.text = widget.rawMaterial.verifyWeight.toString();
    verifyWeightController.addListener(() {
      if (verifyWeightController.text.isEmpty || double.parse(verifyWeightController.text) < 0.1) {
        verifyWeightController.text = '0.1';
        widget.rawMaterial.verifyWeight = 0.1;
        return;
      } else {
        widget.rawMaterial.verifyWeight = double.parse(verifyWeightController.text);
      }
    });
  }

  @override
  void dispose() {
    verifyWeightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Text(widget.rawMaterial.name ?? '', style: const TextStyle(fontSize: 14)),
              ),
              Expanded(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        verifyWeightController.text =
                            (double.parse(verifyWeightController.text) - 0.1).toStringAsFixed(2);
                      },
                      icon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: SaienteColors.blue2559F3.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '-',
                          style: TextStyle(fontSize: 16, color: SaienteColors.appMain),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: TextField(
                          controller: verifyWeightController,
                          style: const TextStyle(fontSize: 14),
                          onChanged: (value) {
                            widget.rawMaterial.verifyWeight = double.parse(value);
                          },
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(border: InputBorder.none),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        verifyWeightController.text =
                            (double.parse(verifyWeightController.text) + 0.1).toStringAsFixed(2);
                      },
                      icon: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: SaienteColors.blue2559F3.withAlpha(20),
                          shape: BoxShape.circle,
                        ),
                        child: const Text(
                          '+',
                          style: TextStyle(fontSize: 16, color: SaienteColors.appMain),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          right: 4,
          top: 0,
          child: GestureDetector(
            onTap: widget.onTapDelete,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                color: Colors.transparent,
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: const Icon(Icons.close, color: Colors.black, size: 18),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopLabel extends StatelessWidget {
  const _TopLabel({
    super.key,
    required this.title,
    required this.content,
    this.isInput = false,
    this.onTap,
    this.controller,
  });

  final String title;

  final String content;

  final bool isInput;

  final VoidCallback? onTap;

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          const Text('*', style: TextStyle(fontSize: 14, color: SaienteColors.redFF3D3D)),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                color: SaienteColors.title_color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: SaienteColors.title_color),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child:
                          isInput
                              ? TextField(
                                controller: controller,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                ],
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                  isDense: true,
                                ),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: SaienteColors.title_color,
                                ),
                              )
                              : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  content,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: SaienteColors.title_color,
                                  ),
                                ),
                              ),
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: SaienteColors.title_color,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
