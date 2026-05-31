import 'dart:convert';

/// 单日人工/收支数据
class ManualWorkDayEntity {
  final String date;
  final double income;
  final double payment;
  final List<ManualworkDetailEntity> list;

  ManualWorkDayEntity({
    required this.date,
    required this.income,
    required this.payment,
    required this.list,
  });

  factory ManualWorkDayEntity.fromJson(Map<String, dynamic> json) {
    return ManualWorkDayEntity(
      date: json['date'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      payment: (json['payment'] ?? 0).toDouble(),
      list:
          (json['list'] as List<dynamic>? ?? [])
              .map((e) => ManualworkDetailEntity.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'income': income,
      'payment': payment,
      'list': list.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => jsonEncode(toJson());
}

/// 单笔项目数据（工资、采购、销售等）
class ManualworkDetailEntity {
  final String name;
  final double income;
  final double payment;
  final double profit;
  final List<String> incomeIdList;
  final List<String> payIdList;

  ManualworkDetailEntity({
    required this.name,
    required this.income,
    required this.payment,
    required this.profit,
    required this.incomeIdList,
    required this.payIdList,
  });

  factory ManualworkDetailEntity.fromJson(Map<String, dynamic> json) {
    final income = (json['income'] ?? 0).toDouble();
    final payment = (json['payment'] ?? 0).toDouble();
    final profit = (json['profit'] ?? 0).toDouble();
    final fallbackId = _normalizeSingleId(
      json['id'] ?? json['businessId'] ?? json['busiId'] ?? json['detailId'],
    );
    final incomeIdList = _parseIdList(
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
    );
    final payIdList = _parseIdList(
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
    );
    return ManualworkDetailEntity(
      name: json['name'] ?? '',
      income: income,
      payment: payment,
      profit: profit,
      incomeIdList:
          incomeIdList.isNotEmpty
              ? incomeIdList
              : (income > 0 && fallbackId.isNotEmpty ? [fallbackId] : const []),
      payIdList:
          payIdList.isNotEmpty
              ? payIdList
              : (payment > 0 && fallbackId.isNotEmpty ? [fallbackId] : const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'income': income,
      'payment': payment,
      'profit': profit,
      'incomeIdList': incomeIdList,
      'payIdList': payIdList,
    };
  }

  @override
  String toString() => jsonEncode(toJson());
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
