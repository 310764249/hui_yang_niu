class CowBatch {
  late final String id; //ID
  late final String farmId; //养殖场ID
  late final String? farmName; //养殖场
  late final String cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍
  late final String? sourceFarm; //来源养殖场
  late final int type; //类别1：犊牛；2：育肥牛；3：引种牛；
  late final int gender; //性别1：公；2：母；
  late final String? batchNo; //批次号
  late final String birth; //出生日期
  late final String? column; //栏位
  late final int ageOfDay; //日龄
  late final int kind; //品种1：安格斯；2：西门塔尔；3：利木赞；4：皮埃蒙特；5：夏洛莱牛；6：澳洲和牛；7：秦川牛；8：黄牛；
  late final String? inArea; //入场时间
  late final String date; //登记时间
  late final int count; //批次总数
  late final int male; //公牛数量
  late final int female; //母牛数量
  late final String? executor; //操作员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  bool isSelected = false; //是否选中，页面内部使用

  CowBatch({
    required this.id,
    required this.farmId,
    this.farmName,
    required this.cowHouseId,
    this.cowHouseName,
    this.sourceFarm,
    required this.type,
    required this.gender,
    this.batchNo,
    required this.birth,
    this.column,
    required this.ageOfDay,
    required this.kind,
    this.inArea,
    required this.date,
    required this.count,
    required this.male,
    required this.female,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CowBatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    farmId = json['farmId'];
    farmName = json['farmName'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    sourceFarm = json['sourceFarm'];
    type = json['type'];
    gender = json['gender'];
    batchNo = json['batchNo'];
    birth = json['birth'];
    column = json['column'];
    ageOfDay = json['ageOfDay'];
    kind = json['kind'];
    inArea = json['inArea'];
    date = json['date'];
    count = json['count'];
    male = json['male'];
    female = json['female'];
    executor = json['executor'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['farmId'] = farmId;
    data['farmName'] = farmName;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['sourceFarm'] = sourceFarm;
    data['type'] = type;
    data['gender'] = gender;
    data['batchNo'] = batchNo;
    data['birth'] = birth;
    data['column'] = column;
    data['ageOfDay'] = ageOfDay;
    data['kind'] = kind;
    data['inArea'] = inArea;
    data['date'] = date;
    data['count'] = count;
    data['male'] = male;
    data['female'] = female;
    data['executor'] = executor;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }

  @override
  String toString() {
    return 'batchNo: $batchNo, kind: $kind, gender: $gender';
  }
}
