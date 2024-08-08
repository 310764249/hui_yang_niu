import 'package:get/get.dart';

import '../routes/app_pages.dart';
import '../widgets/toast.dart';

class Cattle {
  late final String id; //ID
  late final String? no; //个体号
  late final String? farmerId; //养殖主体ID
  late final String farmId; //养殖场ID
  late final String? farmName; //养殖场
  late final String cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍
  late final String? sourceFarm; //来源养殖场
  late final String? code; //耳号
  late final String? eleCode; //电子耳号
  late final String? batchNo; //批次号
  late final String paternalCowId; //父系
  late final String maternalCowId; //母系
  late final String birth; //出生日期
  late final String? column; //栏位
  late final int ageOfDay; //日龄
  late final int gender; //性别1：公；2：母；
  late final int
      growthStage; //生长阶段1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  late final int kind; //品种1：安格斯；2：西门塔尔；3：利木赞；4：皮埃蒙特；5：夏洛莱牛；6：澳洲和牛；7：秦川牛；8：黄牛；
  late final double? weight; //体重
  late final double? tempture; //体温
  late final int bodyStatus; //体况评估0:未知；1：偏瘦；2：合格；3：偏胖；
  late final String? bodyDesc; //体况描述
  late final int breedStatus; //繁殖评估0：未知；1：优秀；2：合格；3：待淘；
  late final String? heredity; //遗传说明
  late final double? birthWeight; //出生重（kg）
  late final int calvNum; //胎次
  late final String? inArea; //入场时间
  late final String? quara; //检疫日期
  late final String? sale; //出售日期
  late final String? death; //死亡日期
  late final String? weedOut; //淘汰日期
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  late final int? semenCount; //采精次数
  late final int? qualifiedCount; //采精合格次数
  late final String? qualifiedRate; //采精合格率
  late final String? lastSemenDate; //上次采精时间
  late final double? calfAvg; //窝均产仔
  late final double? calfLive; //窝均活仔
  late final String? calfLiveRate; //产活仔率
  late final String? lastPregcy; //上次孕检
  late final String? lastCalv; //上次产犊
  late final int? nonantCount; //空怀次数
  late final String? lastMating; //上次配种时间
  late final bool? isBan; //是否禁配
  bool isSelected = false; //是否选中，页面内部使用

