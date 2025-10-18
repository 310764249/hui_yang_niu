import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/raw_material.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/cell_button.dart';
import 'package:intellectual_breed/app/widgets/dict_list.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../models/formula.dart';
import '../../network/httpsClient.dart';
import '../../services/screenAdapter.dart';
import '../../widgets/my_card.dart';
import '../../widgets/picker.dart';

class RecipeVerifyPage extends StatefulWidget {
  const RecipeVerifyPage({super.key});

  @override
  State<RecipeVerifyPage> createState() => _RecipeVerifyPageState();
}

class _RecipeVerifyPageState extends State<RecipeVerifyPage> {
  HttpsClient httpsClient = HttpsClient();
  List gtlxList = [];
  List gtzlListHB = [];
  List gtzlListRS = [];
  List gtzlListYF = [];
  List rsyfList = [];

  //[{key: 880abf38-9c19-499b-b73e-72ed185838a8, label: 育肥牛, value: 4, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 1, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: 862a64f1-3c73-4956-9d04-994c2ca38a16, label: 青年妊娠母牛, value: 2, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 2, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: cbfa3876-d9bc-44c8-b264-3868790b4284, label: 妊娠母牛, value: 1, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 3, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: 0b5bcfaa-1c7e-41c7-a8c0-1b858e6df59f, label: 哺乳母牛, value: 3, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 4, disabled: false, dataType: null, isDeleted: false, children: null},
  // {key: f0b7a670-2d63-42e0-8f19-627edaac7859, label: 后备母牛, value: 5, parent: Toink.Data.Entities.Dic, isLeaf: false, sort: 5, disabled: false, dataType: null, isDeleted: false, children: null}]

  List<String> get labels => gtlxList.map((item) => item['label'].toString()).toList();

  String get currentLabel => currentItem['label'].toString();

  late Map<String, dynamic> currentItem;

  //显示牛只重量的牛只类型 育肥牛 青年妊娠母牛 后备母牛
  bool get showNuWeight =>
      currentItem['value'] == '4' || currentItem['value'] == '2' || currentItem['value'] == '5';

  //显示日增重的牛只类型 育肥牛 后备母牛
  bool get showNuDailyWeight => currentItem['value'] == '4' || currentItem['value'] == '5';

  //显示妊娠月份的牛只类型 青年妊娠母牛 妊娠母牛
  bool get showNuPregnancyMonth => currentItem['value'] == '2' || currentItem['value'] == '1';

  //显示哺乳月份的牛只类型 哺乳母牛
  bool get showNuBreastMonth => currentItem['value'] == '3';

  //当前选择牛只类型的体重
  List get nuWeight {
    if (showNuWeight) {
      //育肥牛
      if (currentItem['value'] == '4') {
        return gtzlListYF;
      }
      //青年妊娠母牛
      if (currentItem['value'] == '2') {
        return gtzlListRS;
      }
      //妊娠母牛
      if (currentItem['value'] == '5') {
        return gtzlListHB;
      }
    }
    return [];
  }

  Map<String, dynamic>? currentNuWeight;

  List<String> get nuWeightLabels => nuWeight.map((item) => item['label'].toString()).toList();

  String get nuWeightLabel => currentNuWeight?['label'] ?? '';

  //存栏输入
  TextEditingController countController = TextEditingController(text: "1");

  //当前选择的日增重
  String nuDailyWeight = '';

  //妊娠月份labels
  List<String> get rsyfLabels => rsyfList.map((item) => item['label'].toString()).toList();

  //选择的妊娠月份
  Map<String, dynamic>? currentRsyf;

  String get rsyfLabel => currentRsyf?['label'] ?? '';

  List<RawMaterial> rawMaterialList = [];

  //添加的饲料
  List<RawMaterial> addRawMaterialList = [];

  /// 加法
  double add(double a, double b, {int precision = 2}) {
    double result = a + b;
    return double.parse(result.toStringAsFixed(precision));
  }

  /// 减法
  double sub(double a, double b, {int precision = 2}) {
    double result = a - b;
    return double.parse(result.toStringAsFixed(precision));
  }

