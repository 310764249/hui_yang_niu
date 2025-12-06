import 'package:flutter/material.dart';
import '../../models/stock_record_day_entity.dart';

class StockRecordDayTable extends StatelessWidget {
  final StockRecordDayEntity data;

  const StockRecordDayTable({super.key, required this.data});

  Color _color(num v) => v > 0 ? Colors.blue : (v < 0 ? Colors.red : Colors.black);

  String _fmt(num v, {bool prefix = true}) {
    if (v == 0) return "-";
    if (!prefix) return v.toString();
    return v > 0 ? "+$v" : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 5, offset: Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 日期标题
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Text(
              data.date,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          /// 表头行
          const Row(
            children: [
              Expanded(child: Text("物资名称", style: TextStyle(fontWeight: FontWeight.bold))),
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

          const SizedBox(height: 6),

          /// 行数据渲染
          ...data.list.map((e) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: Text(e.name)),

                  Expanded(
                    child: Text(
                      _fmt(e.addNum),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _color(e.addNum)),
                    ),
                  ),

                  Expanded(
                    child: Text(
                      _fmt(-e.outboundNum), // 出库为负数展示
                      textAlign: TextAlign.center,
                      style: TextStyle(color: _color(-e.outboundNum)),
                    ),
                  ),

                  Expanded(
                    child: Text(_fmt(e.currentNum, prefix: false), textAlign: TextAlign.center),
                  ),

                  Expanded(child: Text(e.unitName, textAlign: TextAlign.center)),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
