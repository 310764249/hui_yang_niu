class StockRecordMonthEntity {
  String? date;
  List<StockRecordCategoryEntity>? categoryList;

  StockRecordMonthEntity({this.date, this.categoryList});

  factory StockRecordMonthEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordMonthEntity(
      date: json['date']?.toString(),
      categoryList:
          (json['categoryList'] as List<dynamic>?)
              ?.map((e) => StockRecordCategoryEntity.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'date': date, 'categoryList': categoryList?.map((e) => e.toJson()).toList()};
  }
}

/// 分类数据：如 “牛”、“精液”
class StockRecordCategoryEntity {
  String? categoryName;
  List<StockRecordItemEntity>? list;

  StockRecordCategoryEntity({this.categoryName, this.list});

  factory StockRecordCategoryEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordCategoryEntity(
      categoryName: json['categoryName']?.toString(),
      list:
          (json['list'] as List<dynamic>?)?.map((e) => StockRecordItemEntity.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'categoryName': categoryName, 'list': list?.map((e) => e.toJson()).toList()};
  }
}

/// 单条物资数据：如 牛ASD、精液BHG等
class StockRecordItemEntity {
  String? id;
  String? materialId;
  String? name;
  String? unitName;
  num? addNum;
  num? outboundNum;
  num? currentNum;
  List<String>? addIdList;
  List<String>? outboundIdList;

  StockRecordItemEntity({
    this.id,
    this.materialId,
    this.name,
    this.unitName,
    this.addNum,
    this.outboundNum,
    this.currentNum,
    this.addIdList,
    this.outboundIdList,
  });

  factory StockRecordItemEntity.fromJson(Map<String, dynamic> json) {
    return StockRecordItemEntity(
      id: json['id']?.toString(),
      materialId: json['materialId']?.toString(),
      name: json['name']?.toString(),
      unitName: json['unitName']?.toString(),
      addNum: json['addNum'],
      outboundNum: json['outboundNum'],
      currentNum: json['currentNum'],
      addIdList: _parseIdList(json['addIdList'] ?? json['putinIdList'] ?? json['incomeIdList']),
      outboundIdList: _parseIdList(json['outboundIdList'] ?? json['receiveIdList'] ?? json['payIdList']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'materialId': materialId,
      'name': name,
      'unitName': unitName,
      'addNum': addNum,
      'outboundNum': outboundNum,
      'currentNum': currentNum,
      'addIdList': addIdList,
      'outboundIdList': outboundIdList,
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
