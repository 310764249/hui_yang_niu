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
  final String id;
  final String materialId;
  final String name; // 物资名称，例如：牛ASD
  final String unitName; // 单位，例如：个
  final int addNum; // 入库数量
  final int outboundNum; // 出库数量
  final int currentNum; // 当前库存数量
  final List<String> addIdList;
  final List<String> outboundIdList;

  StockRecordItemEntity({
    required this.id,
    required this.materialId,
    required this.name,
    required this.unitName,
    required this.addNum,
    required this.outboundNum,
    required this.currentNum,
    required this.addIdList,
    required this.outboundIdList,
  });

  factory StockRecordItemEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordItemEntity(
      id: json['id'] ?? '',
      materialId: json['materialId'] ?? '',
      name: json['name'] ?? '',
      unitName: json['unitName'] ?? '',
      addNum: (json['addNum'] ?? 0).toInt(),
      outboundNum: (json['outboundNum'] ?? 0).toInt(),
      currentNum: (json['currentNum'] ?? 0).toInt(),
      addIdList: _parseIdList(json['addIdList'] ?? json['putinIdList'] ?? json['incomeIdList']),
      outboundIdList: _parseIdList(json['outboundIdList'] ?? json['receiveIdList'] ?? json['payIdList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "materialId": materialId,
      "name": name,
      "unitName": unitName,
      "addNum": addNum,
      "outboundNum": outboundNum,
      "currentNum": currentNum,
      "addIdList": addIdList,
      "outboundIdList": outboundIdList,
    };
  }
}

List<String> _parseIdList(dynamic value) {
  if (value is List) {
    return value.where((e) => e != null && e.toString().isNotEmpty).map((e) => e.toString()).toList();
  }
  if (value is String && value.isNotEmpty) {
    return value.split(',').where((e) => e.isNotEmpty).toList();
  }
  return [];
}
