class Feeds {
  late final String id; //ID
  late final String formulaId; //配方ID
  late final String? formulaName; //配方
  late final String? name; //名称
  late final int type; //饲料类型1：粗饲料；2：精饲料；3：TMR全混合日粮；4：颗粒聊；
  late final bool enable; //是否启用
  late final String? effectDesc; //效果描述
  late final double surplus; //剩余量（kg）
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  Feeds({
    required this.id,
    required this.formulaId,
    this.formulaName,
    this.name,
    required this.type,
    required this.enable,
    this.effectDesc,
    required this.surplus,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  Feeds.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    formulaId = json['formulaId'];
    formulaName = json['formulaName'];
    name = json['name'];
    type = json['type'];
    enable = json['enable'];
    effectDesc = json['effectDesc'];
    surplus = double.parse(json['surplus'].toString());
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
    data['formulaId'] = formulaId;
    data['formulaName'] = formulaName;
    data['name'] = name;
    data['type'] = type;
    data['enable'] = enable;
    data['effectDesc'] = effectDesc;
    data['surplus'] = surplus;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}
