import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/modules/material_management/material_records/view/material_records_view.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/widgets/cell_button.dart';
import 'package:intellectual_breed/app/widgets/cell_text_area.dart';
import 'package:intellectual_breed/app/widgets/cell_text_field.dart';
import 'package:intellectual_breed/app/widgets/my_card.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

class MaterialRecordsDetails extends StatefulWidget {
  const MaterialRecordsDetails({super.key});

  static Future push(
    BuildContext context, {
    required MaterialRecordsViewEnum materialRecordsViewEnum,
    required String id,
  }) async {
    return await Get.toNamed(
      Routes.MaterialRecordsDetails,
      arguments: {
        'materialRecordsViewEnum': materialRecordsViewEnum,
        'id': id,
      },
    );
  }

  @override
  State<MaterialRecordsDetails> createState() => _MaterialRecordsDetailsState();
}

class _MaterialRecordsDetailsState extends State<MaterialRecordsDetails> {
  final HttpsClient httpsClient = HttpsClient();

  late MaterialRecordsViewEnum materialRecordsViewEnum;

  late String id;

  //物资信息
  MaterialItemModel? materialItemModel;

  //物资名称
  final TextEditingController materialNameController = TextEditingController();
  final FocusNode materialNameFocus = FocusNode();

  //数量
  final TextEditingController counterController = TextEditingController();
  final FocusNode counterNameFocus = FocusNode();

  //备注
  final TextEditingController remakeController = TextEditingController();
  final FocusNode remakeNameFocus = FocusNode();

  //物资分离
  List? wzflList;
  ValueNotifier<Map?> wzflSelectNotif = ValueNotifier<Map?>(null);

  //物资单位
  List? wzdwList;
  ValueNotifier<Map?> wzdwSelectNotif = ValueNotifier(null);

  //操作人当前登录用户
  ValueNotifier<String> nikeNameNotifier = ValueNotifier(Constant.placeholder);

  //可领用的总量
  ValueNotifier<String?> canUseCount = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
    Map argument = Get.arguments;
    materialRecordsViewEnum = argument['materialRecordsViewEnum'];
    id = argument['id'] as String;
    initData();
  }

  Future<void> initData() async {
    await MaterialService.getDic('wzfl').then((value) {
      //[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
      wzflList = value;
    });
    await MaterialService.getDic('wzdw').then((value) {
      //{key: 其他, value: 8, sort: 8, isDeleted: false, dataType: null}
      wzdwList = value;
    });
    getDetails();
  }

  //获取详细信息
  void getDetails() async {
    try {
      Toast.showLoading(msg: "加载中...");
      var resp = await httpsClient.get('/api/stockrecord/$id');
      Toast.dismiss();
      materialItemModel = MaterialItemModel.fromJson(resp);
      materialNameController.text = materialItemModel?.materialName ?? '';
      wzflSelectNotif.value = wzflList?.firstWhereOrNull(
        (e) => num.parse(e['value']).toString() == materialItemModel?.category.toString(),
      );
      wzdwSelectNotif.value = wzdwList?.firstWhereOrNull(
        (e) => num.parse(e['value']).toString() == materialItemModel?.unit.toString(),
      );

      counterController.text = materialItemModel?.count.toString() ?? '';

      remakeController.text = materialItemModel?.remark ?? '';

      nikeNameNotifier.value = materialItemModel?.createdBy ?? Constant.placeholder;
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        debugPrint('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        debugPrint('Other Exception: $error');
      }
    }
  }

  @override
  void dispose() {
    materialNameFocus.dispose();
    materialNameController.dispose();
    counterNameFocus.dispose();
    counterController.dispose();
    wzflSelectNotif.dispose();
    wzdwSelectNotif.dispose();
    remakeController.dispose();
    remakeNameFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(materialRecordsViewEnum.getSubTitle()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(children: [
        MyCard(
          children: [
            ValueListenableBuilder(
                valueListenable: nikeNameNotifier,
                builder: (context, String value, Widget? child) {
                  return CellTextField(
                    isRequired: true,
                    title: '操作人',
                    hint: '请输入',
                    //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
                    controller: TextEditingController(text: value),
                    editable: true,
                  );
                }),
            CellTextField(
              isRequired: true,
              title: '物资名称',
              hint: '请输入',
              //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
              controller: materialNameController,
              focusNode: materialNameFocus,
              editable: true,
            ),
            ValueListenableBuilder(
              valueListenable: wzflSelectNotif,
              builder: (BuildContext context, Map? value, Widget? child) {
                return CellButton(
                  isRequired: true,
                  title: '物资分类',
                  hint: value?['key'] ?? "请选择",
                  showArrow: true,
                  onPressed: null,
                );
              },
            ),
            ValueListenableBuilder(
                valueListenable: wzdwSelectNotif,
                builder: (context, Map? value, Widget? child) {
                  return CellButton(
                    isRequired: true,
                    title: '物资单位',
                    hint: value?['key'] ?? "请选择",
                    showArrow: true,
                    onPressed: null,
                  );
                }),
            ValueListenableBuilder(
                valueListenable: canUseCount,
                builder: (context, String? value, Widget? child) {
                  return CellTextField(
                    isRequired: true,
                    title: '数量${value == null ? '' : ' （剩余${value}）'}',
                    hint: '请输入',
                    editable: true,
                    keyboardType: TextInputType.number,
                    //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
                    controller: counterController,
                    focusNode: counterNameFocus,
                    inputFormatters: [
                      //仅数字
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  );
                }),
            CellTextArea(
              isRequired: false,
              title: "备注信息",
              hint: "请输入",
              showBottomLine: false,
              controller: remakeController,
              focusNode: remakeNameFocus,
              editable: false,
            ),
          ],
        ),
      ]),
    );
  }
}
