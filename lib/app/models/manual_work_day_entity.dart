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
    return ManualworkDetailEntity(
      name: json['name'] ?? '',
      income: (json['income'] ?? 0).toDouble(),
      payment: (json['payment'] ?? 0).toDouble(),
      profit: (json['profit'] ?? 0).toDouble(),
      incomeIdList: _parseIdList(json['incomeIdList']),
      payIdList: _parseIdList(json['payIdList']),
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
    return value.where((e) => e != null && e.toString().isNotEmpty).map((e) => e.toString()).toList();
  }
  if (value is String && value.isNotEmpty) {
    return value.split(',').where((e) => e.isNotEmpty).toList();
  }
  return [];
}
