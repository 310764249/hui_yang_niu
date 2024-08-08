import 'package:flutter/material.dart';

import 'farm.dart';

//用户资源
class UserResource {
  UserResource({
    required this.userId,
    this.nickName,
    this.account,
    this.avatarUrl,
    this.phone,
    required this.type,
    required this.status,
    this.areaCode,
    this.areaName,
    this.orgCode,
    this.orgName,
    this.farmerId,
    required this.farmerType,
    this.farmer,
    this.farms,
  });
  late final String userId; //用户ID
  late final String? nickName; //用户昵称
  late final String? account; //用户账号
  late final String? avatarUrl; //头像
  late final String? phone; //手机号
  late final int type; //类型0：默认；1：养殖户；2：员工；98：超级管理员；99：平台用户；
  late final int status; //状态0：默认；1：正常；2：锁定；3：禁用；
  late final String? areaCode; //行政区划代码
  late final String? areaName; //行政区划
  late final String? orgCode; //组织机构代码
  late final String? orgName; //组织机构
  late final String? farmerId; //养殖主体ID
  late final int farmerType; //主体性质1：规模养殖厂；2：家庭农厂；3：农户散户；
  late final String? farmer; //养殖主体
  late final List<Farm>? farms;
  //late final List<Menus?>? menus;

  UserResource.fromJson(Map<String, dynamic> json) {
    userId = json['userId'];
    nickName = json['nickName'];
    account = json['account'];
    avatarUrl = json['avatarUrl'];
    phone = json['phone'];
    type = json['type'];
    status = json['status'];
    areaCode = json['areaCode'];
    areaName = json['areaName'];
    orgCode = json['orgCode'];
    orgName = json['orgName'];
    farmerId = json['farmerId'];
    farmerType = json['farmerType'];
    farmer = json['farmer'];
    //
    if (json['farms'] != null) {
      farms = <Farm>[];
      json['farms'].forEach((v) {
        farms!.add(Farm.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['userId'] = userId;
    data['nickName'] = nickName;
    data['account'] = account;
    data['avatarUrl'] = avatarUrl;
    data['phone'] = phone;
    data['type'] = type;
    data['status'] = status;
    data['areaCode'] = areaCode;
    data['areaName'] = areaName;
    data['orgCode'] = orgCode;
    data['orgName'] = orgName;
    data['farmerId'] = farmerId;
    data['farmerType'] = farmerType;
    data['farmer'] = farmer;
    if (farms != null) {
      data['farms'] = farms!.map((e) => e.toJson()).toList();
    } else {
      data['farms'] = null;
    }
    return data;
  }
}

class Children {
  Children({
    required this.id,
    required this.farmId,
    required this.farmName,
    required this.name,
    required this.principal,
    required this.type,
    required this.capacity,
    required this.occupied,
    required this.description,
    required this.lng,
    required this.lat,
    required this.isFull,
    required this.enable,
    required this.remark,
    required this.tenantId,
    required this.created,
    required this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  late final String id;
  late final String farmId;
  late final String farmName;
  late final String name;
  late final String principal;
  late final int type;
  late final int capacity;
  late final int occupied;
  late final String description;
  late final double lng; //经度
  late final double lat; //纬度
  late final bool isFull;
  late final bool enable;
  late final String remark;
  late final String tenantId;
  late final String created;
  late final String createdBy;
  late final String? modified;
  late final String? modifiedBy;
  late final String rowVersion;

  Children.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    farmId = json['farmId'];
    farmName = json['farmName'];
    name = json['name'];
    principal = json['principal'];
    type = json['type'];
    capacity = json['capacity'];
    occupied = json['occupied'];
    description = json['description'];
    lng = double.parse(json['lng'].toString());
    lat = double.parse(json['lat'].toString());
    isFull = json['isFull'];
    enable = json['enable'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['farmId'] = farmId;
    _data['farmName'] = farmName;
    _data['name'] = name;
    _data['principal'] = principal;
    _data['type'] = type;
    _data['capacity'] = capacity;
    _data['occupied'] = occupied;
    _data['description'] = description;
    _data['lng'] = lng;
    _data['lat'] = lat;
    _data['isFull'] = isFull;
    _data['enable'] = enable;
    _data['remark'] = remark;
    _data['tenantId'] = tenantId;
    _data['created'] = created;
    _data['createdBy'] = createdBy;
    _data['modified'] = modified;
    _data['modifiedBy'] = modifiedBy;
    _data['rowVersion'] = rowVersion;
    return _data;
  }
}

class Menus {
  late final String id; //ID
  late final String? name; //名称
  late final String? parentId; //上级菜单
  late final int platform; //平台 1：Web；2：APP；3：微信；
  late final int type; //类型 0：未知；1：目录；2：菜单；3：按钮；
  late final String? icon; //图标
  late final String? router; //路由
  late final String? authTag; //权限标识user:add/user:update/user:delete/user:get
  late final bool? isShow; //是否显示
  late final int status; //状态0：默认；1：启用；2：禁用；
  late final int sort; //排序越小越靠前
  late final String? remark; //备注
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  Menus({
    required this.id,
    this.name,
    this.parentId,
    required this.platform,
    required this.type,
    this.icon,
    this.router,
    this.authTag,
    this.isShow,
    required this.status,
    required this.sort,
    this.remark,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  Menus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    parentId = json['parentId'];
    platform = json['platform'];
    type = json['type'];
    icon = json['icon'];
    router = json['router'];
    authTag = json['authTag'];
    isShow = json['isShow'];
    status = json['status'];
    sort = json['sort'];
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
    data['name'] = name;
    data['parentId'] = parentId;
    data['platform'] = platform;
    data['type'] = type;
    data['icon'] = icon;
    data['router'] = router;
    data['authTag'] = authTag;
    data['isShow'] = isShow;
    data['status'] = status;
    data['sort'] = sort;
    data['remark'] = remark;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}
