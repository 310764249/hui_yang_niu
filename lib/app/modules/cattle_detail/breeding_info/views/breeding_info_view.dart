import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:graphview/GraphView.dart' as GraphNode;
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/load_image.dart';
import 'package:intellectual_breed/app/widgets/my_card.dart';

import '../../../../services/colors.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/divider_line.dart';
import '../../../../widgets/page_wrapper.dart';
import '../controllers/breeding_info_controller.dart';

class BreedingInfoView extends GetView<BreedingInfoController> {
  const BreedingInfoView({Key? key}) : super(key: key);

  // 基础信息中的 key：value
  Widget _basicRow(String leftTitle, String leftTitleValue, String? rightTitle,
      String? rightTitleValue) {
    return Row(
      children: [
        Expanded(
            child: _keyValueView(
          leftTitle,
          leftTitleValue,
        )),
        rightTitle == null
            ? const SizedBox()
            : Expanded(
                child: _keyValueView(
                rightTitle,
                rightTitleValue!,
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

  //生长性状
  Widget _traitStatistics() {
    return MyCard(children: [
      const CardTitle(title: "生长性状"),
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
            '日增重(g):',
            controller.model?.dailyGain.toString() ?? Constant.placeholder,
            '饲料利用率:',
            controller.model?.efficiencyOfFeed.toString() ??
                Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '初生重(kg):',
            controller.model?.birthWeight.toString() ?? Constant.placeholder,
            '断奶重(kg):',
            controller.model?.weanWeight.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '断奶后日增重(g):',
            controller.model?.weanDailyGain.toString() ?? Constant.placeholder,
            '成年体重(kg):',
            controller.model?.adultWeight.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
        ]),
      ),
    ]);
  }

  //繁殖性状
  Widget _reproductiveStatistics() {
    return MyCard(children: [
      const CardTitle(title: "繁殖性状"),
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
            '受胎率(%):',
            controller.model?.pregnancyRateOfBulls.toString() ??
                Constant.placeholder,
            '产犊率(%):',
            controller.model?.calvRate.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '断奶成活率(%):',
            controller.model?.rateOfWean.toString() ?? Constant.placeholder,
            null,
            null,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
        ]),
      ),
    ]);
  }

  //胴体性状
  Widget _carcassStatistics() {
    return MyCard(children: [
      const CardTitle(title: "胴体性状"),
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
            '屠宰率(%):',
            controller.model?.deadWeight.toString() ?? Constant.placeholder,
            '净肉率(%):',
            controller.model?.pureMeatRate.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '脂肪厚度(mm):',
            controller.model?.fatThickness.toString() ?? Constant.placeholder,
            '背膘厚度(mm):',
            controller.model?.backfatThickness.toString() ??
                Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '眼肌肉面积(cm²):',
            controller.model?.eyeMuscleArea.toString() ?? Constant.placeholder,
            null,
            null,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
        ]),
      ),
    ]);
  }

  //肉质性状
  Widget _fleshyStatistics() {
    return MyCard(children: [
      const CardTitle(title: "肉质性状"),
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
            '肌肉PH:',
            controller.model?.musclePh.toString() ?? Constant.placeholder,
            '肌肉脂肪率(%):',
            controller.model?.muscleFatRate.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '肉色:',
            controller.model?.fleshcolor.toString() ?? Constant.placeholder,
            '大理石纹:',
            controller.model?.marble.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
          _basicRow(
            '嫩度(N/cm):',
            controller.model?.tenderness.toString() ?? Constant.placeholder,
            '系水力(%):',
            controller.model?.waterHold.toString() ?? Constant.placeholder,
          ),
          SizedBox(height: ScreenAdapter.height(10)),
        ]),
      ),
    ]);
  }

  Widget rectangleWidget(Map item) {
    String label = item['code'].toString();
    int gender = item['gender'];
    return InkWell(
      onTap: () {
        print('clicked--${label}');
      },
      child: Column(
        children: [
          LoadImage(
              gender == 1 ? AssetsImages.nodeBullPng : AssetsImages.nodeCowPng),
          SizedBox(height: ScreenAdapter.height(5)),
          Text(
            label,
            style: const TextStyle(
                color: SaienteColors.blackE5,
                fontSize: 12,
                fontWeight: FontWeight.w400),
          )
        ],
      ),
      /*
      child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            boxShadow: [
              BoxShadow(color: Colors.blue[100]!, spreadRadius: 1),
            ],
          ),
          child: Text('${a}')),
          */
    );
  }

  //族谱信息
  Widget _breedingInfo() {
    return MyCard(
      children: [
        Container(
            height: ScreenAdapter.height(300),
            decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.all(Radius.circular(ScreenAdapter.width(10))),
                //渐变色背景
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFD5E3FF),
                    Color(0xFFFFFFFF),
                    Color(0xFFFFFFFF)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )),
            child: Stack(children: [
              Container(
                height: ScreenAdapter.height(300),
                child: InteractiveViewer(
                    constrained: false,
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 0.01,
                    maxScale: 5.6,
                    child: GraphNode.GraphView(
                      graph: controller.graph,
                      algorithm: GraphNode.BuchheimWalkerAlgorithm(
                          controller.builder,
                          GraphNode.TreeEdgeRenderer(controller.builder)),
                      // algorithm: SugiyamaAlgorithm(builder),
                      paint: Paint()
                        ..color = Color(0x99275CF3)
                        ..strokeWidth = 2
                        ..style = PaintingStyle.fill,
                      builder: (GraphNode.Node node) {
                        // I can decide what widget should be shown here based on the id
                        var a = node.key!.value as String?;
                        var nodes = controller.jsonList;
                        var nodeValue =
                            nodes.firstWhere((element) => element['code'] == a);

                        return rectangleWidget(nodeValue);
                      },
                    )),
              ),
              const Positioned(
                top: 0,
                left: 0,
                child: CardTitle(title: "系谱图"),
              )
            ])),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    //print('_breedingInfo ${controller.cattle.code}');
    return Scaffold(
        body: PageWrapper(
      child: ListView(children: [
            //族谱信息
            //  _breedingInfo(),
            controller.hasNode.value ? _breedingInfo() : const SizedBox(),
            //性状信息
            controller.isLoading.value
                ? const SizedBox()
                : Column(
                    children: [
                      //生长性状
                      _traitStatistics(),
                      //繁殖性状
                      _reproductiveStatistics(),
                      //胴体性状
                      _carcassStatistics(),
                      //肉质性状
                      _fleshyStatistics(),
                    ],
                  ),
          ]),
    ));
  }
}
