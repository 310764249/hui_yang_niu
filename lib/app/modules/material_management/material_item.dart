import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';

class MaterialItem extends StatelessWidget {
  const MaterialItem({
    super.key,
    required this.title,
    required this.content1,
    required this.content2,
    required this.content3,
    this.showButton = true,
    this.showTitle = true,
    this.deleteOnTap,
    this.editOnTap,
    this.onTap,
  });

  final String title;

  final String content1;
  final String content2;
  final String content3;

  //是否显示按钮
  final bool showButton;

  final VoidCallback? onTap;
  final VoidCallback? editOnTap;
  final VoidCallback? deleteOnTap;

  //是否显示title
  final bool showTitle;

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        // height: ScreenAdapter.height(130),
        margin: EdgeInsets.only(bottom: ScreenAdapter.height(10)),
        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
        decoration: BoxDecoration(
          //背景
          color: Colors.white,
          //设置四周圆角 角度
          borderRadius: BorderRadius.all(Radius.circular(ScreenAdapter.height(10.0))),
          //设置四周边框
          border: Border.all(width: ScreenAdapter.width(1.0), color: Colors.transparent),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: ScreenAdapter.height(10)),
            if (showTitle)
              Row(
                children: [
                  Container(
                    width: ScreenAdapter.width(3),
                    height: ScreenAdapter.height(13.5),
                    decoration: BoxDecoration(
                      color: SaienteColors.blue275CF3,
                      borderRadius: BorderRadius.circular(ScreenAdapter.width(1.5)),
                    ),
                  ),
                  SizedBox(width: ScreenAdapter.width(5)),
                  Text(
                    title,
                    style: TextStyle(fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w400, color: Colors.black),
                  ),
                ],
              ),
            SizedBox(height: ScreenAdapter.height(14)),
            Row(
              children: [
                Expanded(
                    child: Column(children: [
                  Text(
                    content1, //,
                    style: TextStyle(
                        color: SaienteColors.blackE5, fontWeight: FontWeight.w500, fontSize: ScreenAdapter.fontSize(14)),
                  ),
                  SizedBox(height: ScreenAdapter.height(3)),
                  Text(
                    '物资名称',
                    style: TextStyle(color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(14)),
                  )
                ])),
                Container(
                  color: SaienteColors.separateLine,
                  width: ScreenAdapter.width(1),
                  height: ScreenAdapter.height(36),
                ),
                Expanded(
                    child: Column(children: [
                  Text(
                    content2,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: SaienteColors.blackE5, fontWeight: FontWeight.w500, fontSize: ScreenAdapter.fontSize(14)),
                  ),
                  SizedBox(height: ScreenAdapter.height(3)),
                  Text(
                    ' 日期',
                    style: TextStyle(color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(14)),
                  )
                ])),
                Container(
                  color: SaienteColors.separateLine,
                  width: ScreenAdapter.width(1),
                  height: ScreenAdapter.height(36),
                ),
                Expanded(
                    child: Column(children: [
                  Text(
                    content3,
                    style: TextStyle(
                        color: SaienteColors.blackE5, fontWeight: FontWeight.w500, fontSize: ScreenAdapter.fontSize(14)),
                  ),
                  SizedBox(height: ScreenAdapter.height(3)),
                  Text(
                    '操作人',
                    style: TextStyle(color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(14)),
                  )
                ]))
              ],
            ),
            SizedBox(height: ScreenAdapter.height(5)),
            showButton
                ? SizedBox(
                    width: ScreenAdapter.getScreenWidth(),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                // 阴影颜色
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                backgroundColor: MaterialStateProperty.all(SaienteColors.blueE5EEFF),
                                foregroundColor: MaterialStateProperty.all(SaienteColors.blue275CF3),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenAdapter.width(2.5))))),
                            onPressed: () {
                              debugPrint('编辑');
                              editOnTap?.call();
                            },
                            child: Text(
                              '编辑',
                              style: TextStyle(fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: ScreenAdapter.width(10),
                        ),
                        Expanded(
                          child: ElevatedButton(
                            style: ButtonStyle(
                                // 阴影颜色
                                shadowColor: MaterialStateProperty.all(Colors.transparent),
                                backgroundColor: MaterialStateProperty.all(SaienteColors.blueE5EEFF),
                                foregroundColor: MaterialStateProperty.all(SaienteColors.blue275CF3),
                                shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(ScreenAdapter.width(2.5))))),
                            onPressed: () {
                              Alert.showConfirm(
                                '确定删除该事件?',
                                onConfirm: () {
                                  //debugPrint('删除');
                                  deleteOnTap?.call();
                                },
                              );
                            },
                            child: Text(
                              '删除',
                              style: TextStyle(fontSize: ScreenAdapter.fontSize(14), fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      ],
                    ))
                : const Divider(),
          ],
        ),
      ),
    );
  }
}
