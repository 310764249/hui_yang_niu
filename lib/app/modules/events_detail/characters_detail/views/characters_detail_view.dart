import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../widgets/cell_button_detail.dart';
import '../../../../widgets/empty_view.dart';
import '../controllers/characters_detail_controller.dart';

import '../../../../services/AssetsImages.dart';
import '../../../../services/colors.dart';
import '../../../../services/constant.dart';
import '../../../../services/load_image.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/cell_text_area_detail.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/divider_line.dart';
import '../../../../widgets/my_card.dart';
import '../../../../widgets/page_wrapper.dart';
import '../../../../services/ex_string.dart';

class CharactersDetailView extends GetView<CharactersDetailController> {
  const CharactersDetailView({Key? key}) : super(key: key);

  //
  Widget _keyValueView(String title, String value) {
    return Text.rich(TextSpan(children: [
      TextSpan(
          text: title,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(13),
              color: SaienteColors.black80)),
      TextSpan(
          text: value,
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(13),
              fontWeight: FontWeight.w500,
              color: SaienteColors.blackE5))
    ]));
  }

  // 标签view: "公牛"/"栋舍"
  Widget _labelView(String labelText) {
    return Container(
      //width: ScreenAdapter.width(50),
      height: ScreenAdapter.height(20),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: controller.cattle!.gender == 2
              ? [SaienteColors.redFF3D3D, SaienteColors.redFF7F7F]
              : [SaienteColors.blue2559F3, SaienteColors.blue4D91F5],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(8), 0, ScreenAdapter.width(8), 0),
        child: Text(
          labelText,
          style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w400,
              color: Colors.white),
        ),
      ),
    );
  }

  // 牛只信息卡片
  Widget _cattleHeaderCard() {
    return Container(
      margin: EdgeInsets.fromLTRB(
          ScreenAdapter.width(10),
          ScreenAdapter.height(10),
          ScreenAdapter.width(10),
          ScreenAdapter.height(0)),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          gradient: LinearGradient(
            colors: controller.cattle!.gender == 2
                ? [const Color(0xFFFFDDDD), const Color(0xFFFFFFFF)]
                : [const Color(0xFFD5E3FF), const Color(0xFFFFFFFF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
      child: Column(children: [
        // 牛只图片和编号
        Row(mainAxisSize: MainAxisSize.max, children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(20),
                ScreenAdapter.height(6),
                ScreenAdapter.width(20),
                ScreenAdapter.height(5)),
            child: LoadAssetImage(
              controller.cattle!.gender == 2
                  ? AssetsImages.cow
                  : AssetsImages.bull,
            ),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(controller.cattle!.code.orEmpty(),
                  style: TextStyle(
                      color: controller.cattle!.gender == 2
                          ? SaienteColors.redFF3D3D
                          : SaienteColors.blue275CF3,
                      overflow: TextOverflow.ellipsis,
                      fontSize: ScreenAdapter.fontSize(20),
                      fontWeight: FontWeight.w800)),
              SizedBox(height: ScreenAdapter.height(5)),
              SizedBox(
                height: ScreenAdapter.height(20),
                child: ListView(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  children: [
                    _labelView(AppDictList.findLabelByCode(controller.gmList,
                        controller.cattle!.gender.toString())),
                    SizedBox(width: ScreenAdapter.width(2)),
                    _labelView('${controller.cattle!.cowHouseName}'),
                  ],
                ),
              )
            ]),
          ),
        ]),
        DividerLine(
            color: const Color(0xFFCCCCCC),
            indent: ScreenAdapter.width(11),
            endIndent: ScreenAdapter.width(11)),
        Padding(
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(22),
              ScreenAdapter.height(14),
              ScreenAdapter.width(22),
              ScreenAdapter.height(14)),
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _keyValueView(
                        '状   态: ',
                        AppDictList.findLabelByCode(controller.szjdList,
                            controller.cattle!.gender.toString()),
                      ),
                      SizedBox(height: ScreenAdapter.height(6)),
                      _keyValueView('日   龄: ',
                          '${controller.cattle!.ageOfDay.toString()}天'),
                    ]),
              ),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _keyValueView(
                        '品   种: ',
                        AppDictList.findLabelByCode(controller.pzList,
                            controller.cattle!.kind.toString()),
                      ),
                      SizedBox(height: ScreenAdapter.height(6)),
                      _keyValueView(
                          '电子耳号: ',
                          controller.cattle!.eleCode.orEmpty().trim().isEmpty
                              ? Constant.placeholder
                              : controller.cattle!.eleCode.orEmpty().trim()),
                    ]),
              )
            ],
          ),
        ),
      ]),
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "事件信息"),
      CellButtonDetail(
        isRequired: false,
        title: '日增重（g）',
        hint: controller.event!.dailyGain.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '饲料利用率（%)',
        hint: controller.event!.efficiencyOfFeed.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '初生重（kg）',
        hint: controller.event!.birthWeight.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '断奶重（kg）',
        hint: controller.event!.weanWeight.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '断奶后日增重（g）',
        hint: controller.event!.weanDailyGain.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '成年体重（kg）',
        hint: controller.event!.adultWeight.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '受胎率（%）',
        hint: controller.event!.pregnancyRateOfBulls.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '产犊率（%）',
        hint: controller.event!.calvRate.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '犊牛断奶成活率（%）',
        hint: controller.event!.rateOfWean.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '屠宰率（%）',
        hint: controller.event!.deadWeight.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '净肉率（%）',
        hint: controller.event!.pureMeatRate.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '脂肪厚度（mm）',
        hint: controller.event!.fatThickness.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '眼肌肉面积（cm²）',
        hint: controller.event!.eyeMuscleArea.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '肌肉PH',
        hint: controller.event!.musclePh.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '肌肉脂肪率（%）',
        hint: controller.event!.muscleFatRate.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '肉色',
        hint: controller.event!.fleshcolor.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '大理石纹',
        hint: controller.event!.marble.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '嫩度',
        hint: controller.event!.tenderness.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '系水力',
        hint: controller.event!.waterHold.toString(),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '技术员',
        hint: controller.event!.executor,
      ),
      CellTextAreaDetail(
        isRequired: false,
        title: '备注',
        content: controller.event!.remark ?? Constant.placeholder,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('性状统计详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: Obx(() => PageWrapper(
              child: controller.isLoading.value
                  ? const EmptyView()
                  : ListView(children: [
                      //提交按钮
                      _cattleHeaderCard(),
                      //操作信息
                      _operationInfo(context),
                    ]),
            )));
  }
}
