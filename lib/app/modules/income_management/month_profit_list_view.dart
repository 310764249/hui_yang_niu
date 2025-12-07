import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/colors.dart';

import '../../models/manual_work_month_entity.dart';

class MonthProfitListView extends StatelessWidget {
  final ManualWorkMonthEntity data;
  final void Function(MonthCategoryDetailEntity item)? onTap;

  const MonthProfitListView({super.key, required this.data, this.onTap});

  Color _color(double v) => v > 0 ? SaienteColors.appMain : Colors.red;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 月份 Header
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            children: [
              Text(
                "${data.date}月",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              Text(
                "+${data.income.toStringAsFixed(0)}元",
                style: const TextStyle(fontSize: 14, color: SaienteColors.appMain),
              ),
              const SizedBox(width: 12),
              Text(
                "-${data.payment.toStringAsFixed(0)}元",
                style: const TextStyle(fontSize: 14, color: Colors.red),
              ),
            ],
          ),
        ),

        /// 分类列表
        ...data.categoryList.map((category) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 分类名称 + 分类合计
                Row(
                  children: [
                    Text(
                      category.categoryName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: SaienteColors.appMain,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "${category.payment > 0 ? '-' : ''}${category.payment.abs().toStringAsFixed(0)}元",
                      style: TextStyle(fontSize: 13, color: _color(-category.payment)),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// 表头
                const Row(
                  children: [
                    Expanded(child: Text("物资名称", style: TextStyle(fontWeight: FontWeight.bold))),
                    Expanded(
                      child: Text(
                        "收入（元）",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "支出（元）",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "盈利",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// 三级明细
                ...category.list.map((e) {
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
                              e.income > 0 ? "+${e.income.toStringAsFixed(0)}" : "-",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: SaienteColors.appMain),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.payment > 0 ? "-${e.payment.toStringAsFixed(0)}" : "-",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                          Expanded(
                            child: Text(
                              e.profit > 0
                                  ? "+${e.profit.toStringAsFixed(0)}"
                                  : e.profit.toStringAsFixed(0),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: _color(e.profit)),
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
        }),
      ],
    );
  }
}
