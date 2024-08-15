import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/models/user_resource.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/modules/material_management/select_material_view.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/ex_int.dart';
import 'package:intellectual_breed/app/services/load_image.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/services/storage.dart';
import 'package:intellectual_breed/app/widgets/cell_button.dart';
import 'package:intellectual_breed/app/widgets/cell_text_area.dart';
import 'package:intellectual_breed/app/widgets/cell_text_field.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';
import 'package:intellectual_breed/app/widgets/main_button.dart';
import 'package:intellectual_breed/app/widgets/my_card.dart';
import 'package:intellectual_breed/app/widgets/picker.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

//枚举
enum AddInventoryEnum {
  //添加
  add,
  //编辑
  addEdit,
  //查看
  viewer,
  //删除
  delete,
  //领用
  use,
  //领用编辑
  useEdit,
  //报废
  scrap,
  //报废编辑
  scrapEdit,
}

extension AddInventoryEnumX on AddInventoryEnum {
  getName() {
    switch (this) {
      case AddInventoryEnum.add:
        return '入库';
      case AddInventoryEnum.addEdit:
        return '编辑';
      case AddInventoryEnum.viewer:
        return '物资';
      case AddInventoryEnum.delete:
        return '删除';
      case AddInventoryEnum.use:
        return '领用';
      case AddInventoryEnum.scrap:
        return '报废';
      case AddInventoryEnum.useEdit:
        return '领用编辑';
      case AddInventoryEnum.scrapEdit:
        return '报废编辑';
    }
  }
}

class AddInventoryView extends StatefulWidget {
  const AddInventoryView({super.key});

  static Future push(
    BuildContext context, {
    AddInventoryEnum addInventoryEnum = AddInventoryEnum.add,
    String? id,
    String? materialId,
    String? makeCount,
  }) async {
    return await Get.toNamed(
      Routes.AddInventory,
      arguments: {
        'addInventoryEnum': addInventoryEnum,
        'id': id,
        'materialId': materialId,
        'makeCount': makeCount,
      },
    );
  }

  @override
  State<AddInventoryView> createState() => _AddInventoryViewState();
}

class _AddInventoryViewState extends State<AddInventoryView> {
  final HttpsClient httpsClient = HttpsClient();

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
  // ValueNotifier<String> nikeNameNotifier = ValueNotifier(Constant.placeholder);

  //可领用的总量
  ValueNotifier<String?> canUseCount = ValueNotifier(null);

  //选择的日期
  ValueNotifier<PDuration> selectDateTime = ValueNotifier(PDuration.now());

  //物资id
  String? id;
  String? materialId;
  //报废或者领用数量
  String? makeCount;

  //是否编辑
  late AddInventoryEnum addInventoryEnum;

  //物资信息
  MaterialItemModel? materialItemModel;

