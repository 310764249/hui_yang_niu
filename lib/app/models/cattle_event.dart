/// 牛只[生成记录]事件
class CattleEvent {
  late final String id; //ID
  late final String? cowId; //牛只ID
  late final String? batchNo; //牛只批次
  late final int calvNum; //胎次
  late final String busiId; //业务ID
  late final String date; //业务时间
  late final int category; //业务分类
  late final int type; //事件类型
  late final String? content; //内容
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  CattleEvent({
    required this.id,
    this.cowId,
    this.batchNo,
    required this.calvNum,
    required this.busiId,
    required this.date,
    required this.category,
    required this.type,
    this.content,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CattleEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    batchNo = json['batchNo'];
    calvNum = json['calvNum'];
    busiId = json['busiId'];
    date = json['date'];
    category = json['category'];
    type = json['type'];
    content = json['content'];
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
    data['cowId'] = cowId;
    data['batchNo'] = batchNo;
    data['calvNum'] = calvNum;
    data['busiId'] = busiId;
    data['date'] = date;
    data['category'] = category;
    data['type'] = type;
    data['content'] = content;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}
