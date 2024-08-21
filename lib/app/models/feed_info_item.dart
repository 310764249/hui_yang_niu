/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

FeedInfoItem feedInfoItemFromJson(String str) => FeedInfoItem.fromJson(json.decode(str));

String feedInfoItemToJson(FeedInfoItem data) => json.encode(data.toJson());

class FeedInfoItem {
  FeedInfoItem({
    required this.date,
    required this.formulaName,
    required this.dosage,
    required this.rowVersion,
    required this.created,
    required this.count,
    required this.remark,
    required this.cowHouseName,
    required this.formulaId,
    required this.total,
    required this.createdBy,
    required this.executor,
    required this.tenantId,
    required this.modified,
    required this.modifiedBy,
    required this.id,
    required this.cowHouseId,
  });

  String date;
  String formulaName;
  int dosage;
  String rowVersion;
  String created;
  int count;
  String remark;
  String cowHouseName;
  String formulaId;
  int total;
  String createdBy;
  String executor;
  String tenantId;
  String modified;
  String modifiedBy;
  String id;
  String cowHouseId;

  factory FeedInfoItem.fromJson(Map<dynamic, dynamic> json) => FeedInfoItem(
        date: json["date"],
        formulaName: json["formulaName"],
        dosage: json["dosage"],
        rowVersion: json["rowVersion"],
        created: json["created"],
        count: json["count"],
        remark: json["remark"],
        cowHouseName: json["cowHouseName"],
        formulaId: json["formulaId"],
        total: json["total"],
        createdBy: json["createdBy"],
        executor: json["executor"],
        tenantId: json["tenantId"],
        modified: json["modified"],
        modifiedBy: json["modifiedBy"],
        id: json["id"],
        cowHouseId: json["cowHouseId"],
      );

  Map<dynamic, dynamic> toJson() => {
        "date": date,
        "formulaName": formulaName,
        "dosage": dosage,
        "rowVersion": rowVersion,
        "created": created,
        "count": count,
        "remark": remark,
        "cowHouseName": cowHouseName,
        "formulaId": formulaId,
        "total": total,
        "createdBy": createdBy,
        "executor": executor,
        "tenantId": tenantId,
        "modified": modified,
        "modifiedBy": modifiedBy,
        "id": id,
        "cowHouseId": cowHouseId,
      };
}