  Cattle({
    required this.id,
    this.no,
    this.farmerId,
    required this.farmId,
    this.farmName,
    required this.cowHouseId,
    this.cowHouseName,
    this.sourceFarm,
    this.code,
    this.eleCode,
    this.batchNo,
    required this.paternalCowId,
    required this.maternalCowId,
    required this.birth,
    this.column,
    required this.ageOfDay,
    required this.gender,
    required this.growthStage,
    required this.kind,
    this.weight,
    this.tempture,
    required this.bodyStatus,
    this.bodyDesc,
    required this.breedStatus,
    this.heredity,
    this.birthWeight,
    required this.calvNum,
    this.inArea,
    this.quara,
    this.sale,
    this.death,
    this.weedOut,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
    this.semenCount,
    this.qualifiedCount,
    this.qualifiedRate,
    this.lastSemenDate,
    this.calfAvg,
    this.calfLive,
    this.calfLiveRate,
    this.lastPregcy,
    this.lastCalv,
    this.nonantCount,
    this.lastMating,
    this.isBan,
  });
  Cattle.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    no = json['no'];
    farmerId = json['farmerId'];
    farmId = json['farmId'];
    farmName = json['farmName'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    sourceFarm = json['sourceFarm'];
    code = json['code'];
    eleCode = json['eleCode'];
    batchNo = json['batchNo'];
    paternalCowId = json['paternalCowId'];
    maternalCowId = json['maternalCowId'];
    birth = json['birth'];
    column = json['column'];
    ageOfDay = json['ageOfDay'];
    gender = json['gender'];
    growthStage = json['growthStage'];
    kind = json['kind'];
    weight = double.parse((json['weight'] ?? 0).toString());
    tempture = double.parse((json['tempture'] ?? 0).toString());
    bodyStatus = json['bodyStatus'];
    bodyDesc = json['bodyDesc'];
    breedStatus = json['breedStatus'];
    heredity = json['heredity'];
    birthWeight = double.parse((json['birthWeight'] ?? 0).toString());
    calvNum = json['calvNum'];
    inArea = json['inArea'];
    quara = json['quara'];
    sale = json['sale'];
    death = json['death'];
    weedOut = json['weedOut'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    semenCount = int.parse((json['semenCount'] ?? 0).toString());
    qualifiedCount = int.parse((json['qualifiedCount'] ?? 0).toString());
    qualifiedRate = json['qualifiedRate'];
    lastSemenDate = json['lastSemenDate'];
    calfAvg = double.parse((json['calfAvg'] ?? 0.0).toString());
    calfLive = double.parse((json['calfLive'] ?? 0.0).toString());
    calfLiveRate = json['calfLiveRate'];
    lastPregcy = json['lastPregcy'];
    lastCalv = json['lastCalv'];
    nonantCount = int.parse((json['nonantCount'] ?? 0).toString());
    lastMating = json['lastMating'];
    isBan = json['isBan'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['no'] = no;
    data['farmerId'] = farmerId;
    data['farmId'] = farmId;
    data['farmName'] = farmName;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['sourceFarm'] = sourceFarm;
    data['code'] = code;
    data['eleCode'] = eleCode;
    data['batchNo'] = batchNo;
    data['paternalCowId'] = paternalCowId;
    data['maternalCowId'] = maternalCowId;
    data['birth'] = birth;
    data['column'] = column;
    data['ageOfDay'] = ageOfDay;
    data['gender'] = gender;
    data['growthStage'] = growthStage;
    data['kind'] = kind;
    data['weight'] = weight;
    data['tempture'] = tempture;
    data['bodyStatus'] = bodyStatus;
    data['bodyDesc'] = bodyDesc;
    data['breedStatus'] = breedStatus;
    data['heredity'] = heredity;
    data['birthWeight'] = birthWeight;
    data['calvNum'] = calvNum;
    data['inArea'] = inArea;
    data['quara'] = quara;
    data['sale'] = sale;
    data['death'] = death;
    data['weedOut'] = weedOut;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    data['semenCount'] = semenCount;
    data['qualifiedCount'] = qualifiedCount;
    data['qualifiedRate'] = qualifiedRate;
    data['lastSemenDate'] = lastSemenDate;
    data['calfAvg'] = calfAvg;
    data['calfLive'] = calfLive;
    data['calfLiveRate'] = calfLiveRate;
    data['lastPregcy'] = lastPregcy;
    data['lastCalv'] = lastCalv;
    data['nonantCount'] = nonantCount;
    data['lastMating'] = lastMating;
    data['isBan'] = isBan;
    return data;
  }

  // 点击跳转
  // 101：业务通知；102：系统通知；201：未发情；202：发情未配；203：未孕检；204：未产犊；205：未淘汰；401：待查情；402：待配种；403：待孕检；404：待产犊；405：待断奶；406：待淘汰；407：待销售；408：待防疫；409：待保健；901：环境异常；902：设备故障；903：行为异常
  static void redirectToPage(int type, Cattle cattle) {
    switch (type) {
      case 201 || 401:
        // 未发情 & 待查情
        Get.toNamed(Routes.RUT, arguments: cattle);
        break;
      case 202 || 402:
        // 发情未配 & 待配种
        Get.toNamed(Routes.MATING, arguments: cattle);
        break;
      case 203 || 403:
        // 未孕检 & 待孕检
        Get.toNamed(Routes.PREGCY, arguments: cattle);
        break;
      case 205 || 404:
        // 未产犊 & 待产犊
        Get.toNamed(Routes.CALV, arguments: cattle);
        break;
      case 405:
        // 待断奶
        Get.toNamed(Routes.WEAN, arguments: cattle);
        break;
      case 205 || 406:
        // 未淘汰& 待淘汰
        Get.toNamed(Routes.KNOCK_OUT, arguments: cattle);
        break;
      case 407:
        // 待销售
        Get.toNamed(Routes.SELL_CATTLE, arguments: cattle);
        break;
      case 408:
        // 待防疫
        Get.toNamed(Routes.PREVENTION, arguments: cattle);
        break;
      case 409:
        // 待保健
        Get.toNamed(Routes.HEALTH_CARE, arguments: cattle);
        break;
      default:
        Toast.show('未知type类型');
        break;
    }
  }
}
