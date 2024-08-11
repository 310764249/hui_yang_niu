class ArticleGuideModel {
  late final String id;
  late final int type;
  late final String title;
  late final String desc;
  late final String coverImg;
  late final String content;

  ArticleGuideModel({
    required this.id,
    required this.type,
    required this.title,
    required this.desc,
    required this.coverImg,
    required this.content,
  });

  ArticleGuideModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    title = json['title'];
    desc = json['desc'];
    coverImg = json['coverImg'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['type'] = type;
    data['title'] = title;
    data['desc'] = desc;
    data['coverImg'] = coverImg;
    data['content'] = content;
    return data;
  }
}
