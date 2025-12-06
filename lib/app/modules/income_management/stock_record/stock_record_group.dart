import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_day_view.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_month.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';

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
        ValueListenableBuilder(
          valueListenable: _tabIndex,
          builder: (context, value, child) {
            bool isMaterial = value == 0;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SizedBox(
                height: 34,
                child: Row(
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          isMaterial ? SaienteColors.appMain : SaienteColors.desc_color,
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenAdapter.width(2)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _tabIndex.value = 0;
                        _pageController.animateToPage(
                          0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        '按日统计',
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenAdapter.width(10)),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          isMaterial ? SaienteColors.desc_color : SaienteColors.appMain,
                        ),
                        foregroundColor: MaterialStateProperty.all(Colors.white),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(ScreenAdapter.width(2)),
                          ),
                        ),
                      ),
                      onPressed: () {
                        _tabIndex.value = 1;
                        _pageController.animateToPage(
                          1,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text(
                        '按月统计',
                        style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Expanded(
          child: PageView(
            controller: _pageController,
            children: const [StockRecordDayView(), StockRecordMonth()],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
