import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import '../../models/stock_record_day_entity.dart';
import '../material_management/add_inventory.dart';

class StockRecordDayTable extends StatelessWidget {
  final StockRecordDayEntity data;

  const StockRecordDayTable({super.key, required this.data});

  Color _color(num v) => v > 0 ? SaienteColors.appMain : (v < 0 ? Colors.red : Colors.black);

  String _fmt(num v, {bool prefix = true}) {
    if (v == 0) return "-";
    if (!prefix) return v.toString();
    return v > 0 ? "+$v" : v.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),

          /// 表头行
          const Row(
            children: [
              SizedBox(
                width: 100,
                child: FittedBox(
                  alignment: Alignment.centerLeft,
                  fit: BoxFit.scaleDown,
                  child: Text('物资名称', maxLines: 2),
                ),
              ),

              Expanded(
                child: Text(
                  "入库",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Expanded(
                child: Text(
                  "出库",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Expanded(
                child: Text(
                  "库存",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
              Expanded(
                child: Text(
                  "单位",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// 行数据渲染
          ...data.list.map((e) {
            return GestureDetector(
              onTap: () {
                // AddInventoryView.push(
                //   context,
                //   id: item.id,
                //   materialId: item.materialId,
                //   addInventoryEnum: AddInventoryEnum.viewer,
                //   remark: item.remark,
                // );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: FittedBox(
                        alignment: Alignment.centerLeft,
                        fit: BoxFit.scaleDown,
                        child: Text(e.name, maxLines: 2, style: const TextStyle(fontSize: 14)),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        _fmt(e.addNum),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _color(e.addNum), fontSize: 14),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        _fmt(-e.outboundNum), // 出库为负数展示
                        textAlign: TextAlign.center,
                        style: TextStyle(color: _color(-e.outboundNum), fontSize: 14),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        _fmt(e.currentNum, prefix: false),
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),

                    Expanded(
                      child: Text(
                        e.unitName,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
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
