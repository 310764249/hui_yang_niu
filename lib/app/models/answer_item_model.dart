class AnswerItemModel {
  String? intelligentQAId;
  String? content;
  String? type;
  String? voiceContent;
  String? role;
  String? requestId;
  String? responseCon;
  String? id;
  bool? isDeleted;
  String? created;
  String? createdBy;
  String? modified;
  String? modifiedBy;
  String? rowVersion;

  AnswerItemModel({
    this.intelligentQAId,
    this.content,
    this.type,
    this.voiceContent,
    this.role,
    this.requestId,
    this.responseCon,
    this.id,
    this.isDeleted,
    this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    this.rowVersion,
  });

  factory AnswerItemModel.fromJson(Map<String, dynamic> json) {
    return AnswerItemModel(
      intelligentQAId: json['intelligentQAId'] as String?,
      content: json['content'] as String?,
      type: json['type'] as String?,
      voiceContent: json['voiceContent'] as String?,
      role: json['role'] as String?,
      requestId: json['requestId'] as String?,
      responseCon: json['responseCon'] as String?,
      id: json['id'] as String?,
      isDeleted: json['isDeleted'] as bool?,
      created: json['created'] as String?,
      createdBy: json['createdBy'] as String?,
      modified: json['modified'] as String?,
      modifiedBy: json['modifiedBy'] as String?,
      rowVersion: json['rowVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intelligentQAId': intelligentQAId,
      'content': content,
      'type': type,
      'voiceContent': voiceContent,
      'role': role,
      'requestId': requestId,
      'responseCon': responseCon,
      'id': id,
      'isDeleted': isDeleted,
      'created': created,
      'createdBy': createdBy,
      'modified': modified,
      'modifiedBy': modifiedBy,
      'rowVersion': rowVersion,
    };
  }
}
