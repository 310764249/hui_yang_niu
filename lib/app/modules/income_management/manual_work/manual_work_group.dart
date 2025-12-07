import 'package:flutter/material.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
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
                          isMaterial
                              ? SaienteColors.appMain
                              : SaienteColors.desc_color.withValues(alpha: 0.6),
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
            children: const [ManualWorkDay(), ManualWorkMonth()],
          ),
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
