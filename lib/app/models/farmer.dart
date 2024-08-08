//
class FarmerModel {
	late final String id;//Id
	late final String? code;//编码
	late final String? name;//名称
	late final int type;//牛场性质 1:规模化养殖厂；2：家庭农厂；3：农户散养；
	late final String? principal;//负责人
	late final String? phone;//联系方式
	late final String? description;//简介
	late final double? lng;//经度
	late final double? lat;//纬度
	late final String? orgCode;//机构编码
	late final String? areaCode;//辖区编码
	late final String? address;//详细地址
	late final int audit;//审核状态 0：未知；1：待审核；2：已通过；3：已驳回；
	late final String? remark;//备注
	late final String tenantId;//租户
	late final String created;//创建时间
	late final String? createdBy;//创建人
	late final String? modified;//修改时间
	late final String? modifiedBy;//修改人
	late final String rowVersion;//行版本

	FarmerModel({
		required this.id,
		this.code,
		this.name,
		required this.type,
		this.principal,
		this.phone,
		this.description,
		this.lng,
		this.lat,
		this.orgCode,
		this.areaCode,
		this.address,
		required this.audit,
		this.remark,
		required this.tenantId,
		required this.created,
		this.createdBy,
		this.modified,
		this.modifiedBy,
		required this.rowVersion,
	});
	FarmerModel.fromJson(Map<String, dynamic> json) {
		id = json['id'];
		code = json['code'];
		name = json['name'];
		type = json['type'];
		principal = json['principal'];
		phone = json['phone'];
		description = json['description'];
		lng = double.parse((json['lng']??0).toString());
		lat = double.parse((json['lat']??0).toString());
		orgCode = json['orgCode'];
		areaCode = json['areaCode'];
		address = json['address'];
		audit = json['audit'];
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
		data['code'] = code;
		data['name'] = name;
		data['type'] = type;
		data['principal'] = principal;
		data['phone'] = phone;
		data['description'] = description;
		data['lng'] = lng;
		data['lat'] = lat;
		data['orgCode'] = orgCode;
		data['areaCode'] = areaCode;
		data['address'] = address;
		data['audit'] = audit;
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
