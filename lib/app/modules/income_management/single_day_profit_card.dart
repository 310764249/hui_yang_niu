import 'package:flutter/material.dart';

class DayProfitItem {
  final String name;
  final double? income;
  final double? payment;
  final double profit;

  DayProfitItem({required this.name, this.income, this.payment, required this.profit});
}

class SingleDayProfitCard extends StatelessWidget {
  final String date;
  final double totalIncome;
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

  Color _amountColor(double v) => v > 0 ? Colors.blue : Colors.red;

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
          /// 顶部标题 + 总收入/支出
          Row(
            children: [
              Text(date, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Spacer(),
              Text(
                '${totalIncome > 0 ? '+' : ''}${totalIncome.toStringAsFixed(0)}元',
                style: const TextStyle(fontSize: 14, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Text(
                '${totalPayment > 0 ? '-' : ''}${totalPayment.abs().toStringAsFixed(0)}元',
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 表头
          const Row(
            children: [
              Expanded(child: Text('物资名称', style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: Text(
                  '收入（元）',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '支出（元）',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  '盈利',
                  style: TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
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
                    Expanded(child: Text(e.name)),
                    Expanded(
                      child: Text(
                        e.income == null || e.income == 0
                            ? '-'
                            : '+${e.income!.toStringAsFixed(0)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.payment == null || e.payment == 0
                            ? '-'
                            : '-${e.payment!.abs().toStringAsFixed(0)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        e.profit > 0
                            ? '+${e.profit.toStringAsFixed(0)}'
                            : e.profit.toStringAsFixed(0),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _amountColor(e.profit)),
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
