class IntelligentQuestionHistoryModel {
  List<QuestionHistoryItem>? list;
  int? pageSize;
  int? pageIndex;
  int? itemsCount;
  int? pageCount;

  IntelligentQuestionHistoryModel({
    this.list,
    this.pageSize,
    this.pageIndex,
    this.itemsCount,
    this.pageCount,
  });

  factory IntelligentQuestionHistoryModel.fromJson(Map<String, dynamic> json) {
    return IntelligentQuestionHistoryModel(
      list:
          json['list'] != null
              ? (json['list'] as List)
                  .map((e) => QuestionHistoryItem.fromJson(e as Map<String, dynamic>))
                  .toList()
              : null,
      pageSize: json['pageSize'],
      pageIndex: json['pageIndex'],
      itemsCount: json['itemsCount'],
      pageCount: json['pageCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'list': list?.map((e) => e.toJson()).toList(),
      'pageSize': pageSize,
      'pageIndex': pageIndex,
      'itemsCount': itemsCount,
      'pageCount': pageCount,
    };
  }
}

class QuestionHistoryItem {
  String? id;
  bool? isDeleted;
  String? created;
  String? createdBy;
  String? modified;
  String? modifiedBy;
  String? rowVersion;
  String? tenantId;
  String? title;

  QuestionHistoryItem({
    this.id,
    this.isDeleted,
    this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    this.rowVersion,
    this.tenantId,
    this.title,
  });

  factory QuestionHistoryItem.fromJson(Map<String, dynamic> json) {
    return QuestionHistoryItem(
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      created: json['created'] as String?,
      createdBy: json['createdBy'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      rowVersion: json['rowVersion'] as String?,
      tenantId: json['tenantId'] as String?,
      title: json['title'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isDeleted': isDeleted,
      'created': created,
      'createdBy': createdBy,
      'modified': modified,
      'modifiedBy': modifiedBy,
      'rowVersion': rowVersion,
      'tenantId': tenantId,
      'title': title,
    };
  }
}
