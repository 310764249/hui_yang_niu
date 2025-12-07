import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/modules/income_management/stock_record/stock_record_group.dart';

import '../../services/colors.dart';
import '../../services/screenAdapter.dart';
import 'manual_work/manual_work_group.dart';

class IncomeManagementPage extends StatefulWidget {
  const IncomeManagementPage({super.key});

  @override
  State<IncomeManagementPage> createState() => _IncomeManagementPageState();
}

class _IncomeManagementPageState extends State<IncomeManagementPage> {
  PageController pageController = PageController();

  // 库存按日统计
  // /api/stockrecord/daystatistics?PageIndex=1&PageSize=10
  // 库存按月统计
  // /api/stockrecord/monthstatistics?PageIndex=1&PageSize=10

  // 0物资统计 1资金统计
  ValueNotifier<int> currentIndex = ValueNotifier(0);

  @override
  void dispose() {
    pageController.dispose();
    currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('收支管理'), centerTitle: true),
      body: Column(
        children: [
          ValueListenableBuilder(
            valueListenable: currentIndex,
            builder: (context, value, child) {
              bool isMaterial = value == 0;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isMaterial
                                ? SaienteColors.appMain
                                : SaienteColors.desc_color.withValues(alpha: 0.6),
                          ),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          currentIndex.value = 0;
                          pageController.animateToPage(
                            0,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          '物资统计',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(17),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenAdapter.width(10)),
                    Expanded(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                            isMaterial ? SaienteColors.desc_color : SaienteColors.appMain,
                          ),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                            ),
                          ),
                        ),
                        onPressed: () {
                          currentIndex.value = 1;
                          pageController.animateToPage(
                            1,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: Text(
                          '资金统计',
                          style: TextStyle(
                            fontSize: ScreenAdapter.fontSize(17),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: PageView(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              children: const [StockRecordGroup(), ManualWorkGroup()],
            ),
          ),
        ],
      ),
    );
  }
}
