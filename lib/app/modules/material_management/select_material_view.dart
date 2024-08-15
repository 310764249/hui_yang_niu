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
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
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

  @override
  void initState() {
    super.initState();
    getMaterialList();
  }

  @override
  Widget build(BuildContext context) {
    if (materialList == null) {
      return _loadingView();
    }
    if (materialList!.isEmpty) {
      return const EmptyView();
    }
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: materialList!.length,
          itemBuilder: (BuildContext context, int index) {
            final item = materialList![index];
            // 更加不同的分类显示不同的item样式
            return MaterialItem(
              showButton: false,
              title: '单号：${item.no ?? ''}',
              content1: item.name ?? '',
              content2: (item.created?.replaceFirst('T', ' ').substring(0, 10)) ?? '',
              content3: item.checker ?? '',
              onTap: () {
                Navigator.pop(context, item);
              },
            );
          },
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

  void getMaterialList() {
    setState(() {
      MaterialService.getMaterialListWithType(
        null,
        errorCallback: (msg) {
          Toast.show(msg);
        },
      ).then((value) {
        setState(() {
          materialList = value;
        });
      });
    });
  }
}
