import 'package:flutter/material.dart';

class Article {
  late final String id; //ID
  late final String? title; //标题
  late final String? desc; //简述
  late final String? coverImg; //封面
  late final String? content; //内容
  late final int category; //分类 1：繁殖技术；2：营养调控；3：犊牛护理；4：能繁母牛养殖300问；
  late final int type; //类型 1：图文；2：图片；3：文字；4：视频；5：音频；
  late final String? url; //内部地址https://www.xxx.com/123f434.html
  late final int publish; //发布状态0：未知；1：待发布；2：已发布；
  late final String? publisher; //发布者
  late final String? platform; //所在平台
  late final String? publishDate; //发布日期
  late final String? address; //发布地点
  late final int audit; //审核状态 0：未知；1：待审核；2：已通过；3：已驳回；
  late final int pageview; //浏览人次
  late final int likeNum; //点赞数
  late final int opposeNum; //反对数
  late final int transNum; //转发数
  late final String? remark; //备注
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  Article({
    required this.id,
    this.title,
    this.desc,
    this.coverImg,
    this.content,
    required this.category,
    required this.type,
    this.url,
    required this.publish,
    this.publisher,
    this.platform,
    this.publishDate,
    this.address,
    required this.audit,
    required this.pageview,
    required this.likeNum,
    required this.opposeNum,
    required this.transNum,
    this.remark,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  Article.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    desc = json['desc'];
    coverImg = json['coverImg'];
    content = json['content'];
    category = json['category'];
    type = json['type'];
    url = json['url'];
    publish = json['publish'];
    publisher = json['publisher'];
    platform = json['platform'];
    publishDate = json['publishDate'];
    address = json['address'];
    audit = json['audit'];
    pageview = json['pageview'];
    likeNum = json['likeNum'];
    opposeNum = json['opposeNum'];
    transNum = json['transNum'];
    remark = json['remark'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['desc'] = desc;
    data['coverImg'] = coverImg;
    data['content'] = content;
    data['category'] = category;
    data['type'] = type;
    data['url'] = url;
    data['publish'] = publish;
    data['publisher'] = publisher;
    data['platform'] = platform;
    data['publishDate'] = publishDate;
    data['address'] = address;
    data['audit'] = audit;
    data['pageview'] = pageview;
    data['likeNum'] = likeNum;
    data['opposeNum'] = opposeNum;
    data['transNum'] = transNum;
    data['remark'] = remark;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}

/// 收藏
class FavoriteModel {
  late final String userId; //ID
  late final String articleId; //ID
  late final String? title; //标题
  late final String? desc; //简述
  late final String? coverImg; //封面
  late final String? content; //内容
  late final int category; //分类 1：繁殖技术；2：营养调控；3：犊牛护理；4：能繁母牛养殖300问；
  late final int type; //类型 1：图文；2：图片；3：文字；4：视频；5：音频；
  late final String? url; //内部地址https://www.xxx.com/123f434.html
  late final int publish; //发布状态0：未知；1：待发布；2：已发布；
  late final String? publisher; //发布者
  late final String? platform; //所在平台
  late final String? publishDate; //发布日期
  late final String? address; //发布地点
  late final int audit; //审核状态 0：未知；1：待审核；2：已通过；3：已驳回；
  late final int pageview; //浏览人次
  late final int likeNum; //点赞数
  late final int opposeNum; //反对数
  late final int transNum; //转发数
  late final String? remark; //备注
  late final String created; //创建时间

  FavoriteModel({
    required this.userId,
    required this.articleId,
    this.title,
    this.desc,
    this.coverImg,
    this.content,
    required this.category,
    required this.type,
    this.url,
    required this.publish,
    this.publisher,
    this.platform,
    this.publishDate,
    this.address,
    required this.audit,
    required this.pageview,
    required this.likeNum,
    required this.opposeNum,
    required this.transNum,
    this.remark,
    required this.created,
  });
  FavoriteModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    articleId = json['articleId'];
    title = json['title'];
    desc = json['desc'];
    coverImg = json['coverImg'];
    content = json['content'];
    category = json['category'];
    type = json['type'];
    url = json['url'];
    publish = json['publish'];
    publisher = json['publisher'];
    platform = json['platform'];
    publishDate = json['publishDate'];
    address = json['address'];
    audit = json['audit'];
    pageview = json['pageview'];
    likeNum = json['likeNum'];
    opposeNum = json['opposeNum'];
    transNum = json['transNum'];
    remark = json['remark'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['articleId'] = articleId;
    data['title'] = title;
    data['desc'] = desc;
    data['coverImg'] = coverImg;
    data['content'] = content;
    data['category'] = category;
    data['type'] = type;
    data['url'] = url;
    data['publish'] = publish;
    data['publisher'] = publisher;
    data['platform'] = platform;
    data['publishDate'] = publishDate;
    data['address'] = address;
    data['audit'] = audit;
    data['pageview'] = pageview;
    data['likeNum'] = likeNum;
    data['opposeNum'] = opposeNum;
    data['transNum'] = transNum;
    data['remark'] = remark;
    data['created'] = created;
    return data;
  }
}

/// 点赞
class TsanModel {
  late final String userId; //用户ID
  late final String articleId; //ID
  late final String? title; //标题
  late final String? desc; //简述
  late final String? coverImg; //封面
  late final String? content; //内容
  late final int category; //分类 1：繁殖技术；2：营养调控；3：犊牛护理；4：能繁母牛养殖300问；
  late final int type; //类型 1：图文；2：图片；3：文字；4：视频；5：音频；
  late final String? url; //地址
  late final int publish; //发布状态0：未知；1：待发布；2：已发布；
  late final String? publisher; //发布者
  late final String? platform; //所在平台
  late final String? publishDate; //发布日期
  late final String? address; //发布地点
  late final int audit; //审核状态 0：未知；1：待审核；2：已通过；3：已驳回；
  late final int pageview; //浏览人次
  late final int likeNum; //点赞数
  late final int opposeNum; //反对数
  late final int transNum; //转发数
  late final String? remark; //备注
  late final String created; //创建时间

  TsanModel({
    required this.userId,
    required this.articleId,
    this.title,
    this.desc,
    this.coverImg,
    this.content,
    required this.category,
    required this.type,
    this.url,
    required this.publish,
    this.publisher,
    this.platform,
    this.publishDate,
    this.address,
    required this.audit,
    required this.pageview,
    required this.likeNum,
    required this.opposeNum,
    required this.transNum,
    this.remark,
    required this.created,
  });
  TsanModel.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    articleId = json['articleId'];
    title = json['title'];
    desc = json['desc'];
    coverImg = json['coverImg'];
    content = json['content'];
    category = json['category'];
    type = json['type'];
    url = json['url'];
    publish = json['publish'];
    publisher = json['publisher'];
    platform = json['platform'];
    publishDate = json['publishDate'];
    address = json['address'];
    audit = json['audit'];
    pageview = json['pageview'];
    likeNum = json['likeNum'];
    opposeNum = json['opposeNum'];
    transNum = json['transNum'];
    remark = json['remark'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['articleId'] = articleId;
    data['title'] = title;
    data['desc'] = desc;
    data['coverImg'] = coverImg;
    data['content'] = content;
    data['category'] = category;
    data['type'] = type;
    data['url'] = url;
    data['publish'] = publish;
    data['publisher'] = publisher;
    data['platform'] = platform;
    data['publishDate'] = publishDate;
    data['address'] = address;
    data['audit'] = audit;
    data['pageview'] = pageview;
    data['likeNum'] = likeNum;
    data['opposeNum'] = opposeNum;
    data['transNum'] = transNum;
    data['remark'] = remark;
    data['created'] = created;
    return data;
  }
}

