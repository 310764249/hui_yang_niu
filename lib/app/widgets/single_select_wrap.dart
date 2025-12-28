import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

class SingleSelectWrap extends StatefulWidget {
  /// 显示的文案列表
  final List<String> items;

  /// 默认选中的 index
  final int initialIndex;

  /// 选中回调
  final ValueChanged<int> onChanged;

  const SingleSelectWrap({
    super.key,
    required this.items,
    this.initialIndex = 0,
    required this.onChanged,
  });

  @override
  State<SingleSelectWrap> createState() => _SingleSelectWrapState();
}

class _SingleSelectWrapState extends State<SingleSelectWrap> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(ScreenAdapter.width(12), 0, ScreenAdapter.width(12), 0),
      child: Wrap(
        spacing: ScreenAdapter.width(10),
        runSpacing: ScreenAdapter.width(10),
        children: List.generate(widget.items.length, (index) {
          final bool isSelected = index == _selectedIndex;

          return InkWell(
            onTap: () {
              if (isSelected) return;

              setState(() {
                _selectedIndex = index;
              });

              widget.onChanged(index);
            },
            borderRadius: BorderRadius.circular(ScreenAdapter.width(4)),
            child: Container(
              padding: EdgeInsets.fromLTRB(
                ScreenAdapter.width(9),
                ScreenAdapter.height(9),
                ScreenAdapter.width(9),
                ScreenAdapter.height(9),
              ),
              decoration: BoxDecoration(
                color: isSelected ? SaienteColors.blueE5EEFF : const Color(0xFFF5F7FB),
                border: Border.all(
                  color: isSelected ? SaienteColors.blue275CF3 : Colors.transparent,
                  width: 0.5,
                ),
                borderRadius: BorderRadius.circular(ScreenAdapter.width(4)),
              ),
              child: Text(
                widget.items[index],
                style: TextStyle(
                  color: isSelected ? SaienteColors.blue275CF3 : SaienteColors.blackB2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
