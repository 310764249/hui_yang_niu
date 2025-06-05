import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/modules/recipe_create/views/select_recipe.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/main_button.dart';

import '../../../services/screenAdapter.dart';
import '../../../widgets/alert.dart';
import '../../../widgets/cell_button.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/picker.dart';
import '../../../widgets/toast.dart';
import '../controllers/recipe_create_controller.dart';

///
/// 创建配方
///
class RecipeCreateView extends GetView<RecipeCreateController> {
  const RecipeCreateView({Key? key}) : super(key: key);

  // 根据选择的个体类型不同去显示不同的选项
  // 日增重目标 - 生长母牛
  // 妊娠月份 - 妊娠期母牛
  // 哺乳月份 - 哺乳母牛
  // 泌乳量目标 - 哺乳母牛
  Widget _dynamicWidgets(BuildContext context) {
    switch (controller.gtlxValue.value) {
      case 1:
        return CellButton(
            isRequired: true,
            title: '日增重目标',
            content: controller.rzzSelName.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.rzzNameListHB, selectData: controller.rzzSelName.value, title: '请选择日增重',
                  onConfirm: (value, position) {
                controller.updateRzzSelectedItems(value, position);
              });
            });
      case 2:
        return CellButton(
            isRequired: true,
            title: '妊娠月份',
            content: controller.rsyfSelName.value,
            onPressed: () {
              Picker.showSinglePicker(context, controller.rsyfNameList,
                  selectData: controller.rsyfSelName.value, title: '请选择妊娠月份', onConfirm: (value, position) {
                controller.updateRsyfSelectedItems(value, position);
              });
            });
      case 3:
        return Column(
          children: [
            CellButton(
                isRequired: true,
                title: '哺乳月份',
                content: controller.mryfSelName.value,
                onPressed: () {
                  Picker.showSinglePicker(context, controller.mryfNameList,
                      selectData: controller.mryfSelName.value, title: '请选择哺乳月份', onConfirm: (value, position) {
                    controller.updateMryfSelectedItems(value, position);
                  });
                }),
            // CellButton(
            //     isRequired: true,
            //     title: '泌乳量目标',
            //     content: controller.mrlSelName.value,
            //     onPressed: () {
            //       Picker.showSinglePicker(context, controller.mrlNameList,
            //           selectData: controller.mrlSelName.value,
            //           title: '请选择泌乳量目标', onConfirm: (value, position) {
            //         controller.updateMrlSelectedItems(value, position);
            //       });
            //     }),
            // CellButton(
            //     isRequired: true,
            //     title: '泌乳等级',
            //     content: controller.yxdjSelName.value,
            //     onPressed: () {
            //       Picker.showSinglePicker(context, controller.yxdjNameList,
            //           selectData: controller.yxdjSelName.value,
            //           title: '请选择泌乳等级', onConfirm: (value, position) {
            //         controller.updateYxdjSelectedItems(value, position);
            //       });
            //     }),
          ],
        );
      case 4:
        // 育肥牛
        return CellButton(
            isRequired: true,
            title: '日增重目标',
            content: controller.rzzSelName.value,
            onPressed: () {
              final weightStr = controller.gtzlSelName.value.replaceAll('千克', '');
              final weight = int.tryParse(weightStr);

              final Map<int, List<double>> weightRangeMap = {
                200: [0.5, 1.5],
                250: [0.5, 1.5],
                300: [0.5, 1.5],
                350: [0.5, 1.5],
                400: [1.0, 2.0],
                450: [1.0, 2.0],
                500: [1.0, 2.0],
                550: [1.0, 2.0],
                600: [1.0, 1.5],
                650: [1.0, 1.5],
                700: [1.0, 1.5],
                750: [1.0, 1.5],
                800: [1.0, 1.5],
              };

              if (weight != null && weightRangeMap.containsKey(weight)) {
                final range = weightRangeMap[weight]!;

                // 原始数组：字典返回的完整区间
                final originList = controller.rzzNameListYF;

                // 截取落在当前区间的选项
                final filteredList = originList.where((item) {
                  final v = double.tryParse(item.replaceAll('千克', ''));
                  return v != null && v >= range[0] && v <= range[1];
                }).toList();

                if (filteredList.isEmpty) {
                  debugPrint('当前体重无可选日增重区间');
                  return;
                }

                // 弹出选择器
                Picker.showSinglePicker(
                  context,
                  filteredList,
                  selectData: controller.rzzSelName.value,
                  title: '请选择日增重',
                  onConfirm: (value, position) {
                    debugPrint('value: $value, position: $position');
                    //根据返回的value，在没有筛选的数据中找position
                    int index = originList.indexWhere((item) => item == value);
                    controller.updateRzzSelectedItems(value, index);
                  },
                );
              } else {
                debugPrint('未找到对应体重的区间范围');
              }
            });
      default:
        return const SizedBox();
    }
  }

  // 配方可选项
  Widget _recipeOptions(BuildContext context) {
    return Column(
      children: [
        CellButton(
            isRequired: true,
            title: '个体类型',
            content: controller.gtlxSelName.value,
            onPressed: () {
              if (controller.gtlxNameList.isEmpty) {
                Toast.show('配方目标类型获取失败');
                return;
              }
              Picker.showSinglePicker(context, controller.gtlxNameList,
                  selectData: controller.gtlxSelName.value, title: '请选择个体类型', onConfirm: (value, position) {
                controller.updateGtlxSelectedItems(value, position);
              });
            }),
        CellButton(
            isRequired: true,
            title: '个体重量',
            content: controller.gtzlSelName.value,
            onPressed: () {
              if (controller.gtzlList.isEmpty) {
                Toast.show('请先选择个体类型');
                return;
              }
              if (controller.gtzlNameList.isEmpty) {
                Toast.show('个体重量列表获取失败');
                return;
              }

              Picker.showSinglePicker(context, controller.gtzlNameList,
                  selectData: controller.gtzlSelName.value, title: '请选择个体重量', onConfirm: (value, position) {
                controller.updateGtzlSelectedItems(value, position);
              });
            }),
        // 更加不同牛只类型, 动态显示布局
        _dynamicWidgets(context),
        CellButton(
            isRequired: true,
            title: '粗饲料',
            content: controller.cslSelectedDisplayNames.value,
            onPressed: () {
              if (controller.cslNameList.isEmpty) {
                Toast.show('粗饲料列表获取失败');
                return;
              }
              // 多选弹窗
              SelectRecipe.showMultiPicker(
                controller.cslNameList,
                context,
                itemsSelected: List.from(controller.cslSelectedIndexList),
                maxSelectionCount: 4,
                onConfirm: (selected) {
                  debugPrint('selected: $selected');
                  if (ObjectUtil.isEmptyList(selected)) {
                    Toast.failure(msg: '请至少选择一种类型');
                    return;
                  }
                  if (selected.length == 1) {
                    //selected 中是 index 数组。通过这句获取名称
                    String name = controller.cslNameList[selected[0].$1];
                    if (name.contains('青贮')) {
                      Toast.failure(msg: '无法单独选择青贮饲料');
                      return;
                    }
                  }
                  // selected 是已选择的下标[数组类型]
                  controller.updateCslSelectedItems(selected);
                },
              );
            }),
        CellButton(
            isRequired: true,
            title: '能量饲料',
            content: controller.nlslSelectedDisplayNames.value,
            onPressed: () {
              if (controller.nlslNameList.isEmpty) {
                Toast.show('能量饲料列表获取失败');
                return;
              }
              // 多选弹窗
              Alert.showMultiPicker(
                controller.nlslNameList,
                context,
                itemsSelected: List.from(controller.nlslSelectedIndexList),
                maxSelectionCount: 3,
                onConfirm: (selected) {
                  // if (ObjectUtil.isEmptyList(selected)) {
                  //   Toast.failure(msg: '请至少选择一种类型');
                  //   return;
                  // }
                  // selected 是已选择的下标[数组类型]
                  controller.updateNlslSelectedItems(selected);
                },
              );
            }),
        CellButton(
            isRequired: true,
            title: '蛋白饲料',
            content: controller.dbslSelectedDisplayNames.value,
            onPressed: () {
              if (controller.dbslNameList.isEmpty) {
                Toast.show('蛋白饲料列表获取失败');
                return;
              }
              // 多选弹窗
              Alert.showMultiPicker(
                controller.dbslNameList,
                context,
                itemsSelected: List.from(controller.dbslSelectedIndexList),
                maxSelectionCount: 3,
                onConfirm: (selected) {
                  // if (ObjectUtil.isEmptyList(selected)) {
                  //   Toast.failure(msg: '请至少选择一种类型');
                  //   return;
                  // }
                  // selected 是已选择的下标[数组类型]
                  controller.updateDbslSelectedItems(selected);
                },
              );
            }),
        CellButton(
            isRequired: false,
            title: '添加剂',
            showBottomLine: true,
            content: controller.tjjSelectedDisplayNames.value,
            onPressed: () {
              //! 添加剂中的数据有的是需要根据[个体类型]来调整选项显示的, 所以必须先得判断[个体类型]是否已选
              if (controller.gtzlList.isEmpty) {
                Toast.show('请先选择个体类型');
                return;
              }
              if (controller.tjjNameList.isEmpty) {
                Toast.show('添加剂列表获取失败');
                return;
              }
              // 多选弹窗
              Alert.showMultiPicker(
                controller.tjjNameList,
                context,
                itemsSelected: List.from(controller.tjjSelectedIndexList),
                onConfirm: (selected) {
                  // selected 是已选择的下标[数组类型]
                  controller.updateTjjSelectedItems(selected);
                },
              );
            }),
        CellButton(
            isRequired: false,
            title: '预混料',
            showBottomLine: false,
            content: controller.yhlSelName.value,
            onPressed: () {
              //! 预混料中的数据有的是需要根据[个体类型]来调整选项显示的, 所以必须先得判断[个体类型]是否已选
              if (controller.gtzlList.isEmpty) {
                Toast.show('请先选择个体类型');
                return;
              }
              if (controller.yhlNameList.isEmpty) {
                Toast.show('预混料类型获取失败');
                return;
              }
              Picker.showSinglePicker(context, controller.yhlNameList, selectData: controller.yhlSelName.value, title: '请选择预混料',
                  onConfirm: (value, position) {
                controller.updateYhlSelectedItems(value, position);
              });
            }),
      ],
    );
  }

  // 生成配方按钮
  Widget _makeRecipeButton() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        margin: const EdgeInsets.all(10),
        child: MainButton(
            text: '生成配方',
            onPressed: () {
              controller.makeRecipe();
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('创建配方'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: PageWrapper(
          child: Container(
        color: SaienteColors.backGrey,
        child: Obx(() => Stack(children: [
              Container(
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                margin: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), ScreenAdapter.height(10)),
                child: ListView(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    // physics: const NeverScrollableScrollPhysics(), // 禁止列表滑动
                    children: [
                      //配方基本信息
                      _recipeOptions(context),
                      //物质比例对比
                    ]),
              ),
              _makeRecipeButton(),
            ])),
      )),
    );
  }
}
