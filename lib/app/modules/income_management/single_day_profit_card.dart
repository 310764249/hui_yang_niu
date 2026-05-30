import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/colors.dart';

class DayProfitItem {
  final String name;

  /// 入库
  final double? income;

  /// 出库
  final double? payment;

  /// 当前库存
  final double profit;
  final List<String> incomeIdList;
  final List<String> payIdList;

  DayProfitItem({
    required this.name,
    this.income,
    this.payment,
    required this.profit,
    this.incomeIdList = const [],
    this.payIdList = const [],
  });
}

class SingleDayProfitCard extends StatelessWidget {
  final String date;

  /// 总入库
  final double totalIncome;

  /// 总出库
  final double totalPayment;

  final List<DayProfitItem> list;

  final void Function(DayProfitItem item)? onTap;

  const SingleDayProfitCard({
    super.key,
    required this.date,
    required this.totalIncome,
    required this.totalPayment,
    required this.list,
    this.onTap,
  });

  void _openDetail(DayProfitItem item, List<String> ids, {bool isIncome = false}) {
    if (ids.isEmpty) {
      return;
    }
    String id = ids.first;
    if (item.name.contains('人工') || item.name.contains('工资')) {
      Get.toNamed(Routes.MANUAL_ASSESS_DETAIL, arguments: id);
    } else if (item.name.contains('销售')) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else if (item.name.contains('采购')) {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    } else if (isIncome) {
      Get.toNamed(Routes.SALES_ASSESS_DETAIL, arguments: id);
    } else {
      Get.toNamed(Routes.PURCHASE_ASSESS_DETAIL, arguments: id);
    }
  }

  List<String> _allIncomeIds() {
    return list.expand((e) => e.incomeIdList).toList();
  }

  List<String> _allPayIds() {
    return list.expand((e) => e.payIdList).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 顶部日期 + 总库存统计
          Row(
            children: [
              Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () => _openDetail(
                        DayProfitItem(name: '销售', profit: 0),
                        _allIncomeIds(),
                        isIncome: true,
                      ),
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        totalIncome.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 15,
                          color: SaienteColors.appMain,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Text(' - '),
                    GestureDetector(
                      onTap: () => _openDetail(DayProfitItem(name: '采购', profit: 0), _allPayIds()),
                      behavior: HitTestBehavior.translucent,
                      child: Text(
                        totalPayment.toStringAsFixed(0),
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.red,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      ' = ${(totalIncome - totalPayment).toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 15,
                        color: SaienteColors.appMain,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // const Spacer(),
              //
              // Text(
              //   '入库 ${totalIncome.toStringAsFixed(0)}',
              //   style: const TextStyle(fontSize: 14, color: SaienteColors.appMain),
              // ),
              //
              // const SizedBox(width: 12),
              //
              // Text(
              //   '出库 ${totalPayment.toStringAsFixed(0)}',
              //   style: const TextStyle(fontSize: 14, color: Colors.red),
              // ),
            ],
          ),

          const SizedBox(height: 12),

          /// 表头
          const Row(
            children: [
              Expanded(child: Text('物资名称', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: Text(
                  '入库',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '出库',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  '当前库存',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          /// 内容列表
          ...list.map((e) {
            return GestureDetector(
              onTap: () => onTap?.call(e),
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    /// 名称
                    Expanded(child: Text(e.name)),

                    /// 入库
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openDetail(e, e.incomeIdList, isIncome: true),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          e.income == null || e.income == 0 ? '-' : e.income!.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: SaienteColors.appMain),
                        ),
                      ),
                    ),

                    /// 出库
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _openDetail(e, e.payIdList),
                        behavior: HitTestBehavior.translucent,
                        child: Text(
                          e.payment == null || e.payment == 0 ? '-' : e.payment!.toStringAsFixed(0),
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                    ),

                    /// 当前库存
                    Expanded(
                      child: Text(
                        e.profit.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: SaienteColors.appMain,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
