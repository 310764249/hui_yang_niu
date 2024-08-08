import 'package:intellectual_breed/app/models/cow_house.dart';

///TODO-- 字段暂时不固定待完善 养殖场
class Farm {
  late final String id; //Id
  late final String farmerId; //养殖主体ID
  late final String? farmer; //养殖主体
  late final String? code; //编码
  late final String? name; //名称
  late final String? img; //场地图片
  late final String? description; //简介
  late final double? lng; //经度
  late final double? lat; //纬度
  late final String? orgCode; //机构编码
  late final String? areaCode; //辖区编码
  late final String? address; //详细地址
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  late final List? children; //栋舍集合

  Farm({
    required this.id,
    required this.farmerId,
    this.farmer,
    this.code,
    this.name,
    this.img,
    this.description,
    required this.lng,
    required this.lat,
    this.orgCode,
    this.areaCode,
    this.address,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
    this.children,
  });
  Farm.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    farmerId = json['farmerId'];
    farmer = json['farmer'];
    code = json['code'];
    name = json['name'];
    img = json['img'];
    description = json['description'];
    if (json['lng'] != null) {
      lng = double.parse(json['lng'].toString());
    }
    if (json['lat'] != null) {
      lat = double.parse(json['lat'].toString());
    }
    orgCode = json['orgCode'];
    areaCode = json['areaCode'];
    address = json['address'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    children = json['children'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['farmerId'] = farmerId;
    data['farmer'] = farmer;
    data['code'] = code;
    data['name'] = name;
    data['img'] = img;
    data['description'] = description;
    data['lng'] = lng;
    data['lat'] = lat;
    data['orgCode'] = orgCode;
    data['areaCode'] = areaCode;
    data['address'] = address;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    data['children'] = children;
    return data;
  }
}
