import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/divider_line.dart';
import '../../../widgets/toast.dart';

class SelectRecipe {
  static void showMultiPicker(
    List items,
    context, {
    String? title = "请选择",
    String? cancel = "取消",
    String? confirm = "确定",
    int? maxSelectionCount,
    List<(int index, int? lowlimit)>? itemsSelected,
    VoidCallback? onCancel,
    void Function(List<(int index, int? lowlimit)> selected)? onConfirm,
  }) {
    List<(int index, int? lowlimit)> selectedIndex =
        itemsSelected != null ? List<(int index, int? lowlimit)>.from(itemsSelected) : [];

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
                      onCancel?.call();
                    },
                    child: Text(
                      cancel!,
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.tab_unselected,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    title!,
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(18),
                      fontWeight: FontWeight.w500,
                      color: SaienteColors.search_color,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                      onConfirm?.call(selectedIndex);
                    },
                    child: Text(
                      confirm!,
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(18),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.blue4D91F5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    final exist = selectedIndex.firstWhere(
                      (e) => e.$1 == index,
                      orElse: () => (-1, null),
                    );
                    return _MultiItem(
                      title: items[index],
                      isChecked: exist.$1 != -1,
                      initialLowLimit: exist.$2,
                      onCheckChanged: (newCheck) {
                        final exists = selectedIndex.any((e) => e.$1 == index);
                        if (newCheck) {
                          if (!exists) {
                            if (maxSelectionCount != null && selectedIndex.length >= maxSelectionCount) {
                              Toast.show("最多选择$maxSelectionCount项");
                              return false;
                            }
                            selectedIndex.add((index, null));
                          }
                        } else {
                          selectedIndex.removeWhere((e) => e.$1 == index);
                        }
                        return true;
                      },
                      onLowLimitSelected: (lowLimit) {
                        final idx = selectedIndex.indexWhere((e) => e.$1 == index);
                        if (idx != -1) {
                          int countWithLow = selectedIndex.where((e) => e.$2 != null).length;
                          bool alreadyHad = selectedIndex[idx].$2 != null;
                          if (lowLimit != null && !alreadyHad && countWithLow >= 2) {
                            Toast.show("最多有两种饲料可选择占比");
                            return false;
                          }
                          selectedIndex[idx] = (index, lowLimit);
                          return true;
                        }
                        return false;
                      },
                    );
                  },
                ),
              ),
            ),
          ]),
        );
      },
    );
  }
}

class _MultiItem extends StatefulWidget {
  final String title;
  final bool isChecked;
  final int? initialLowLimit;
  final bool Function(bool check)? onCheckChanged;
  final bool Function(int? lowLimit)? onLowLimitSelected;

  const _MultiItem({
    super.key,
    required this.title,
    required this.isChecked,
    this.initialLowLimit,
    this.onCheckChanged,
    this.onLowLimitSelected,
  });

  @override
  State<_MultiItem> createState() => _MultiItemState();
}

class _MultiItemState extends State<_MultiItem> {
  bool check = false;
  int? selectLowLimit;
  final List<int> lowLimitList = [20, 30, 40];

  @override
  void initState() {
    super.initState();
    check = widget.isChecked;
    selectLowLimit = widget.initialLowLimit;
  }

  void toggleCheck() {
    final allow = widget.onCheckChanged?.call(!check) ?? true;
    if (allow) {
      setState(() {
        check = !check;
        if (!check) {
          if (selectLowLimit != null) {
            widget.onLowLimitSelected?.call(null);
          }
          selectLowLimit = null;
        }
      });
    }
  }

  void toggleLowLimit(int limit) {
    if (!check) return;
    final isSame = limit == selectLowLimit;
    final newLimit = isSame ? null : limit;
    final allow = widget.onLowLimitSelected?.call(newLimit) ?? true;
    if (allow) {
      setState(() {
        selectLowLimit = newLimit;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: toggleCheck,
      child: Container(
        height: 50,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              width: ScreenAdapter.height(0.5),
              color: SaienteColors.separateLine,
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              widget.title,
              style: TextStyle(
                fontSize: ScreenAdapter.fontSize(18),
                color: check ? SaienteColors.blue4D91F5 : SaienteColors.tab_unselected,
              ),
            ),
            Expanded(
              child: check
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: lowLimitList.map((e) {
                        bool isSelected = e == selectLowLimit;
                        return Container(
                          width: 42,
                          height: 26,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          child: OutlinedButton(
                            onPressed: () => toggleLowLimit(e),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              backgroundColor: isSelected ? SaienteColors.blue4D91F5 : Colors.white,
                              side: isSelected ? BorderSide.none : null,
                            ),
                            child: Text(
                              "$e%",
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(12),
                                color: isSelected ? Colors.white : SaienteColors.tab_unselected,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    )
                  : const SizedBox(),
            ),
            const SizedBox(width: 20),
            Image.asset(
              check ? AssetsImages.checkedPng : AssetsImages.uncheckedPng,
            ),
          ],
        ),
      ),
    );
  }
}
