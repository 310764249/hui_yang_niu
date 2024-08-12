class ArticleGuideModel {
  late final String id;
  late final int type;
  late final String title;
  late final String desc;
  late final String coverImg;
  late final String created;

  ArticleGuideModel({
    required this.id,
    required this.type,
    required this.title,
    required this.desc,
    required this.coverImg,
    required this.created,
  });

  ArticleGuideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    desc = json['desc'];
    coverImg = json['coverImg'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['desc'] = desc;
    data['coverImg'] = coverImg;
    data['created'] = created;
    return data;
  }
}
