import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_day_view.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_month.dart';
import 'package:intellectual_breed/app/widgets/radio_button_group.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/single_select_wrap.dart';

class StockRecordGroup extends StatefulWidget {
  const StockRecordGroup({super.key});

  @override
  State<StockRecordGroup> createState() => _StockRecordGroupState();
}

class _StockRecordGroupState extends State<StockRecordGroup> with AutomaticKeepAliveClientMixin {
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
            physics: const NeverScrollableScrollPhysics(),
            children: const [StockRecordDayView(), StockRecordMonth()],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
