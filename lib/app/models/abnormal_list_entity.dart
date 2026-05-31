class AbnormalListEntity {
  final int? highNum;
  final int? lowNum;
  final int? loseNum;
  final List<AbnormalItemModel>? list;

  AbnormalListEntity({this.highNum, this.lowNum, this.loseNum, this.list});

  factory AbnormalListEntity.fromJson(Map<String, dynamic> json) {
    return AbnormalListEntity(
      highNum: json['highNum'],
      lowNum: json['lowNum'],
      loseNum: json['loseNum'],
      list: (json['list'] as List?)?.map((e) => AbnormalItemModel.fromJson(e)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'highNum': highNum,
      'lowNum': lowNum,
      'loseNum': loseNum,
      'list': list?.map((e) => e.toJson()).toList(),
    };
  }
}

class AbnormalItemModel {
  final String? farmerName;
  final String? id;
  final String? cId;
  final String? code;
  final String? eleCode;
  final String? high;
  final String? lose;
  final String? low;
  final String? envGps;
  final DateTime? updateTime;
  final String? updateTimeStr;

  AbnormalItemModel({
    this.farmerName,
    this.id,
    this.cId,
    this.code,
    this.eleCode,
    this.high,
    this.lose,
    this.low,
    this.envGps,
    this.updateTime,
    this.updateTimeStr,
  });

  factory AbnormalItemModel.fromJson(Map<String, dynamic> json) {
    return AbnormalItemModel(
      farmerName: json['farmerName'],
      id: json['id'],
      cId: json['cId'],
      code: json['code'],
      eleCode: json['eleCode'],
      high: json['high'],
      lose: json['lose'],
      low: json['low'],
      envGps: json['env_Gps'],
      updateTime: _parseFlexibleDate(json['updateTime']),
      updateTimeStr: json['updateTimeStr'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmerName': farmerName,
      'id': id,
      'cId': cId,
      'code': code,
      'eleCode': eleCode,
      'high': high,
      'lose': lose,
      'low': low,
      'env_Gps': envGps,
      'updateTime': updateTime?.toIso8601String(),
      'updateTimeStr': updateTimeStr,
    };
  }
}

DateTime? _parseFlexibleDate(dynamic value) {
  if (value == null) {
    return null;
  }

  if (value is DateTime) {
    return _sanitizeDate(value);
  }

  if (value is num) {
    final timestamp = value.toInt();
    final parsed =
        timestamp > 100000000000
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return _sanitizeDate(parsed);
  }

  final raw = value.toString().trim();
  if (raw.isEmpty || raw == 'null') {
    return null;
  }

  final timestamp = int.tryParse(raw);
  if (timestamp != null) {
    return _parseFlexibleDate(timestamp);
  }

  return _sanitizeDate(DateTime.tryParse(raw.replaceAll('/', '-')));
}

DateTime? _sanitizeDate(DateTime? value) {
  if (value == null || value.year <= 1) {
    return null;
  }
  return value.isUtc ? value.toLocal() : value;
}
