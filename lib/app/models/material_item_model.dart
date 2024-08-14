class MaterialItemModel {
  MaterialItemModel({
    required this.date,
    required this.no,
    required this.reason,
    required this.rowVersion,
    required this.created,
    required this.count,
    required this.remark,
    required this.preCount,
    required this.materialId,
    required this.type,
    required this.confirm,
    required this.materialName,
    required this.createdBy,
    required this.executor,
    required this.currentCount,
    required this.tenantId,
    required this.modified,
    required this.modifiedBy,
    required this.id,
    required this.category,
  });

  String? date;
  String? no;
  String? reason;
  String? rowVersion;
  String? created;
  num? count;
  String? remark;
  num? preCount;
  String? materialId;
  num? type;
  bool? confirm;
  String? materialName;
  String? createdBy;
  String? executor;
  num? currentCount;
  String? tenantId;
  String? modified;
  String? modifiedBy;
  String? id;
  num? category;

  factory MaterialItemModel.fromJson(Map<dynamic, dynamic> json) => MaterialItemModel(
        date: json["date"],
        no: json["no"],
        reason: json["reason"],
        rowVersion: json["rowVersion"],
        created: json["created"],
        count: json["count"],
        remark: json["remark"],
        preCount: json["preCount"],
        materialId: json["materialId"],
        type: json["type"],
        confirm: json["confirm"],
        materialName: json["materialName"],
        createdBy: json["createdBy"],
        executor: json["executor"],
        currentCount: json["currentCount"],
        tenantId: json["tenantId"],
        modified: json["modified"],
        modifiedBy: json["modifiedBy"],
        id: json["id"],
        category: json["category"],
      );

  Map<dynamic, dynamic> toJson() => {
        "date": date,
        "no": no,
        "reason": reason,
        "rowVersion": rowVersion,
        "created": created,
        "count": count,
        "remark": remark,
        "preCount": preCount,
        "materialId": materialId,
        "type": type,
        "confirm": confirm,
        "materialName": materialName,
        "createdBy": createdBy,
        "executor": executor,
        "currentCount": currentCount,
        "tenantId": tenantId,
        "modified": modified,
        "modifiedBy": modifiedBy,
        "id": id,
        "category": category,
      };
}
