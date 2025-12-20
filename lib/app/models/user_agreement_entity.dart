class UserAgreementEntity {
  final String id;
  final String title;
  final String desc;
  final String? coverImg;
  final String content;
  final String? url;
  final String classify;
  final int type;
  final int category;
  final int publish;
  final String publisher;
  final int audit;
  final int pageview;
  final int likeNum;
  final bool tsanStatus;
  final bool favoritesStatus;
  final int opposeNum;
  final int transNum;
  final int commentNum;
  final String? remark;
  final DateTime? publishDate;
  final DateTime? created;
  final String? createdBy;
  final DateTime? modified;
  final String? modifiedBy;
  final String? rowVersion;

  UserAgreementEntity({
    required this.id,
    required this.title,
    required this.desc,
    required this.coverImg,
    required this.content,
    required this.url,
    required this.classify,
    required this.type,
    required this.category,
    required this.publish,
    required this.publisher,
    required this.audit,
    required this.pageview,
    required this.likeNum,
    required this.tsanStatus,
    required this.favoritesStatus,
    required this.opposeNum,
    required this.transNum,
    required this.commentNum,
    required this.remark,
    required this.publishDate,
    required this.created,
    required this.createdBy,
    required this.modified,
    required this.modifiedBy,
    required this.rowVersion,
  });

  factory UserAgreementEntity.fromJson(Map<String, dynamic> json) {
    return UserAgreementEntity(
      id: json['id'] as String,
      title: json['title'] as String,
      desc: json['desc'] as String,
      coverImg: json['coverImg'] as String?,
      content: json['content'] as String,
      url: json['url'] as String?,
      classify: json['classify'] as String,
      type: json['type'] as int,
      category: json['category'] as int,
      publish: json['publish'] as int,
      publisher: json['publisher'] as String,
      audit: json['audit'] as int,
      pageview: json['pageview'] as int,
      likeNum: json['likeNum'] as int,
      tsanStatus: json['tsanStatus'] as bool,
      favoritesStatus: json['favoritesStatus'] as bool,
      opposeNum: json['opposeNum'] as int,
      transNum: json['transNum'] as int,
      commentNum: json['commentNum'] as int,
      remark: json['remark'] as String?,
      publishDate: json['publishDate'] != null ? DateTime.tryParse(json['publishDate']) : null,
      created: json['created'] != null ? DateTime.tryParse(json['created']) : null,
      createdBy: json['createdBy'] as String?,
      modified: json['modified'] != null ? DateTime.tryParse(json['modified']) : null,
      modifiedBy: json['modifiedBy'] as String?,
      rowVersion: json['rowVersion'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'desc': desc,
    'coverImg': coverImg,
    'content': content,
    'url': url,
    'classify': classify,
    'type': type,
    'category': category,
    'publish': publish,
    'publisher': publisher,
    'audit': audit,
    'pageview': pageview,
    'likeNum': likeNum,
    'tsanStatus': tsanStatus,
    'favoritesStatus': favoritesStatus,
    'opposeNum': opposeNum,
    'transNum': transNum,
    'commentNum': commentNum,
    'remark': remark,
    'publishDate': publishDate?.toIso8601String(),
    'created': created?.toIso8601String(),
    'createdBy': createdBy,
    'modified': modified?.toIso8601String(),
    'modifiedBy': modifiedBy,
    'rowVersion': rowVersion,
  };
}
