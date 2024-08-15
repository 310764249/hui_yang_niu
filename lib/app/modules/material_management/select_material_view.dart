import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/material_item_model.dart';
import 'package:intellectual_breed/app/modules/material_management/material_service.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:shimmer/shimmer.dart';

import 'material_item.dart';

class SelectMaterialView extends StatefulWidget {
  const SelectMaterialView({super.key});

  static Future<MaterialItemModel?> push(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      constraints: BoxConstraints.loose(Size.fromHeight(MediaQuery.of(context).size.height * 0.8)),
      builder: (context) => const SelectMaterialView(),
    );
  }

  @override
  State<SelectMaterialView> createState() => _SelectMaterialViewState();
}

class _SelectMaterialViewState extends State<SelectMaterialView> {
  List<MaterialItemModel>? materialList;
  List? wzflList;

  var selectType;

  Map<String, dynamic> materialListMap = {};

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('选择物料'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Row(
          children: [
            if (wzflList == null)
              const SizedBox(width: 70)
            else
              SizedBox(
                width: 70,
                child: ListView(
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() => selectType = null);
                        getMaterialList();
                      },
                      style: TextButton.styleFrom(
                          backgroundColor: selectType == null ? SaienteColors.gray0D : Colors.white,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.zero),
                          )),
                      child: const Text('全部'),
                    ),
                    ...wzflList!
                        .map(
                          (e) {
                            bool isSelected = e['key'] == selectType?['key'];
                            return TextButton(
                              onPressed: () {
                                setState(() => selectType = e);
                                getMaterialList();
                              },
                              style: TextButton.styleFrom(
                                  backgroundColor: isSelected ? SaienteColors.gray0D : Colors.white,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.zero),
                                  )),
                              child: Text(e['key']),
                            );
                          },
                        )
                        .toList()
                        .reversed,
                  ],
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0).copyWith(top: 20),
                child: Builder(builder: (context) {
                  if (materialList == null) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: _loadingView(),
                    );
                  }
                  if (materialList!.isEmpty) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: const EmptyView(),
                    );
                  }
                  return ListView.builder(
                    itemCount: materialList!.length,
                    itemBuilder: (BuildContext context, int index) {
                      final item = materialList![index];
                      // 更加不同的分类显示不同的item样式
                      return MaterialItem(
                        showButton: false,
                        showTitle: false,
                        title: '',
                        content1: item.name ?? '',
                        content2: (item.created?.replaceFirst('T', ' ').substring(0, 10)) ?? '',
                        content3: item.checker ?? '',
                        onTap: () {
                          Navigator.pop(context, item);
                        },
                      );
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 列表初始化加载的骨架loading
  Widget _loadingView() {
    return Container(
      color: SaienteColors.backGrey,
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color.fromARGB(255, 184, 185, 227),
        child: ListView.builder(
          // 禁止列表滑动
          physics: const NeverScrollableScrollPhysics(),
          // 数量为: 屏幕高度 / item高度 取整数
          itemCount: ScreenAdapter.getScreenHeight() ~/ ScreenAdapter.height(126),
          itemBuilder: (context, index) {
            return Container(
              height: ScreenAdapter.height(126),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), ScreenAdapter.height(0)),
              decoration: BoxDecoration(
                //背景
                color: const Color(0xFFE0E0E0),
                //设置四周圆角 角度
                borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(10.0))),
              ),
            );
          },
        ),
      ),
    );
  }

  Future getMaterialList() async {
    if (selectType == null) {
      if (materialListMap['全部'] != null) {
        setState(() {
          materialList = materialListMap['全部'];
        });
        return;
      }
    } else {
      if (materialListMap[selectType!['key']] != null) {
        setState(() {
          materialList = materialListMap[selectType!['key']];
        });
        return;
      }
    }
    await MaterialService.getMaterialListWithType(
      selectType == null ? null : selectType!['value'],
      errorCallback: (msg) {
        Toast.show(msg);
      },
    ).then((value) {
      setState(() {
        materialList = value;
      });
      materialListMap[selectType == null ? '全部' : selectType!['key']] = value;
    });
  }

  void init() async {
    ////[key: 其他, value: 6, sort: 6, isDeleted: false, dataType: null]
    await MaterialService.getDic('wzfl').then(
      (value) {
        setState(() {
          wzflList = value;
        });
      },
    );
    await getMaterialList();
  }
}
