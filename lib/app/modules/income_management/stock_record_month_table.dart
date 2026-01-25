import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import '../../models/stock_record_month_entity.dart';

class StockRecordMonthTable extends StatelessWidget {
  final StockRecordMonthEntity data;

  const StockRecordMonthTable({super.key, required this.data});

  Color _color(num v) => v > 0 ? SaienteColors.appMain : (v < 0 ? Colors.red : Colors.black);

  String _fmt(num? v, {bool prefix = true}) {
    if (v == null || v == 0) return "-";
    if (!prefix) return v.toString();
    return v > 0 ? "+$v" : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// 月份标题
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            "${data.date}月库存明细",
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),

        /// 表头
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(6),
          ),
          child: const Row(
            children: [
              SizedBox(
                width: 100,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text('分类/物资', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              Expanded(
                child: Text(
                  "入库",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "出库",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "库存",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: Text(
                  "单位",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        /// 分类列表
        ...?data.categoryList?.map((category) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [
                BoxShadow(color: Color(0x14000000), blurRadius: 5, offset: Offset(0, 2)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 分类名称
                ///
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    category.categoryName ?? "",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: SaienteColors.appMain,
                    ),
                  ),
                ),

                /// 物资明细
                ...?category.list?.map((item) {
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 100,
                          child: FittedBox(
                            alignment: Alignment.centerLeft,
                            fit: BoxFit.scaleDown,
                            child: Text(item.name ?? "-"),
                          ),
                        ),

                        Expanded(
                          child: Text(
                            _fmt(item.addNum),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _color(item.addNum ?? 0)),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _fmt(-(item.outboundNum ?? 0)), // 出库显示为负数
                            textAlign: TextAlign.center,
                            style: TextStyle(color: _color(-(item.outboundNum ?? 0))),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            _fmt(item.currentNum, prefix: false),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(child: Text(item.unitName ?? "-", textAlign: TextAlign.center)),
                      ],
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
