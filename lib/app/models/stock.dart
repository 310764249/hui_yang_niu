import 'package:flutter/material.dart';
/// 物资模型
class Stock {
  late final String id; //ID
  late final double count; //数量
  late final String checker; //负责人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  late final String materialId; //物资ID
  late final String? name; //物料名称
  late final String? no; //物资编号
  late final String? busiId; //业务ID 关联外部业务
  late final int category; //分类 1：精液；2：饲料；3：兽药；4：疫苗

  Stock({
    required this.id,
    required this.count,
    required this.checker,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
    required this.materialId,
    this.name,
    this.no,
    this.busiId,
    required this.category,
  });
  Stock.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    count = double.parse(json['count'].toString());
    checker = json['checker'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    materialId = json['materialId'];
    name = json['name'];
    no = json['no'];
    busiId = json['busiId'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['count'] = count;
    data['checker'] = checker;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    data['materialId'] = materialId;
    data['name'] = name;
    data['no'] = no;
    data['busiId'] = busiId;
    data['category'] = category;
    return data;
  }
}
