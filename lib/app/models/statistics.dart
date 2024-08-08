import 'package:flutter/material.dart';

//牛只统计
class LiveStockStatistics {
  late final int cow; //牛只存栏
  late final int male; //公牛存栏
  late final int female; //母牛存栏
  late final int calf; //犊牛存栏
  late final int adult; //育肥牛存栏
  late final int reserve; //后备母牛存栏
  late final int gestation; //妊娠母牛存栏
  late final int lactation; //哺乳母牛存栏
  late final int nonpregnant; //空怀母牛存栏

  LiveStockStatistics({
    required this.cow,
    required this.male,
    required this.female,
    required this.calf,
    required this.adult,
    required this.reserve,
    required this.gestation,
    required this.lactation,
    required this.nonpregnant,
  });
  LiveStockStatistics.fromJson(Map<String, dynamic> json) {
    cow = json['cow'];
    male = json['male'];
    female = json['female'];
    calf = json['calf'];
    adult = json['adult'];
    reserve = json['reserve'];
    gestation = json['gestation'];
    lactation = json['lactation'];
    nonpregnant = json['nonpregnant'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['cow'] = cow;
    data['male'] = male;
    data['female'] = female;
    data['calf'] = calf;
    data['adult'] = adult;
    data['reserve'] = reserve;
    data['gestation'] = gestation;
    data['lactation'] = lactation;
    data['nonpregnant'] = nonpregnant;
    return data;
  }
}

// 生产任务统计
class ProductionTaskStatistics {
  late final int checkLove; //待查情
  late final int mating; //待配种
  late final int pregcy; //待孕检
  late final int calv; //待产犊
  late final int wean; //待断奶
  late final int weedOut; //待淘汰
  late final int market; //待销售
  late final int antidemic; //待防疫
  late final int healthCare; //待保健

  ProductionTaskStatistics({
    required this.checkLove,
    required this.mating,
    required this.pregcy,
    required this.calv,
    required this.wean,
    required this.weedOut,
    required this.market,
    required this.antidemic,
    required this.healthCare,
  });
  ProductionTaskStatistics.fromJson(Map<String, dynamic> json) {
    checkLove = json['checkLove'];
    mating = json['mating'];
    pregcy = json['pregcy'];
    calv = json['calv'];
    wean = json['wean'];
    weedOut = json['weedOut'];
    market = json['market'];
    antidemic = json['antidemic'];
    healthCare = json['healthCare'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['checkLove'] = checkLove;
    data['mating'] = mating;
    data['pregcy'] = pregcy;
    data['calv'] = calv;
    data['wean'] = wean;
    data['weedOut'] = weedOut;
    data['market'] = market;
    data['antidemic'] = antidemic;
    data['healthCare'] = healthCare;
    return data;
  }
}

//预警信息
class EarlyWarningStatistics {
  late final int notRut; //未发情
  late final int notMating; //发情未配
  late final int notPregcy; //未孕检
  late final int notCalv; //未产犊
  late final int notWeedOut; //未淘汰

  EarlyWarningStatistics({
    required this.notRut,
    required this.notMating,
    required this.notPregcy,
    required this.notCalv,
    required this.notWeedOut,
  });
  EarlyWarningStatistics.fromJson(Map<String, dynamic> json) {
    notRut = json['notRut'];
    notMating = json['notMating'];
    notPregcy = json['notPregcy'];
    notCalv = json['notCalv'];
    notWeedOut = json['notWeedOut'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['notRut'] = notRut;
    data['notMating'] = notMating;
    data['notPregcy'] = notPregcy;
    data['notCalv'] = notCalv;
    data['notWeedOut'] = notWeedOut;
    return data;
  }
}
