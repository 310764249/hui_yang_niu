import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/screenAdapter.dart';
import 'divider_line.dart';
import 'toast.dart';

class Alert {
  static void showConfirm(String msg,
      {String? title = "提示",
      String? cancel = "取消",
      String? confirm = "确定",
      VoidCallback? onCancel,
      VoidCallback? onConfirm}) {
    SmartDialog.show(
      animationType: SmartAnimationType.scale,
      builder: (context) {
        return Container(
          color: Colors.transparent,
          alignment: Alignment.center,
          child: Container(
            width: 280,
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title!,
                  maxLines: 1,
                  style: TextStyle(
                      color: SaienteColors.black28,
                      fontSize: ScreenAdapter.fontSize(19),
                      fontWeight: FontWeight.w500),
                ),
                SizedBox(height: ScreenAdapter.height(5)),
                Text(
                  msg,
                  maxLines: 3,
                  style: TextStyle(
                      color: const Color(0xFF9B9B9B),
                      fontSize: ScreenAdapter.fontSize(16)),
                ),
                SizedBox(height: ScreenAdapter.height(10)),
                const DividerLine(color: SaienteColors.separateLine),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            SmartDialog.dismiss();
                            onCancel?.call();
                          },
                          child: Text(
                            cancel!,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: SaienteColors.black4D,
                                fontSize: ScreenAdapter.fontSize(18)),
                          )),
                    ),
                    Container(
                      width: ScreenAdapter.height(0.5),
                      height: ScreenAdapter.height(30),
                      color: SaienteColors.separateLine,
                    ),
                    Expanded(
                      child: TextButton(
                          onPressed: () {
                            SmartDialog.dismiss();
                            onConfirm?.call();
                          },
                          child: Text(
                            confirm!,
                            style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: SaienteColors.appMain,
                                fontSize: ScreenAdapter.fontSize(18)),
                          )),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // 显示底部选择器
  static void showActionSheet(List<String> items,
      {String? title = "提示",
      String? cancel = "取消",
      VoidCallback? onCancel,
      void Function(int index)? onConfirm}) {
    List<Widget> itemsWidget() {
      List<Widget> list = [];
      for (var i = 0; i < items.length; i++) {
        String item = items[i];
        list.add(InkWell(
          onTap: () {
            SmartDialog.dismiss();
            onConfirm?.call(i);
          },
          child: Container(
              height: 50,
              alignment: Alignment.center,
              child: Text(
                item,
                style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(18),
                  fontWeight: FontWeight.w500,
                ),
              )),
        ));
      }
      return list;
    }

    SmartDialog.show(
        alignment: Alignment.bottomCenter,
        keepSingle: true,
        builder: (_) {
          double height = items.length * 50 + 55 + 50;
          return Container(
              width: double.infinity,
              height: height,
              color: Colors.white,
              child: Column(children: [
                Container(
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    title!,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.blue275CF3),
                  ),
                ),
                const DividerLine(color: SaienteColors.separateLine),
                Expanded(child: Column(children: itemsWidget())),
                // const DividerLine(color: SaienteColors.separateLine),
                InkWell(
                  onTap: () {
                    SmartDialog.dismiss();
                    onCancel?.call();
                  },
                  child: Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Text(
                      cancel!,
                      style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: SaienteColors.blue4D91F5,
                          fontSize: ScreenAdapter.fontSize(18)),
                    ),
                  ),
                ),
              ]));
        });
  }

  /// 显示底部多选 Picker
  /// @param items 显示的列表
  /// @param context 上下文
  /// @param itemsSelected 传入已选择的 index 列表
  /// @param maxSelectionCount 最多可选数量
  /// @param onCancel 取消按钮回调
  /// @param onConfirm 确认按钮回调 ，回传选择的 index 列表
  static void showMultiPicker(List items, context,
      {String? title = "请选择",
      String? cancel = "取消",
      String? confirm = "确定",
      int? maxSelectionCount,
      List? itemsSelected,
      VoidCallback? onCancel,
      void Function(List selected)? onConfirm}) {
    //
    List selectedIndex = itemsSelected ?? [];

    SmartDialog.show(
        alignment: Alignment.bottomCenter,
        keepSingle: true,
        builder: (_) {
          double height = 200 + 50 + 40;
          return Container(
              width: double.infinity,
              height: height,
              color: Colors.white,
              child: Column(children: [
                Container(
                    height: 50,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            SmartDialog.dismiss();
                          },
                          child: Text(
                            cancel!,
                            style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(18),
                                fontWeight: FontWeight.w500,
                                color: SaienteColors.tab_unselected),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          title!,
                          style: TextStyle(
                              fontSize: ScreenAdapter.fontSize(18),
                              fontWeight: FontWeight.w500,
                              color: SaienteColors.search_color),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            if (maxSelectionCount != null &&
                                selectedIndex.length > maxSelectionCount) {
                              Toast.show('最多可选$maxSelectionCount项');
                              return;
                            }

                            //调整排序
                            selectedIndex.sort();
                            SmartDialog.dismiss();
                            //回传已选择的数组
                            onConfirm?.call(selectedIndex);
                          },
                          child: Text(
                            confirm!,
                            style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(18),
                                fontWeight: FontWeight.w500,
                                color: SaienteColors.blue4D91F5),
                          ),
                        ),
                      ],
                    )),
                const DividerLine(color: SaienteColors.separateLine),
                Container(
                  width: double.infinity,
                  height: 200,
                  alignment: Alignment.topCenter,
                  child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MultiItem(
                            title: items[index],
                            isChecked: selectedIndex.contains(index),
                            onChanged: (value) {
                              if (selectedIndex.contains(index)) {
                                //print('remove $index');
                                selectedIndex.remove(index);
                              } else {
                                //print('add $index');
                                selectedIndex.add(index);
                              }
                            },
                          );
                        },
                      )),
                ),
              ]));
        });
  }
}

// 多选列表的选项
class MultiItem extends StatefulWidget {
  final String title;
  final bool isChecked;
  final ValueChanged<bool>? onChanged; //事件
  const MultiItem({
    super.key,
    required this.title,
    this.onChanged,
    required this.isChecked,
  });

  @override
  State<MultiItem> createState() => _MultiItemState();
}

class _MultiItemState extends State<MultiItem> {
  late bool check;

  @override
  void initState() {
    super.initState();
    check = widget.isChecked;
    //print('check $check');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          check = !check;
          widget.onChanged?.call(check);
        });
      },
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
              width: ScreenAdapter.height(0.5),
              color: SaienteColors.separateLine),
        )),
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(18),
                  color: check
                      ? SaienteColors.blue4D91F5
                      : SaienteColors.tab_unselected),
            ),
            const Spacer(),
            Image.asset(
              check ? AssetsImages.checkedPng : AssetsImages.uncheckedPng,
            )
          ],
        ),
      ),
    );
  }
}
