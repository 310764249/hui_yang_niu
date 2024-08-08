import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../routes/app_pages.dart';
import '../../../services/Log.dart';
import '../../../services/constant.dart';
import '../../../services/ex_string.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/cell_button_detail.dart';
import '../../../widgets/cell_text_area_detail.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/divider_line.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../controllers/batch_detail_controller.dart';

class BatchDetailView extends GetView<BatchDetailController> {
  const BatchDetailView({Key? key}) : super(key: key);

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
          colors: controller.argument.gender == 2
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
            colors: controller.argument.gender == 2
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
            child: const LoadAssetImage(
              AssetsImages.batchPng,
            ),
          ),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(controller.argument.batchNo.orEmpty(),
                  style: TextStyle(
                      color: controller.argument.gender == 2
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
                        controller.argument.gender.toString())),
                    SizedBox(width: ScreenAdapter.width(2)),
                    _labelView('${controller.argument.cowHouseName}'),
                  ],
                ),
              )
            ]),
          ),
        ]),
      ]),
    );
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "事件信息"),
      CellButtonDetail(
        isRequired: true,
        title: '批次类型',
        hint: AppDictList.findLabelByCode(
            controller.typeList, controller.argument.type.toString()),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '批次号',
        hint: controller.argument.batchNo,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '批次总数',
        hint: controller.argument.count.toString(),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '公母',
        hint: AppDictList.findLabelByCode(
            controller.gmList, controller.argument.gender.toString()),
      ),
      CellButtonDetail(
        isRequired: true,
        title: '出生日期',
        hint: controller.argument.birth ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '品种',
        hint: AppDictList.findLabelByCode(
            controller.pzList, controller.argument.kind.toString()),
      ),
      CellButtonDetail(
        isRequired: false,
        title: '来源场',
        hint: controller.argument.sourceFarm ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '入场时间',
        hint: controller.argument.inArea ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: true,
        title: '栋舍',
        hint: controller.argument!.cowHouseName ?? Constant.placeholder,
      ),
      CellButtonDetail(
        isRequired: false,
        title: '操作人',
        hint: controller.argument!.executor,
      ),
      CellTextAreaDetail(
        isRequired: false,
        title: '备注',
        content: controller.argument!.remark ?? Constant.placeholder,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('批次详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
          actions: [
            TextButton(
                onPressed: () {
                  Get.toNamed(Routes.NEW_BATCH, arguments: controller.argument)
                      ?.then((value) {
                    //Log.e(value.toString());
                    if (value != null) {
                      Get.back(result: value);
                    }
                  });
                },
                child: Text(
                  "编辑",
                  style: TextStyle(
                      color: SaienteColors.blue275CF3,
                      fontSize: ScreenAdapter.fontSize(16)),
                ))
          ],
        ),
        body: PageWrapper(
          child: ListView(children: [
            //header
            _cattleHeaderCard(),
            //操作信息
            _operationInfo(context),
          ]),
        ));
  }
}
