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
      updateTime: json['updateTime'] != null ? DateTime.tryParse(json['updateTime']) : null,
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
