class SmartEarTagModel {
  final String id;
  final String tId;
  final String cId;
  final String code;
  final String eleCode;
  final double temp;
  final double batt;
  final String envGps;
  final DateTime updateTime;
  final List<TempRecord> tempRecordList;

  SmartEarTagModel({
    required this.id,
    required this.tId,
    required this.cId,
    required this.code,
    required this.eleCode,
    required this.temp,
    required this.batt,
    required this.envGps,
    required this.updateTime,
    required this.tempRecordList,
  });

  factory SmartEarTagModel.fromJson(Map<String, dynamic> json) {
    return SmartEarTagModel(
      id: json['id'] ?? '',
      tId: json['tId'] ?? '',
      cId: json['cId'] ?? '',
      code: json['code'] ?? '',
      eleCode: json['eleCode'] ?? '',

      /// ✅ 关键修复点
      temp: (json['temp'] as num?)?.toDouble() ?? 0.0,
      batt: (json['batt'] as num?)?.toDouble() ?? 0.0,

      envGps: json['env_Gps'] ?? '',
      updateTime: DateTime.parse(json['updateTime']),
      tempRecordList:
          (json['tempRecordList'] as List<dynamic>? ?? [])
              .map((e) => TempRecord.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tId': tId,
      'cId': cId,
      'code': code,
      'eleCode': eleCode,
      'temp': temp,
      'batt': batt,
      'env_Gps': envGps,
      'updateTime': updateTime.toIso8601String(),
      'tempRecordList': tempRecordList.map((e) => e.toJson()).toList(),
    };
  }
}

class TempRecord {
  final double value;
  final DateTime date;

  TempRecord({required this.value, required this.date});

  factory TempRecord.fromJson(Map<String, dynamic> json) {
    return TempRecord(
      value: double.tryParse('${json['value'] ?? 0}') ?? 0.0,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'value': value, 'date': date.toIso8601String()};
  }

  //23.00kg(23日05时05分)
  String get dateString {
    return '${value.toStringAsFixed(2)}kg(${date.month}月${date.day}日${date.hour}时${date.minute}分)';
  }
}
