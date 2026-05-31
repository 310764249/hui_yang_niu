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
      updateTime: _parseFlexibleDate(json['updateTime']),
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
      date: _parseFlexibleDate(json['date']),
      dateStr: json['dateStr'],
      monthStr: json['monthStr'],
      day: json['day'],
    );
  }
  //23.00kg(23日05时05分)
  String dateString(String unit) {
    final resolved = resolvedDate;
    final label = resolved == null ? '--' : _formatDate(resolved, showTime: true);
    return '${value?.toStringAsFixed(2)}$unit($label)';
  }

  DateTime? get resolvedDate {
    if (date != null) {
      return date;
    }

    final parsedDateStr = _parseFlexibleDate(dateStr);
    if (parsedDateStr != null) {
      return parsedDateStr;
    }

    final monthValue = _extractDatePart(monthStr);
    final dayValue = _extractDatePart(day);
    if (monthValue != null && dayValue != null) {
      return DateTime(2000, monthValue, dayValue);
    }

    return null;
  }

  String displayDate({bool showTime = true}) {
    final resolved = resolvedDate;
    if (resolved != null) {
      return _formatDate(resolved, showTime: showTime);
    }

    final rawDate = dateStr?.trim();
    if (rawDate != null && rawDate.isNotEmpty) {
      return rawDate;
    }

    final rawMonth = monthStr?.trim();
    final rawDay = day?.trim();
    if ((rawMonth?.isNotEmpty ?? false) && (rawDay?.isNotEmpty ?? false)) {
      return '$rawMonth$rawDay';
    }

    return '--';
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

  final normalized = raw.replaceAll('/', '-').replaceAll('.', '-');
  final direct = _sanitizeDate(DateTime.tryParse(normalized));
  if (direct != null) {
    return direct;
  }

  final monthDayMatch = RegExp(r'^(\d{1,2})[-月](\d{1,2})').firstMatch(normalized);
  if (monthDayMatch != null) {
    final month = int.tryParse(monthDayMatch.group(1)!);
    final day = int.tryParse(monthDayMatch.group(2)!);
    if (month != null && day != null) {
      return DateTime(DateTime.now().year, month, day);
    }
  }

  return null;
}

DateTime? _sanitizeDate(DateTime? value) {
  if (value == null || value.year <= 1) {
    return null;
  }
  return value.isUtc ? value.toLocal() : value;
}

int? _extractDatePart(String? value) {
  if (value == null) {
    return null;
  }
  final match = RegExp(r'\d+').firstMatch(value);
  return match == null ? null : int.tryParse(match.group(0)!);
}

String _formatDate(DateTime date, {bool showTime = true}) {
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');
  if (!showTime) {
    return '$month月$day日';
  }

  final hour = date.hour.toString().padLeft(2, '0');
  final minute = date.minute.toString().padLeft(2, '0');
  return '$month月$day日 $hour时$minute分';
}