  @override
  void initState() {
    super.initState();
    initData();
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
        title: Text(addInventoryEnum.getName()),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView(children: [
        MyCard(
          children: [
            // ValueListenableBuilder(
            //     valueListenable: nikeNameNotifier,
            //     builder: (context, String value, Widget? child) {
            //       return CellTextField(
            //         isRequired: true,
            //         title: '操作人',
            //         hint: '请输入',
            //         //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
            //         controller: TextEditingController(text: value),
            //         editable: true,
            //       );
            //     }),
            if (addInventoryEnum == AddInventoryEnum.use || addInventoryEnum == AddInventoryEnum.scrap)
              CellButton(
                isRequired: true,
                title: '选择物资',
                hint: "请选择",
                showArrow: true,
                onPressed: () async {
                  SelectMaterialView.push(context);
                },
              ),
            ValueListenableBuilder(
              valueListenable: wzflSelectNotif,
              builder: (BuildContext context, Map? value, Widget? child) {
                return CellButton(
                  isRequired: true,
                  title: '物资分类',
                  hint: value?['key'] ?? "请选择",
                  showArrow: true,
                  onPressed: addInventoryEnum != AddInventoryEnum.add
                      ? null
                      : () async {
                          int? selectIndex;
                          if (wzflList != null) {
                            selectIndex = await showSelectDialog(wzflList!.map((e) => e['key'].toString()).toList());
                          } else {
                            MaterialService.getDic('wzfl').then((value) async {
                              //[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
                              wzflList = value;
                              selectIndex = await showSelectDialog(wzflList!.map((e) => e['key'].toString()).toList());
                            });
                          }
                          if (selectIndex != null) {
                            wzflSelectNotif.value = wzflList?[selectIndex!];
                          }
                        },
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: CellTextField(
                    isRequired: true,
                    showDivider: false,
                    title: '物资名称',
                    hint: addInventoryEnum == AddInventoryEnum.add ? '请输入' : "请选择",
                    //! 输入框中的需要动态变化时不用设置content, 而直接设置controller来做内容变化的控制
                    controller: materialNameController,
                    focusNode: materialNameFocus,
                    editable: addInventoryEnum != AddInventoryEnum.add,
                  ),
                ),
                addInventoryEnum != AddInventoryEnum.add
                    ? const SizedBox.shrink()
                    : TextButton(
                        onPressed: addInventoryEnum != AddInventoryEnum.add
                            ? null
                            : () {
                                if (wzflSelectNotif.value == null) {
                                  Toast.show('请选择物资分类');
                                  return;
                                }
                                Toast.showLoading();
                                MaterialService.getMaterialListWithType(
                                  wzflSelectNotif.value!['value'].toString(),
                                  errorCallback: (error) {
                                    Toast.dismiss();
                                    Toast.failure(msg: error);
                                  },
                                ).then(
                                  (_value) {
                                    Toast.dismiss();
                                    List<String> list = _value?.map((e) => e.name ?? '').toList() ?? [];
                                    if (list.isNotEmpty) {
                                      showSelectDialog(list).then((value) {
                                        materialNameController.text = list[value!];
                                        id = _value?[value].id;
                                        materialId = _value?[value].materialId;
                                      });
                                    }
                                  },
                                );
                              },
                        child: Row(
                          children: [
                            Text(
                              '请选择',
                              style: TextStyle(
                                color: SaienteColors.black4D,
                                fontSize: ScreenAdapter.fontSize(13),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Container(
                                width: ScreenAdapter.width(12),
                                height: ScreenAdapter.height(12),
                                margin: EdgeInsets.only(
                                  left: ScreenAdapter.width(4),
                                  right: ScreenAdapter.width(3),
                                ),
                                child: const LoadAssetImage(
                                  AssetsImages.rightArrow,
                                  fit: BoxFit.fitHeight,
                                )),
                          ],
                        ),
                      ),
              ],
            ),
            const DividerLine(),
            ValueListenableBuilder(
                valueListenable: wzdwSelectNotif,
                builder: (context, Map? value, Widget? child) {
                  return CellButton(
                    isRequired: true,
                    title: '物资单位',
                    hint: value?['key'] ?? "请选择",
                    showArrow: true,
                    onPressed: addInventoryEnum != AddInventoryEnum.add
                        ? null
                        : () async {
                            int? selectIndex;
                            if (wzdwList != null) {
                              selectIndex = await showSelectDialog(wzdwList!.map((e) => e['key'].toString()).toList());
                            } else {
                              MaterialService.getDic('wzdw').then((value) async {
                                //[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
                                wzdwList = value;
                                selectIndex = await showSelectDialog(wzdwList!.map((e) => e['key'].toString()).toList());
                              });
                            }
                            if (selectIndex != null) {
                              wzdwSelectNotif.value = wzdwList?[selectIndex!];
                            }
                          },
                  );
                }),
            ValueListenableBuilder(
                valueListenable: canUseCount,
                builder: (context, String? value, Widget? child) {
                  return CellTextField(
                    isRequired: true,
                    title: '数量${value == null ? '' : ' （剩余$value）'}',
                    hint: '请输入',
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
            ValueListenableBuilder(
                valueListenable: selectDateTime,
                builder: (context, PDuration value, Widget? child) {
                  return CellButton(
                      isRequired: true,
                      title: '日期',
                      hint: '请选择',
                      content: "${value.year}-${value.month?.addZero()}-${value.day?.addZero()}",
                      onPressed: () {
                        Picker.showDatePicker(context,
                            title: '请选择时间',
                            selectDate: "${value.year}-${value.month?.addZero()}-${value.day?.addZero()}", onConfirm: (date) {
                          selectDateTime.value = date;
                        });
                      });
                }),
            CellTextArea(
              isRequired: false,
              title: "备注信息",
              hint: "请输入",
              showBottomLine: false,
              controller: remakeController,
              focusNode: remakeNameFocus,
              editable: addInventoryEnum != AddInventoryEnum.viewer,
            ),
          ],
        ),
        Builder(builder: (context) {
          String text = "";
          switch (addInventoryEnum) {
            case AddInventoryEnum.add:
            case AddInventoryEnum.addEdit:
            case AddInventoryEnum.useEdit:
            case AddInventoryEnum.scrapEdit:
              text = '提交';
            case AddInventoryEnum.use:
              text = '领用';
            case AddInventoryEnum.scrap:
              text = '报废';
            case AddInventoryEnum.viewer:
              return const SizedBox.shrink();
            case AddInventoryEnum.delete:
              text = '删除';
          }
          return Padding(
            padding: EdgeInsets.all(ScreenAdapter.width(20)),
            child: MainButton(
              text: text,
              onPressed: () {
                if (addInventoryEnum == AddInventoryEnum.use) {
                  //领用物资
                  useMaterial();
                  return;
                }
                if (addInventoryEnum == AddInventoryEnum.scrap) {
                  //物资报废
                  scrapMaterial();
                  return;
                }
                if (addInventoryEnum == AddInventoryEnum.useEdit) {
                  //编辑领用
                  editUseMaterial();
                  return;
                }
                if (addInventoryEnum == AddInventoryEnum.addEdit || addInventoryEnum == AddInventoryEnum.add) {
                  submitData();
                }
              },
            ),
          );
        }),
      ]),
    );
  }

  Future<int?> showSelectDialog(List<String> titleList) async {
    return await showModalBottomSheet<int?>(
      context: context,
      // constraints: BoxConstraints.loose(Size.fromHeight(MediaQuery.of(context).size.height * 0.5)),
      isScrollControlled: false,
      builder: (context) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = titleList[index];
            return TextButton(
              onPressed: () {
                Navigator.pop(context, index);
              },
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: const EdgeInsets.symmetric(vertical: 16).r,
                shape: const RoundedRectangleBorder(),
              ),
              child: Text(
                item,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: SaienteColors.black333333,
                ),
              ),
            );
          },
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemCount: titleList.length,
        );
      },
    );
  }

  //编辑领用
  void editUseMaterial() async {
    String api = '/api/stockrecord/receive';
    var date = selectDateTime.value;
    Map<String, dynamic> body = {
      "id": id,
      "materialId": materialId,
      "category": materialItemModel?.category,
      "unit": materialItemModel?.unit,
      "count": counterController.text,
      "date": "${date.year}-${date.month?.addZero()}-${date.day?.addZero()} ${date.hour}:${date.minute}",
      "executor": materialItemModel?.executor,
      "remark": remakeController.text,
      "rowVersion": materialItemModel?.rowVersion,
    };

    try {
      Toast.showLoading(msg: "提交中...");
      var resp = await httpsClient.put(api, data: body);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back(result: true);
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

  //初始化数据
  Future<void> initData() async {
    Map argument = Get.arguments;
    id = argument['id'];
    materialId = argument['materialId'];
    addInventoryEnum = argument['addInventoryEnum'];
    makeCount = argument['makeCount'];
    // if (addInventoryEnum == AddInventoryEnum.add || addInventoryEnum == AddInventoryEnum.use) {
    //   Storage.getData(Constant.userResData).then((res) {
    //     if (res != null) {
    //       UserResource resourceModel = UserResource.fromJson(res);
    //
    //       nikeNameNotifier.value = resourceModel.nickName ?? Constant.placeholder;
    //     }
    //   });
    // }

    await MaterialService.getDic('wzfl').then((value) {
      //[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
      wzflList = value;
    });
    await MaterialService.getDic('wzdw').then((value) {
      //{key: 其他, value: 8, sort: 8, isDeleted: false, dataType: null}
      wzdwList = value;
    });
    // 领用编辑和报废编辑回显当时的操作数量
    if (addInventoryEnum == AddInventoryEnum.useEdit || addInventoryEnum == AddInventoryEnum.scrapEdit) {
      counterController.text = makeCount ?? '';
    }
    if (materialId != null) {
      getDetails();
    }
  }

  //获取详细信息
  void getDetails() async {
    try {
      Toast.showLoading(msg: "加载中...");
      var resp = await httpsClient.get('/api/material/$materialId');
      Log.d('resp: $resp');
      Toast.dismiss();
      materialItemModel = MaterialItemModel.fromJson(resp);
      materialNameController.text = materialItemModel?.name ?? '';
      wzflSelectNotif.value = wzflList?.firstWhereOrNull(
        (e) => num.parse(e['value']).toString() == materialItemModel?.category.toString(),
      );
      wzdwSelectNotif.value = wzdwList?.firstWhereOrNull(
        (e) => num.parse(e['value']).toString() == materialItemModel?.unit.toString(),
      );
      if (addInventoryEnum != AddInventoryEnum.use &&
          addInventoryEnum != AddInventoryEnum.scrap &&
          addInventoryEnum != AddInventoryEnum.useEdit) {
        counterController.text = materialItemModel?.count.toString() ?? '';
      } else {
        canUseCount.value = materialItemModel?.count.toString() ?? '';
      }

      if (addInventoryEnum == AddInventoryEnum.addEdit || addInventoryEnum == AddInventoryEnum.viewer) {
        remakeController.text = materialItemModel?.remark ?? '';
      }

      selectDateTime.value = PDuration.parse(DateTime.parse(materialItemModel?.modified ?? ''));

      // if (addInventoryEnum != AddInventoryEnum.use || addInventoryEnum != AddInventoryEnum.edit) {
      //   nikeNameNotifier.value = materialItemModel?.createdBy ?? Constant.placeholder;
      // }
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

  //提交数据
  void submitData() async {
    if (wzflSelectNotif.value == null) {
      Toast.show('请先选择物资分类');
      return;
    }
    if (materialNameController.text.isEmpty) {
      Toast.show('请输入物资名称');
      return;
    }

    if (wzdwSelectNotif.value == null) {
      Toast.show('请先选择物资单位');
      return;
    }
    if (counterController.text.isEmpty) {
      Toast.show('请输入物资数量');
      return;
    }
    var date = selectDateTime.value;
    Toast.showLoading(msg: "提交中...");
    try {
      Map data = {
        "name": materialNameController.text,
        "category": wzflSelectNotif.value!['value'],
        "unit": wzdwSelectNotif.value!['value'],
        "count": counterController.text,
        "date": "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}",
        "remark": remakeController.text,
      };
      if (id != null) {
        data['id'] = materialId;
        data['rowVersion'] = materialItemModel?.rowVersion;
      }
      await httpsClient.post(
        '/api/stockrecord/putin',
        data: data,
      );
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back(result: true);
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

  //领用物资
  void useMaterial() async {
    if (counterController.text.isEmpty) {
      Toast.show('请输入领用物资数量');
      return;
    }
    Toast.showLoading(msg: "提交中...");
    try {
      var date = selectDateTime.value;
      await httpsClient.post(
        '/api/stockrecord/receive',
        data: {
          "materialId": materialItemModel?.materialId ?? '',
          "count": counterController.text,
          "date": "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}",
          "remark": remakeController.text,
        },
      );
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back(result: true);
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

  //物资报废
  void scrapMaterial() async {
    if (counterController.text.isEmpty) {
      Toast.show('请输入报废物资数量');
      return;
    }
    Toast.showLoading(msg: "提交中...");
    try {
      var date = selectDateTime.value;
      await httpsClient.post(
        '/api/stockrecord/scrap',
        data: {
          "materialId": materialItemModel?.materialId ?? '',
          "count": counterController.text,
          "date": "${date.year}-${date.month?.addZero()}-${date.day?.addZero()}",
          "remark": remakeController.text,
        },
      );
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      await Future.delayed(const Duration(seconds: 1));
      Get.back(result: true);
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
}
