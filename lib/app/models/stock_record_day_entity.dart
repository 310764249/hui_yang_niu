class StockRecordDayEntity {
  final String date; // 例如：2025-11-12
  final List<StockRecordItemEntity> list;

  StockRecordDayEntity({required this.date, required this.list});

  factory StockRecordDayEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordDayEntity(
      date: json['date'] ?? '',
      list:
          (json['list'] as List<dynamic>? ?? [])
              .map((e) => StockRecordItemEntity.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {"date": date, "list": list.map((e) => e.toJson()).toList()};
  }
}

class StockRecordItemEntity {
  final String name; // 物资名称，例如：牛ASD
  final String unitName; // 单位，例如：个
  final int addNum; // 入库数量
  final int outboundNum; // 出库数量
  final int currentNum; // 当前库存数量

  StockRecordItemEntity({
    required this.name,
    required this.unitName,
    required this.addNum,
    required this.outboundNum,
    required this.currentNum,
  });

  factory StockRecordItemEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordItemEntity(
      name: json['name'] ?? '',
      unitName: json['unitName'] ?? '',
      addNum: (json['addNum'] ?? 0).toInt(),
      outboundNum: (json['outboundNum'] ?? 0).toInt(),
      currentNum: (json['currentNum'] ?? 0).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "unitName": unitName,
      "addNum": addNum,
      "outboundNum": outboundNum,
      "currentNum": currentNum,
    };
  }
}
