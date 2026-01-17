/// 智能称重设备模型
class SmartWeightModel {
  final String cId;
  final String code;
  final String eleCode;
  final double weight;
  final DateTime updateTime;
  final List<WeightRecord> weightRecordList;

  SmartWeightModel({
    required this.cId,
    required this.code,
    required this.eleCode,
    required this.weight,
    required this.updateTime,
    required this.weightRecordList,
  });

  factory SmartWeightModel.fromJson(Map<String, dynamic> json) {
    return SmartWeightModel(
      cId: json['cId'] as String,
      code: json['code'] as String,
      eleCode: json['eleCode'] as String,
      weight: (json['weight'] as num).toDouble(),
      updateTime: DateTime.parse(json['updateTime']),
      weightRecordList:
          (json['weightRecordList'] as List<dynamic>? ?? [])
              .map((e) => WeightRecord.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'cId': cId,
      'code': code,
      'eleCode': eleCode,
      'weight': weight,
      'updateTime': updateTime.toIso8601String(),
      'weightRecordList': weightRecordList.map((e) => e.toJson()).toList(),
    };
  }
}

/// 称重记录
class WeightRecord {
  final double value;
  final DateTime date;

  WeightRecord({required this.value, required this.date});

  factory WeightRecord.fromJson(Map<String, dynamic> json) {
    return WeightRecord(
      value: (json['value'] as num).toDouble(),
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'date': date.toIso8601String().split('T').first};
  }

  //23.00kg(23日05时05分)
  String get dateString {
    return '${value.toStringAsFixed(2)}kg(${date.year}年${date.month}月${date.day}日${date.hour}时${date.minute}分)';
  }
}
