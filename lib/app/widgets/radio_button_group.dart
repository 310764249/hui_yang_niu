import 'package:flutter/material.dart';

import '../models/common_data.dart';
import '../services/colors.dart';
import '../services/screenAdapter.dart';
import 'divider_line.dart';

///
/// 单选按钮 RadioButton
///
class RadioButtonGroup extends StatefulWidget {
  // 是否必填, 来控制是否显示红点
  final bool isRequired;
  // 标题
  final String title;
  // 数据列表
  final List<String> items;
  // 选中的index
  final int? selectedIndex;
  // 是否显示底部分割线
  final bool? showBottomLine;
  // 切换item时的监听
  final ValueChanged onChanged;

  const RadioButtonGroup({
    super.key,
    required this.isRequired,
    required this.title,
    required this.items,
    this.selectedIndex,
    this.showBottomLine = true,
    required this.onChanged,
  });

  @override
  State<RadioButtonGroup> createState() => _RadioButtonGroupState();
}

class _RadioButtonGroupState extends State<RadioButtonGroup> {
  // 传入数据后转换成CommonData的list
  List<CommonData> commonList = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.items.length; i++) {
      commonList.add(CommonData(
          id: i, name: widget.items[i], isSelected: i == widget.selectedIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    // 用于主动设置更新RadioButton值后的选中状态设置
    if (widget.items.isNotEmpty && widget.selectedIndex != null) {
      for (int i = 0; i < widget.items.length; i++) {
        if (i == widget.selectedIndex) {
          commonList[i].isSelected = true;
        } else {
          commonList[i].isSelected = false;
        }
      }
    }

    return Column(
      children: [
        SizedBox(height: ScreenAdapter.height(12)),
        // Title
        Row(children: [
          SizedBox(width: ScreenAdapter.width(12)),
          Text("*",
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w700,
                  color: widget.isRequired ? Colors.red : Colors.transparent)),
          Text(widget.title,
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(14),
                  fontWeight: FontWeight.w500,
                  color: SaienteColors.blackE5)),
        ]),
        SizedBox(height: ScreenAdapter.height(12)),
        // Radio buttons
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
              ScreenAdapter.width(12), 0, ScreenAdapter.width(12), 0),
          child: Wrap(
            spacing: ScreenAdapter.width(10),
            runSpacing: ScreenAdapter.width(10),
            children: [
              for (int index = 0; index < commonList.length; index++)
                InkWell(
                  onTap: () {
                    // 如果点击的是当前已选中的item则直接return
                    if (commonList[index].isSelected ?? false) return;
                    // 更新选中状态
                    setState(() {
                      for (int i = 0; i < commonList.length; i++) {
                        commonList[i].isSelected = i == index;
                      }
                    });
                    // 响应点击事件
                    widget.onChanged(index);
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(
                        ScreenAdapter.width(9),
                        ScreenAdapter.height(9),
                        ScreenAdapter.width(9),
                        ScreenAdapter.height(9)),
                    decoration: BoxDecoration(
                        color: commonList[index].isSelected ?? false
                            ? SaienteColors.blueE5EEFF
                            : const Color(0xFFF5F7FB),
                        border: Border.all(
                            color: commonList[index].isSelected ?? false
                                ? SaienteColors.blue275CF3
                                : Colors.transparent,
                            width: 0.5),
                        borderRadius: BorderRadius.all(
                            Radius.circular(ScreenAdapter.width(4)))),
                    child: Text(
                      commonList[index].name,
                      style: TextStyle(
                          color: commonList[index].isSelected ?? false
                              ? SaienteColors.blue275CF3
                              : SaienteColors.blackB2),
                    ),
                  ),
                )
            ],
          ),
        ),
        SizedBox(height: ScreenAdapter.height(12)),
        // Bottom line
        widget.showBottomLine ?? true ? const DividerLine() : const SizedBox()
      ],
    );
  }
}
