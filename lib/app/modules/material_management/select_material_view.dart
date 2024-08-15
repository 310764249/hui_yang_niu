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
    return Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
          //从底下弹出
          return FadeTransition(
            opacity: animation,
            child: const SelectMaterialView(),
          );
        },
      ),
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
    return ListView.builder(
      itemCount: materialList!.length,
      itemBuilder: (BuildContext context, int index) {
        final item = materialList![index];
        // 更加不同的分类显示不同的item样式
        return MaterialItem(
          showButton: false,
          title: item.id ?? '',
          content1: item.materialName ?? '',
          content2: (item.date?.replaceFirst('T', ' ').substring(0, 10)) ?? '',
          content3: item.executor ?? '',
          onTap: () {},
        );
      },
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
