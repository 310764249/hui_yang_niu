import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/utils/check.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../network/httpsClient.dart';
import '../../routes/app_pages.dart';
import '../../services/colors.dart';
import '../../services/screenAdapter.dart';
import '../../widgets/cell_button.dart';
import '../../widgets/main_button.dart';
import '../../widgets/picker.dart';

class FeedPreparationPage extends StatefulWidget {
  const FeedPreparationPage({super.key});

  @override
  State<FeedPreparationPage> createState() => _FeedPreparationPageState();
}

class _FeedPreparationPageState extends State<FeedPreparationPage> {
  HttpsClient httpsClient = HttpsClient();

  //吨位文本控制器
  TextEditingController weightController = TextEditingController();
  FormulaModel? pickedFormula;
  List<String> formulaType = ['精饲料', '粗饲料'];
  int? currentFormulaType;

  @override
  void initState() {
    super.initState();
    weightController.text = '1.0';
  }

  //验证调制
  void validate() async {
    //关闭键盘取消焦点
    FocusScope.of(context).unfocus();
    if (pickedFormula == null) {
      Toast.show('请选择配方');
      return;
    }
    if (currentFormulaType == null) {
      Toast.show('请选择调制类型');
      return;
    }
    if (weightController.text.isEmpty) {
      Toast.show('请输入调制总量');
      return;
    }
    Toast.showLoading();
    try {
      final result = await httpsClient.post(
        '/api/feedpreparation/generate',
        data: {
          'formulaId': pickedFormula?.id,
          'formulaType': currentFormulaType,
          'weight': weightController.text,
        },
      );
      Toast.dismiss();
    } catch (e) {
      debugPrint('feedpreparation:$e');
      Toast.dismiss();
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      Toast.show('网络错误');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('饲料调制'), centerTitle: true, backgroundColor: Colors.white),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.fromLTRB(
              ScreenAdapter.width(10),
              ScreenAdapter.height(10),
              ScreenAdapter.width(10),
              ScreenAdapter.height(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CellButton(
                  isRequired: true,
                  title: '选择配方',
                  content: pickedFormula?.name ?? '请选择配方',
                  onPressed: () async {
                    final result = await Get.toNamed(Routes.RECIPE, arguments: {'isPick': true});
                    if (result != null && result is FormulaModel) {
                      setState(() {
                        pickedFormula = result;
                      });
                    }
                  },
                ),
                CellButton(
                  isRequired: true,
                  title: '调制类型',
                  content: currentFormulaType == null ? '' : formulaType[currentFormulaType ?? 0],
                  onPressed: () {
                    Picker.showSinglePicker(
                      context,
                      formulaType,
                      onConfirm: (dynamic data, int position) {
                        setState(() {
                          currentFormulaType = position;
                        });
                      },
                    );
                  },
                ),
                Row(
                  children: [
                    SizedBox(width: ScreenAdapter.width(12)),
                    Text(
                      "*",
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.w700,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      '调制总量（吨）',
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.blackE5,
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              if (weightController.text.isEmpty) {
                                return;
                              }
                              if (double.parse(weightController.text) < 1) {
                                return;
                              }
                              weightController.text = (double.parse(weightController.text) - 1)
                                  .toStringAsFixed(1);
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
                            child: Container(
                              height: 40,
                              margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(10)),
                              decoration: BoxDecoration(
                                border: Border.all(color: SaienteColors.blue4D91F5.withAlpha(50)),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: TextField(
                                controller: weightController,
                                keyboardType: TextInputType.number,
                                inputFormatters: [LengthLimitingTextInputFormatter(10)],
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(border: InputBorder.none),
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              weightController.text = (double.parse(
                                        weightController.text.isEmpty ? '0' : weightController.text,
                                      ) +
                                      1)
                                  .toStringAsFixed(1);
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
              ],
            ),
          ),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(10),
            child: MainButton(text: '调制', onPressed: validate),
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            margin: EdgeInsets.fromLTRB(
              ScreenAdapter.width(10),
              ScreenAdapter.height(10),
              ScreenAdapter.width(10),
              ScreenAdapter.height(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: SaienteColors.blue4D91F5.withValues(alpha: 0.3),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: const _TabItem(title: '原料名称', value: '重量（kg）'),
                ),
                const _TabItem(title: '燕麦甘草', value: '100'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({super.key, required this.title, required this.value});

  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    fontWeight: FontWeight.w500,
                    color: SaienteColors.blackE5,
                  ),
                ),
              ),
            ),
            Container(width: 0.5, color: SaienteColors.separateLine, height: 40),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                alignment: Alignment.center,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    fontWeight: FontWeight.w500,
                    color: SaienteColors.blackE5,
                  ),
                ),
              ),
            ),
          ],
        ),
        const DividerLine(),
      ],
    );
  }
}
