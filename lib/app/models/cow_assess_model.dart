class CowAssessModel {
  CowAssessModel({
    required this.weanCalfNum,
    required this.code,
    required this.ageOfDay,
    required this.nonpregnantDay,
    required this.calvNum,
    required this.calfAvgDays,
    required this.id,
    required this.calfNum,
    required this.illness,
    required this.treatCount,
  });

  num? weanCalfNum; //断奶犊牛数
  String? code; //耳号
  num? ageOfDay; //日龄
  num? nonpregnantDay; //空怀天数
  num? calvNum; //胎次
  num? calfAvgDays; //平均产犊间隔天数
  String? id; //牛只ID
  num? calfNum; //产犊数
  String? illness; //历次疾病名称
  num? treatCount; //诊疗次数

  factory CowAssessModel.fromJson(Map<dynamic, dynamic> json) => CowAssessModel(
        weanCalfNum: json["weanCalfNum"],
        code: json["code"],
        ageOfDay: json["ageOfDay"],
        nonpregnantDay: json["nonpregnantDay"],
        calvNum: json["calvNum"],
        calfAvgDays: json["calfAvgDays"],
        id: json["id"],
        calfNum: json["calfNum"],
        illness: json["illness"],
        treatCount: json["treatCount"],
      );

  Map<dynamic, dynamic> toJson() => {
        "weanCalfNum": weanCalfNum,
        "code": code,
        "ageOfDay": ageOfDay,
        "nonpregnantDay": nonpregnantDay,
        "calvNum": calvNum,
        "calfAvgDays": calfAvgDays,
        "id": id,
        "calfNum": calfNum,
        "illness": illness,
        "treatCount": treatCount,
      };
}
