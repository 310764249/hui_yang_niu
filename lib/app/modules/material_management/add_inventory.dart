import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/models/user_resource.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/ex_int.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/services/storage.dart';
import 'package:intellectual_breed/app/widgets/cell_button.dart';
import 'package:intellectual_breed/app/widgets/cell_text_area.dart';
import 'package:intellectual_breed/app/widgets/cell_text_field.dart';
import 'package:intellectual_breed/app/widgets/main_button.dart';
import 'package:intellectual_breed/app/widgets/my_card.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

//枚举
enum AddInventoryEnum {
  //添加
  add,
  //编辑
  edit,
  //查看
  viewer,
  //删除
  delete,
  //领用
  use,
  //报废
  scrap,
}

extension AddInventoryEnumX on AddInventoryEnum {
  getName() {
    switch (this) {
      case AddInventoryEnum.add:
        return '入库';
      case AddInventoryEnum.edit:
        return '编辑';
      case AddInventoryEnum.viewer:
        return '物资';
      case AddInventoryEnum.delete:
        return '删除';
      case AddInventoryEnum.use:
        return '领用';
      case AddInventoryEnum.scrap:
        return '报废';
    }
  }
}

class AddInventoryView extends StatefulWidget {
  const AddInventoryView({super.key});

  static Future push(
    BuildContext context, {
    AddInventoryEnum addInventoryEnum = AddInventoryEnum.add,
    String? id,
  }) async {
    return await Get.toNamed(
      Routes.AddInventory,
      arguments: {
        'addInventoryEnum': addInventoryEnum,
        'id': id,
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
  ValueNotifier<String> nikeNameNotifier = ValueNotifier(Constant.placeholder);

  //可领用的总量
  ValueNotifier<String?> canUseCount = ValueNotifier(null);

  //物资id
  String? id;

  //是否编辑
  late AddInventoryEnum addInventoryEnum;

  //物资信息
  MaterialItemModel? materialItemModel;

  @override
  void initState() {
    super.initState();
    initData();
  }

  Future<void> initData() async {
    Map argument = Get.arguments;
    id = argument['id'];
    addInventoryEnum = argument['addInventoryEnum'];
    if (addInventoryEnum == AddInventoryEnum.add || addInventoryEnum == AddInventoryEnum.use) {
      Storage.getData(Constant.userResData).then((res) {
        if (res != null) {
          UserResource resourceModel = UserResource.fromJson(res);

          nikeNameNotifier.value = resourceModel.nickName ?? Constant.placeholder;
        }
      });
    }

    await MaterialService.getDic('wzfl').then((value) {
      //[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
      wzflList = value;
    });
    await MaterialService.getDic('wzdw').then((value) {
      //{key: 其他, value: 8, sort: 8, isDeleted: false, dataType: null}
      wzdwList = value;
    });
    if (id != null) {
      getDetails();
    }
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
      if (addInventoryEnum != AddInventoryEnum.use && addInventoryEnum != AddInventoryEnum.scrap) {
        counterController.text = materialItemModel?.count.toString() ?? '';
      } else {
        canUseCount.value = materialItemModel?.count.toString() ?? '';
      }

      if (addInventoryEnum == AddInventoryEnum.edit || addInventoryEnum == AddInventoryEnum.viewer) {
        remakeController.text = materialItemModel?.remark ?? '';
      }

      if (addInventoryEnum != AddInventoryEnum.use || addInventoryEnum != AddInventoryEnum.edit) {
        nikeNameNotifier.value = materialItemModel?.createdBy ?? Constant.placeholder;
      }
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
    if (materialNameController.text.isEmpty) {
      Toast.show('请输入物资名称');
      return;
    }
    if (wzflSelectNotif.value == null) {
      Toast.show('请先选择物资分类');
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
    var date = DateTime.now();
    Toast.showLoading(msg: "提交中...");
    try {
      Map data = {
        "name": materialNameController.text,
        "category": wzflSelectNotif.value!['value'],
        "unit": wzdwSelectNotif.value!['value'],
        "count": counterController.text,
        "date": "${date.year}-${date.month.addZero()}-${date.day.addZero()}",
        "executor": nikeNameNotifier.value,
        "remark": remakeController.text,
      };
      if (id != null) {
        data['id'] = id;
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
      var date = DateTime.now();
      await httpsClient.post(
        '/api/stockrecord/receive',
        data: {
          "materialId": materialItemModel?.materialId ?? '',
          "count": counterController.text,
          "date": "${date.year}-${date.month.addZero()}-${date.day.addZero()}",
          "executor": nikeNameNotifier.value,
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
      var date = DateTime.now();
      await httpsClient.post(
        '/api/stockrecord/scrap',
        data: {
          "materialId": materialItemModel?.materialId ?? '',
          "count": counterController.text,
          "date": "${date.year}-${date.month.addZero()}-${date.day.addZero()}",
          "executor": nikeNameNotifier.value,
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
              editable: addInventoryEnum == AddInventoryEnum.add,
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
                    title: '数量' + (value == null ? '' : ' （剩余${value}）'),
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
            case AddInventoryEnum.edit:
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
                if (addInventoryEnum == AddInventoryEnum.edit || addInventoryEnum == AddInventoryEnum.add) {
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
}
