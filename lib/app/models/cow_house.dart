/// 栋舍模型

class CowHouse {
  late final String id; //ID
  late final String farmId; //养殖场ID
  late final String? farmName; //养殖场
  late final String? name; //栋舍名称
  late final String? principal; //负责人
  late final int type; //类型
  late final int capacity; //容纳量
  late final int occupied; //入住数
  late final String? description; //简介
  late final double? lng; //经度
  late final double? lat; //纬度
  late final bool isFull; //是否满员
  late final bool enable; //启用状态
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  bool isSelected = false; //是否选中，页面内部使用

  CowHouse({
    required this.id,
    required this.farmId,
    this.farmName,
    this.name,
    this.principal,
    required this.type,
    required this.capacity,
    required this.occupied,
    this.description,
    required this.lng,
    required this.lat,
    required this.isFull,
    required this.enable,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CowHouse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    farmId = json['farmId'];
    farmName = json['farmName'];
    name = json['name'];
    principal = json['principal'];
    type = json['type'];
    capacity = json['capacity'];
    occupied = json['occupied'];
    description = json['description'];
    lng = double.parse((json['lng'] ?? '0.0').toString());
    lat = double.parse((json['lat'] ?? '0.0').toString());
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
    final data = <String, dynamic>{};
    data['id'] = id;
    data['farmId'] = farmId;
    data['farmName'] = farmName;
    data['name'] = name;
    data['principal'] = principal;
    data['type'] = type;
    data['capacity'] = capacity;
    data['occupied'] = occupied;
    data['description'] = description;
    data['lng'] = lng;
    data['lat'] = lat;
    data['isFull'] = isFull;
    data['enable'] = enable;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}
