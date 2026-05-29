class SmartEarTagModel {
  final String? farmerName;
  final String? id;
  final String? tId;
  final String? cId;
  final String? code;
  final String? eleCode;
  final int? site;
  final double? temp;
  final int? batt;
  final String? high;
  final String? lose;
  final String? low;
  final String? envTemp;
  final String? envHumi;
  final String? envGps;
  final DateTime? updateTime;

  final int? tempRecordNum;
  final List<SmartEarTagRecordModel>? tempRecordList;

  final int? siteRecordNum;
  final List<SmartEarTagRecordModel>? siteRecoreList;

  final double? weight;
  final int? weightRecordNum;
  final List<SmartEarTagRecordModel>? weightRecordList;

  SmartEarTagModel({
    this.farmerName,
    this.id,
    this.tId,
    this.cId,
    this.code,
    this.eleCode,
    this.site,
    this.temp,
    this.batt,
    this.high,
    this.lose,
    this.low,
    this.envTemp,
    this.envHumi,
    this.envGps,
    this.updateTime,
    this.tempRecordNum,
    this.tempRecordList,
    this.siteRecordNum,
    this.siteRecoreList,
    this.weight,
    this.weightRecordNum,
    this.weightRecordList,
  });

  factory SmartEarTagModel.fromJson(Map<String, dynamic> json) {
    return SmartEarTagModel(
      farmerName: json['farmerName'],
      id: json['id'],
      tId: json['tId'],
      cId: json['cId'],
      code: json['code'],
      eleCode: json['eleCode'],
      site: json['site'],
      temp: (json['temp'] as num?)?.toDouble(),
      batt: json['batt'],
      high: json['high'],
      lose: json['lose'],
      low: json['low'],
      envTemp: json['env_Temp'],
      envHumi: json['env_Humi'],
      envGps: json['env_Gps'],
      updateTime: json['updateTime'] != null ? DateTime.tryParse(json['updateTime']) : null,
      tempRecordNum: json['tempRecordNum'],
      tempRecordList:
          (json['tempRecordList'] as List?)
              ?.map((e) => SmartEarTagRecordModel.fromJson(e))
              .toList(),
      siteRecordNum: json['siteRecordNum'],
      siteRecoreList:
          (json['siteRecoreList'] as List?)
              ?.map((e) => SmartEarTagRecordModel.fromJson(e))
              .toList(),
      weight: (json['weight'] as num?)?.toDouble(),
      weightRecordNum: json['weightRecordNum'],
      weightRecordList:
          (json['weightRecordList'] as List?)
              ?.map((e) => SmartEarTagRecordModel.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'farmerName': farmerName,
      'id': id,
      'tId': tId,
      'cId': cId,
      'code': code,
      'eleCode': eleCode,
      'site': site,
      'temp': temp,
      'batt': batt,
      'high': high,
      'lose': lose,
      'low': low,
      'env_Temp': envTemp,
      'env_Humi': envHumi,
      'env_Gps': envGps,
      'updateTime': updateTime?.toIso8601String(),
      'tempRecordNum': tempRecordNum,
      'tempRecordList': tempRecordList?.map((e) => e.toJson()).toList(),
      'siteRecordNum': siteRecordNum,
      'siteRecoreList': siteRecoreList?.map((e) => e.toJson()).toList(),
      'weight': weight,
      'weightRecordNum': weightRecordNum,
      'weightRecordList': weightRecordList?.map((e) => e.toJson()).toList(),
    };
  }
}

class SmartEarTagRecordModel {
  final double? value;
  final DateTime? date;
  final String? dateStr;
  final String? monthStr;
  final String? day;

  SmartEarTagRecordModel({this.value, this.date, this.dateStr, this.monthStr, this.day});

  factory SmartEarTagRecordModel.fromJson(Map<String, dynamic> json) {
    return SmartEarTagRecordModel(
      value: (json['value'] as num?)?.toDouble(),
      date: json['date'] != null ? DateTime.tryParse(json['date']) : null,
      dateStr: json['dateStr'],
      monthStr: json['monthStr'],
      day: json['day'],
    );
  }
  //23.00kg(23日05时05分)
  String dateString(String unit) {
    return '${value?.toStringAsFixed(2)}$unit(${date?.month}月${date?.day}日${date?.hour}时${date?.minute}分)';
  }

  Map<String, dynamic> toJson() {
    return {
      'value': value,
      'date': date?.toIso8601String(),
      'dateStr': dateStr,
      'monthStr': monthStr,
      'day': day,
    };
  }
}