  //验证配方的结果
  FormulaModel? formulaModel;
  ValueNotifier<bool> compareExpanded = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    gtlxList = AppDictList.searchItems('pfmb')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListHB =
        AppDictList.searchItems('gtzl-hb')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListRS =
        AppDictList.searchItems('gtzl-qnrs')?.where((item) => !item['isDeleted']).toList() ?? [];
    gtzlListYF =
        AppDictList.searchItems('gtzl-yf')?.where((item) => !item['isDeleted']).toList() ?? [];
    rsyfList = AppDictList.searchItems('rsyf')?.where((item) => !item['isDeleted']).toList() ?? [];
    debugPrint('gtlxList: $gtlxList');
    currentItem = gtlxList.first;
    getRawMaterialList();
  }

  //获取饲料列表
  Future<void> getRawMaterialList() async {
    try {
      var response = await httpsClient.get("/api/rawmaterial/getall");
      for (var item in response) {
        RawMaterial model = RawMaterial.fromJson(item);
        rawMaterialList.add(model);
      }
    } catch (_) {}
  }

  //验证配方
  Future<void> verifyRecipe() async {
    if (showNuWeight) {
      if (currentNuWeight == null) {
        Toast.show('请选择牛只重量');
        return;
      }
    }
    if (showNuDailyWeight) {
      if (nuDailyWeight.isEmpty) {
        Toast.show('请选择日增重');
        return;
      }
    }
    if (showNuPregnancyMonth) {
      if (currentRsyf == null) {
        Toast.show('请选择妊娠月份');
      }
    }
    if (countController.text.isEmpty || countController.text == '0') {
      Toast.show('请输入存栏数');
      return;
    }
    if (addRawMaterialList.isEmpty) {
      Toast.show('请添加原料');
      return;
    }
    try {
      var response = await httpsClient.post(
        "/api/formula/verifyformula",
        data: {
          'formulaType': 1,
          "individualCate": 0,
          "individualType": currentItem['value'],
          "weightType": currentNuWeight?['value'],
          "dailyGainWeight": nuDailyWeight.replaceAll('kg', ''),
          "calvingMonths": currentRsyf?['value'],
          "milkGrade": 0,
          "gestationMonths": currentRsyf?['value'],
          "roughages":
              addRawMaterialList.where((e) => e.category == 1).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),

          "energyFeed":
              addRawMaterialList.where((e) => e.category == 2 && e.type == 2).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && element.type == 3
          "proteinFeed":
              addRawMaterialList.where((e) => e.category == 2 && e.type == 3).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && (element.type == 4 || element.type == 6
          "additives":
              addRawMaterialList.where((e) => e.category == 2 && (e.type == 4 || e.type == 6)).map((
                e,
              ) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
          //element.category == 2 && element.type == 5
          "premix":
              addRawMaterialList.where((e) => e.category == 2 && e.type == 5).map((e) {
                return {"id": e.id, "weight": e.verifyWeight};
              }).toList(),
        },
      );
      setState(() {
        formulaModel = FormulaModel.fromJson(response);
        formulaModel?.cowCount = int.parse(countController.text);
        formulaModel?.formulaType = 1;
      });
    } catch (e) {
      debugPrint('verifyRecipe error: $e');
      setState(() {
        formulaModel = null;
      });
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      Toast.show('验证配方失败');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('验证配方'),
        centerTitle: true,
        actions: [
          if (formulaModel != null)
            TextButton(
              onPressed: () {
                if (ObjectUtil.isNotEmpty(formulaModel)) {
                  Get.toNamed(Routes.RECIPE_DETAIL, arguments: formulaModel);
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
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CellButton(
                    isRequired: true,
                    title: '牛只类型',
                    content: currentLabel,
                    onPressed: () {
                      if (gtlxList.isEmpty) {
                        Toast.show('配方目标类型获取失败');
                        return;
                      }
                      Picker.showSinglePicker(
                        context,
                        labels,
                        selectData: currentItem['label'],
                        title: '请选择个体类型',
                        onConfirm: (value, position) {
                          setState(() {
                            currentItem = gtlxList[position];
                            currentNuWeight = null;
                            currentRsyf = null;
                            nuDailyWeight = '';
                            countController.text = '1';
                          });
                          debugPrint('当前选择: $currentItem');
                        },
                      );
                    },
                  ),
                  if (showNuWeight)
                    CellButton(
                      title: '牛只重量',
                      content: nuWeightLabel,
                      onPressed: () {
                        Picker.showSinglePicker(
                          context,
                          nuWeightLabels,
                          selectData: nuWeightLabel,
                          title: '请选择牛只重量',
                          onConfirm: (value, position) {
                            setState(() {
                              currentNuWeight = nuWeight[position];
                            });
                          },
                        );
                      },
                      isRequired: true,
                    ),
                  if (showNuDailyWeight)
                    CellButton(
                      title: '牛只日增重',
                      content: nuDailyWeight,
                      onPressed: () {
                        if (currentNuWeight == null) {
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

                        final weightStr = nuWeightLabel.replaceAll('kg', '');
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
                            selectData: nuDailyWeight,
                            title: '请选择日增重',
                            onConfirm: (value, position) {
                              setState(() {
                                nuDailyWeight = filteredList[position];
                              });
                            },
                          );
                        } else {
                          debugPrint('未找到对应体重的区间范围');
                        }
                      },
                      isRequired: true,
                    ),
                  if (showNuPregnancyMonth)
                    CellButton(
                      title: '妊娠月份',
                      isRequired: true,
                      content: rsyfLabel,
                      onPressed: () {
                        Picker.showSinglePicker(
                          context,
                          rsyfLabels,
                          selectData: rsyfLabel,
                          title: '请选择妊娠月份',
                          onConfirm: (value, position) {
                            setState(() {
                              currentRsyf = rsyfList[position];
                            });
                          },
                        );
                      },
                    ),
                  if (showNuBreastMonth)
                    CellButton(
                      title: '哺乳月份',
                      content: rsyfLabel,
                      isRequired: true,
                      onPressed: () {
                        Picker.showSinglePicker(
                          context,
                          rsyfLabels,
                          selectData: rsyfLabel,
                          title: '请选择哺乳月份',
                          onConfirm: (value, position) {
                            setState(() {
                              currentRsyf = rsyfList[position];
                            });
                          },
                        );
                      },
                    ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text('原料组成（kg）', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ),
            ...addRawMaterialList.map((e) {
              return _RawMaterialInfoItem(
                rawMaterial: e,
                onTapDelete: () {
                  setState(() {
                    addRawMaterialList.remove(e);
                  });
                },
              );
            }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    //列表移除已经添加的原料
                    List<RawMaterial> showRawMaterialLabels = List.from(rawMaterialList);
                    for (var o in addRawMaterialList) {
                      showRawMaterialLabels.remove(o);
                    }
                    Picker.showSinglePicker(
                      context,
                      showRawMaterialLabels.map((e) => e.name).toList(),
                      title: '请选择要添加的原料',
                      onConfirm: (value, position) {
                        setState(() {
                          addRawMaterialList.add(showRawMaterialLabels[position]);
                        });
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
                      '+添加原料',
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
                  verifyRecipe();
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
            if (formulaModel != null)
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
                              '¥ ${formulaModel?.price ?? 0.0}',
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
            if (formulaModel != null) _compareInfo(),
          ],
        ),
      ),
    );
  }

  //配方基本物质对比
  Widget _compareInfo() {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            compareExpanded.value = !compareExpanded.value;
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
                  valueListenable: compareExpanded,
                  builder: (context, value, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      transform: Matrix4.rotationZ(compareExpanded.value ? -pi : 0),
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
          valueListenable: compareExpanded,
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
                  formulaModel!.dm.toString(),
                  formulaModel!.baseDM.toString(),
                ),
                _compareCell(
                  '粗料比(%)',
                  formulaModel!.roughagesPercent.toString(),
                  formulaModel!.baseRoughagesPercent.toString(),
                ),
                _compareCell(
                  '粗蛋白需要量(kg/d)',
                  formulaModel!.cp.toString(),
                  formulaModel!.baseCP.toString(),
                ),
                _compareCell(
                  '瘤胃降解蛋白(kg/d)',
                  formulaModel!.rdp.toString(),
                  formulaModel!.baseRDP.toString(),
                ),
                _compareCell(
                  '瘤胃非降解蛋白(kg/d)',
                  formulaModel!.rup.toString(),
                  formulaModel!.baseRUP.toString(),
                ),
                _compareCell(
                  '代谢蛋白(kg/d)',
                  formulaModel!.mp.toString(),
                  formulaModel!.baseMP.toString(),
                ),
                _compareCell(
                  '代谢赖氨酸(kg/d)',
                  formulaModel!.mLys.toString(),
                  formulaModel!.baseMLys.toString(),
                ),
                _compareCell(
                  '代谢蛋氨酸(kg/d)',
                  formulaModel!.mMet.toString(),
                  formulaModel!.baseMMet.toString(),
                ),
                _compareCell(
                  '代谢能(Mcal/d)',
                  formulaModel!.me.toString(),
                  formulaModel!.baseME.toString(),
                ),
                _compareCell(
                  '维持净能(Mcal/d)',
                  formulaModel!.nEm.toString(),
                  formulaModel!.baseNEm.toString(),
                ),
                _compareCell(
                  '增重净能(Mcal/d)',
                  formulaModel!.nEg.toString(),
                  formulaModel!.baseNEg.toString(),
                ),
                _compareCell(
                  '钙(kg/d)',
                  formulaModel!.ca.toString(),
                  formulaModel!.baseCa.toString(),
                ),
                _compareCell('磷(kg/d)', formulaModel!.p.toString(), formulaModel!.baseP.toString()),
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
