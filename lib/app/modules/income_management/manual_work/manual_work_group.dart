import 'package:flutter/material.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/single_select_wrap.dart';
import 'manual_work_day.dart';
import 'manual_work_month.dart';

class ManualWorkGroup extends StatefulWidget {
  const ManualWorkGroup({super.key});

  @override
  State<ManualWorkGroup> createState() => _ManualWorkGroupState();
}

class _ManualWorkGroupState extends State<ManualWorkGroup> with AutomaticKeepAliveClientMixin {
  final PageController _pageController = PageController();
  //人工按日统计
  // /api/manualwork/daystatistics
  //人工按月统计
  // /api/manualwork/monthstatistics

  // 0日 1月
  final ValueNotifier<int> _tabIndex = ValueNotifier(0);

  @override
  void dispose() {
    _pageController.dispose();
    _tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        const SizedBox(height: 12),
        ValueListenableBuilder(
          valueListenable: _tabIndex,
          builder: (context, value, child) {
            bool isMaterial = value == 0;
            return SingleSelectWrap(
              items: const ['按日统计', "按月统计"],
              initialIndex: value,
              onChanged: (value) {
                _tabIndex.value = value;
                _pageController.jumpToPage(value);
              },
            );
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: const [ManualWorkDay(), ManualWorkMonth()],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
