class RawMaterial {
  late final String? id; // ID
  late final int? type; // 原料类型
  late final int? category; // 原料分类
  late final int? individualType; // 饲料类型: 0-不限, 1-公牛, 2-母牛
  late final String? name; // 名称
  late final int? code; // 编号
  late final double? dm; // 干物质(%鲜样)
  late final double? ash; // 灰分(%DM)
  late final double? starch; // 淀粉(%DM)
  late final double? fat; // 脂肪(%DM)
  late final double? fibre; // 粗纤维(%DM)
  late final double? ndf; // 中性洗涤纤维(%DM)
  late final double? adf; // 酸性洗涤纤维(%DM)
  late final double? cp; // 粗蛋白(%DM)
  late final double? de; // 消化能
  late final double? mj; // 综合净能
  // late final double? rnd; // 肉牛能量单位
  late final double? ca; // 钙(%DM)
  late final double? p; // 磷(%DM)
  late final String? remark; // 备注
  late final String? created; // 创建时间
  late final String? createdBy; // 创建人
  late final String? modified; // 修改时间
  late final String? modifiedBy; // 修改人
  late final String? rowVersion; // 行版本

  RawMaterial({
    required this.id,
    required this.type,
    required this.category,
    required this.individualType,
    required this.name,
    required this.code,
    required this.dm,
    required this.ash,
    required this.starch,
    required this.fat,
    required this.fibre,
    required this.ndf,
    required this.adf,
    required this.cp,
    required this.de,
    required this.mj,
    required this.ca,
    required this.p,
    required this.remark,
    required this.created,
    required this.createdBy,
    required this.modified,
    required this.modifiedBy,
    required this.rowVersion,
  });
  RawMaterial.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    category = json['category'];
    individualType = json['individualType'];
    name = json['name'];
    code = json['code'];
    dm = double.parse((json['dm'] ?? 0).toString());
    ash = double.parse((json['ash'] ?? 0).toString());
    starch = double.parse((json['starch'] ?? 0).toString());
    fat = double.parse((json['fat'] ?? 0).toString());
    fibre = double.parse((json['fibre'] ?? 0).toString());
    ndf = double.parse((json['ndf'] ?? 0).toString());
    adf = double.parse((json['adf'] ?? 0).toString());
    cp = double.parse((json['cp'] ?? 0).toString());
    de = double.parse((json['de'] ?? 0).toString());
    mj = double.parse((json['mj'] ?? 0).toString());
    ca = double.parse((json['ca'] ?? 0).toString());
    p = double.parse((json['p'] ?? 0).toString());
    remark = json['remark'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['category'] = category;
    data['individualType'] = individualType;
    data['name'] = name;
    data['code'] = code;
    data['dm'] = dm;
    data['ash'] = ash;
    data['starch'] = starch;
    data['fat'] = fat;
    data['fibre'] = fibre;
    data['ndf'] = ndf;
    data['adf'] = adf;
    data['cp'] = cp;
    data['de'] = de;
    data['mj'] = mj;
    data['ca'] = ca;
    data['p'] = p;
    data['remark'] = remark;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}
