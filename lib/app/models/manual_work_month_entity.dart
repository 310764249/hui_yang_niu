class ManualWorkMonthEntity {
  final String date; // 例如：2025-11
  final double income; // 月总收入
  final double payment; // 月总支出
  final List<MonthCategoryEntity> categoryList;

  ManualWorkMonthEntity({
    required this.date,
    required this.income,
    required this.payment,
    required this.categoryList,
  });

  factory ManualWorkMonthEntity.fromJson(Map<String, dynamic> json) {
    return ManualWorkMonthEntity(
      date: json['date'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      payment: (json['payment'] ?? 0).toDouble(),
      categoryList:
          (json['categoryList'] as List<dynamic>? ?? [])
              .map((e) => MonthCategoryEntity.fromJson(e))
              .toList(),
    );
  }
}

class MonthCategoryEntity {
  final String categoryName;
  final double income; // 类别内收入汇总
  final double payment; // 类别内支出汇总
  final List<String> incomeIdList;
  final List<String> payIdList;
  final List<MonthCategoryDetailEntity> list;

  MonthCategoryEntity({
    required this.categoryName,
    required this.income,
    required this.payment,
    required this.incomeIdList,
    required this.payIdList,
    required this.list,
  });

  factory MonthCategoryEntity.fromJson(Map<String, dynamic> json) {
    return MonthCategoryEntity(
      categoryName: json['categoryName'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      payment: (json['payment'] ?? 0).toDouble(),
      incomeIdList: _parseIdList(
        json['incomeIdList'] ??
            json['salesIdList'] ??
            json['businessIdList'] ??
            json['busiIdList'] ??
            json['detailIdList'] ??
            json['ids'] ??
            json['idList'] ??
            json['incomeIds'] ??
            json['incomeId'] ??
            json['salesId'],
      ),
      payIdList: _parseIdList(
        json['payIdList'] ??
            json['purchaseIdList'] ??
            json['manualIdList'] ??
            json['businessIdList'] ??
            json['busiIdList'] ??
            json['detailIdList'] ??
            json['ids'] ??
            json['idList'] ??
            json['paymentIds'] ??
            json['payId'] ??
            json['purchaseId'] ??
            json['manualId'],
      ),
      list:
          (json['list'] as List<dynamic>? ?? [])
              .map((e) => MonthCategoryDetailEntity.fromJson(e))
              .toList(),
    );
  }
}

class MonthCategoryDetailEntity {
  final String name;
  final double income;
  final double payment;
  final double profit;
  final List<String> incomeIdList;
  final List<String> payIdList;

  MonthCategoryDetailEntity({
    required this.name,
    required this.income,
    required this.payment,
    required this.profit,
    required this.incomeIdList,
    required this.payIdList,
  });

  factory MonthCategoryDetailEntity.fromJson(Map<String, dynamic> json) {
    return MonthCategoryDetailEntity(
      name: json['name'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      payment: (json['payment'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
      incomeIdList: _parseIdList(
        json['incomeIdList'] ??
            json['salesIdList'] ??
            json['businessIdList'] ??
            json['busiIdList'] ??
            json['detailIdList'] ??
            json['ids'] ??
            json['idList'] ??
            json['incomeIds'] ??
            json['incomeId'] ??
            json['salesId'],
      ),
      payIdList: _parseIdList(
        json['payIdList'] ??
            json['purchaseIdList'] ??
            json['manualIdList'] ??
            json['businessIdList'] ??
            json['busiIdList'] ??
            json['detailIdList'] ??
            json['ids'] ??
            json['idList'] ??
            json['paymentIds'] ??
            json['payId'] ??
            json['purchaseId'] ??
            json['manualId'],
      ),
    );
  }
}

List<String> _parseIdList(dynamic value) {
  if (value is List) {
    return value
        .map(_normalizeSingleId)
        .where((e) => e.isNotEmpty)
        .toList();
  }
  if (value is Map) {
    final id = _normalizeSingleId(value);
    return id.isEmpty ? [] : [id];
  }
  if (value is num) {
    return [value.toString()];
  }
  if (value is String && value.isNotEmpty) {
    return value
        .split(RegExp(r'[,，;；\s]+'))
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
  return [];
}

String _normalizeSingleId(dynamic value) {
  if (value == null) {
    return '';
  }
  if (value is Map) {
    final dynamic id =
        value['id'] ??
        value['businessId'] ??
        value['busiId'] ??
        value['detailId'] ??
        value['value'];
    return id?.toString().trim() ?? '';
  }
  return value.toString().trim();
}
