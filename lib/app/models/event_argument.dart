/// ！！！！ 本页面模型数据全部用于事件编辑时的传入参数

//淘汰事件传入参数
class KnockOutEvent {
  late final String id; //ID
  late final String date; //淘汰时间
  late final String? batchNo; //批次号
  late final int count; //数量
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String? cowHouseId; //所在栋舍
  late final String? cowHouseName; //栋舍名称
  late final int cause; //淘汰原因
  late final String? executor; //淘汰人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  KnockOutEvent({
    required this.id,
    required this.date,
    this.batchNo,
    required this.count,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    this.cowHouseId,
    this.cowHouseName,
    required this.cause,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  KnockOutEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    batchNo = json['batchNo'];
    count = json['count'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cause = json['cause'];
    executor = json['executor'];
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
    data['date'] = date;
    data['batchNo'] = batchNo;
    data['count'] = count;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cause'] = cause;
    data['executor'] = executor;
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

//死亡事件传入参数
class DeathArgument {
  late final String id; //ID
  late final String date; //死亡时间
  late final String? batchNo; //批次号
  late final int count; //数量
  late final String? cowId; //牛只ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final int cause; //死亡原因
  late final String? executor; //鉴定人
  late final String? attach; //附件
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  DeathArgument({
    required this.id,
    required this.date,
    this.batchNo,
    required this.count,
    this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.cause,
    this.executor,
    this.attach,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  DeathArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    batchNo = json['batchNo'];
    count = json['count'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    cause = json['cause'];
    executor = json['executor'];
    attach = json['attach'];
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
    data['date'] = date;
    data['batchNo'] = batchNo;
    data['count'] = count;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['cause'] = cause;
    data['executor'] = executor;
    data['attach'] = attach;
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

//销售事件传入参数
class SellArgument {
  late final String id; //ID
  late final String date; //销售时间
  late final String? batchNo; //批次号
  late final int type; //类型1：种牛；2：犊牛-育肥牛；
  late final int count; //数量
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final double price; //单价
  late final double weight; //重量
  late final double breakage; //折损
  late final double total; //小计
  late final String? seller; //销售人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  SellArgument({
    required this.id,
    required this.date,
    this.batchNo,
    required this.type,
    required this.count,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.price,
    required this.weight,
    required this.breakage,
    required this.total,
    this.seller,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  SellArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    batchNo = json['batchNo'];
    type = json['type'];
    count = json['count'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    price = double.parse((json['price'] ?? 0).toString());
    weight = double.parse((json['weight'] ?? 0).toString());
    breakage = double.parse((json['breakage'] ?? 0).toString());
    total = double.parse((json['total'] ?? 0).toString());
    seller = json['seller'];
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
    data['date'] = date;
    data['batchNo'] = batchNo;
    data['type'] = type;
    data['count'] = count;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['price'] = price;
    data['weight'] = weight;
    data['breakage'] = breakage;
    data['total'] = total;
    data['seller'] = seller;
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

//盘点事件传入参数
class CheckArgument {
  late final String id; //ID
  late final String date; //盘点时间
  late final String cowHouseId; //栋舍
  late final String? cowHouseName; //栋舍名称
  late final int count; //数量
  late final String? executor; //盘点人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  CheckArgument({
    required this.id,
    required this.date,
    required this.cowHouseId,
    this.cowHouseName,
    required this.count,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CheckArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    count = json['count'];
    executor = json['executor'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['count'] = count;
    data['executor'] = executor;
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

///发情事件传入参数
class RutArgument {
  late final String id; //ID
  late final String date; //发情日期
  late final String? cowHouseId; //栋舍编码
  late final String? cowHouseName; //栋舍名称
  late final String? cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final int present; //发情表现1：明显；2：不明显；
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  RutArgument({
    required this.id,
    required this.date,
    this.cowHouseId,
    this.cowHouseName,
    this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.present,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  RutArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    present = json['present'];
    executor = json['executor'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['present'] = present;
    data['executor'] = executor;
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

///采精事件传入参数
class SemenEvent {
  late final String id; //ID
  late final String date; //采精日期
  late final String? cowHouseId; //栋舍编码
  late final String? cowHouseName; //栋舍名称
  late final String? cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final double dosage; //采集量
  late final int quality; //精液质量1：合格；2：不合格；
  late final int copies; //稀释份数
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  SemenEvent({
    required this.id,
    required this.date,
    this.cowHouseId,
    this.cowHouseName,
    this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.dosage,
    required this.quality,
    required this.copies,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  SemenEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    dosage = double.parse((json['dosage'] ?? 0).toString());
    quality = json['quality'];
    copies = json['copies'];
    executor = json['executor'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['dosage'] = dosage;
    data['quality'] = quality;
    data['copies'] = copies;
    data['executor'] = executor;
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

///断奶事件传入参数
class WeanEvent {
  late final String id; //ID
  late final String date; //断奶时间
  late final String? cowHouseId; //栋舍编码
  late final String? cowHouseName; //栋舍名称
  late final String? cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final int nums; //断奶头数
  late final double weight; //断奶重量
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String? batchNo; //育肥牛批次
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  WeanEvent({
    required this.id,
    required this.date,
    this.cowHouseId,
    this.cowHouseName,
    this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.nums,
    required this.weight,
    this.executor,
    this.remark,
    this.batchNo,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  WeanEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    nums = json['nums'];
    weight = double.parse((json['weight'] ?? 0).toString());
    executor = json['executor'];
    remark = json['remark'];
    batchNo = json['batchNo'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['nums'] = nums;
    data['weight'] = weight;
    data['executor'] = executor;
    data['remark'] = remark;
    data['batchNo'] = batchNo;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}

///孕检事件传入参数
class PregcyEvent {
  late final String id; //ID
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String date; //孕检时间
  late final int result; //孕检结果1：返情；2：流产；3：B超阴性；4：B超阳性；
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  PregcyEvent({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.date,
    required this.result,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  PregcyEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    date = json['date'];
    result = json['result'];
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['date'] = date;
    data['result'] = result;
    data['executor'] = executor;
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

///禁配事件传入参数
class BanEvent {
  late final String id; //ID
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String startDate; //开始日期
  late final String? endDate; //截止日期
  late final int reason; //禁配原因1：体况差；2：诊疗中（疾病）；3：待淘汰；4：其他；
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  BanEvent({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.startDate,
    this.endDate,
    required this.reason,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  BanEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    reason = json['reason'];
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['startDate'] = startDate;
    data['endDate'] = endDate;
    data['reason'] = reason;
    data['executor'] = executor;
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

///引种事件传入参数
class BuyInEvent {
  late final String id; //ID
  late final String? batchNo; //批次号
  late final String? sourceFarm; //来源场
  late final String? inArea; //入场时间
  late final String date; //引种时间
  late final int count; //数量
  late final String? birth; //出生日期
  late final int kind; //品种
  late final int gender; //性别1：公；2：母；
  late final String? column; //栏位
  late final String cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍名称
  late final String? executor; //引种人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  BuyInEvent({
    required this.id,
    this.batchNo,
    this.sourceFarm,
    this.inArea,
    required this.date,
    required this.count,
    this.birth,
    required this.kind,
    required this.gender,
    this.column,
    required this.cowHouseId,
    this.cowHouseName,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  BuyInEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    batchNo = json['batchNo'];
    sourceFarm = json['sourceFarm'];
    inArea = json['inArea'];
    date = json['date'];
    count = json['count'];
    birth = json['birth'];
    kind = json['kind'];
    gender = json['gender'];
    column = json['column'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    executor = json['executor'];
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
    data['batchNo'] = batchNo;
    data['sourceFarm'] = sourceFarm;
    data['inArea'] = inArea;
    data['date'] = date;
    data['count'] = count;
    data['birth'] = birth;
    data['kind'] = kind;
    data['gender'] = gender;
    data['column'] = column;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['executor'] = executor;
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

///选种事件传入参数
class SelectEvent {
  late final String id; //ID
  late final String date; //选种时间
  late final String? batchNo; //批次号
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final int gender; //性别1：公；2：母；
  late final int kind; //品种
  late final String birth; //出生日期
  late final String inCowHouseId; //转入栋舍ID
  late final String? inCowHouseName; //转入栋舍名称
  late final String? inColumn; //转入栏位
  late final String? executor; //技术员
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  late final String? remark; //备注

  SelectEvent({
    required this.id,
    required this.date,
    this.batchNo,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.gender,
    required this.kind,
    required this.birth,
    required this.inCowHouseId,
    this.inCowHouseName,
    this.inColumn,
    this.executor,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
    this.remark,
  });
  SelectEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    batchNo = json['batchNo'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    gender = json['gender'];
    kind = json['kind'];
    birth = json['birth'];
    remark = json['remark'];
    inCowHouseId = json['inCowHouseId'];
    inCowHouseName = json['inCowHouseName'];
    inColumn = json['inColumn'];
    executor = json['executor'];
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
    data['date'] = date;
    data['batchNo'] = batchNo;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['gender'] = gender;
    data['kind'] = kind;
    data['birth'] = birth;
    data['remark'] = remark;
    data['inCowHouseId'] = inCowHouseId;
    data['inCowHouseName'] = inCowHouseName;
    data['inColumn'] = inColumn;
    data['executor'] = executor;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    return data;
  }
}

///调拨事件传入参数
class AllotEvent {
  late final String id; //ID
  late final int type; //类型1：种牛；2：犊牛-育肥牛；
  late final String date; //调拨时间
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String? batchNo; //批次号
  late final int count; //数量
  late final String outFarmId; //调出场ID
  late final String? outFarmName; //调出场
  late final String outCowHouseId; //调出栋舍
  late final String? outCowHouseName; //调出栋舍
  late final String? outColumn; //调出栏位
  late final String inFarmId; //调入场ID
  late final String? inFarmName; //调入场
  late final String inCowHouseId; //调入栋舍
  late final String? inCowHouseName; //调入栋舍
  late final String? inColumn; //调入栏位
  late final String? executor; //调拨人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  AllotEvent({
    required this.id,
    required this.type,
    required this.date,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    this.batchNo,
    required this.count,
    required this.outFarmId,
    this.outFarmName,
    required this.outCowHouseId,
    this.outCowHouseName,
    this.outColumn,
    required this.inFarmId,
    this.inFarmName,
    required this.inCowHouseId,
    this.inCowHouseName,
    this.inColumn,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  AllotEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    type = json['type'];
    date = json['date'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    batchNo = json['batchNo'];
    count = json['count'];
    outFarmId = json['outFarmId'];
    outFarmName = json['outFarmName'];
    outCowHouseId = json['outCowHouseId'];
    outCowHouseName = json['outCowHouseName'];
    outColumn = json['outColumn'];
    inFarmId = json['inFarmId'];
    inFarmName = json['inFarmName'];
    inCowHouseId = json['inCowHouseId'];
    inCowHouseName = json['inCowHouseName'];
    inColumn = json['inColumn'];
    executor = json['executor'];
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
    data['type'] = type;
    data['date'] = date;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['batchNo'] = batchNo;
    data['count'] = count;
    data['outFarmId'] = outFarmId;
    data['outFarmName'] = outFarmName;
    data['outCowHouseId'] = outCowHouseId;
    data['outCowHouseName'] = outCowHouseName;
    data['outColumn'] = outColumn;
    data['inFarmId'] = inFarmId;
    data['inFarmName'] = inFarmName;
    data['inCowHouseId'] = inCowHouseId;
    data['inCowHouseName'] = inCowHouseName;
    data['inColumn'] = inColumn;
    data['executor'] = executor;
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

///解禁事件传入参数
class UnBanEvent {
  late final String id; //ID
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String date; //解禁时间
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  UnBanEvent({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.date,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  UnBanEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    date = json['date'];
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['date'] = date;
    data['executor'] = executor;
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

///配种事件传入参数
class MatingEvent {
  late final String id; //ID
  late final String date; //配种时间
  late final String? cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍名称
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final int type; //配种方式1：本交；2：人工输精；
  late final String maleCowId; //公牛ID
  late final String? maleCowCode; //公牛耳号
  late final String? semenNumber; //精液编号
  late final int copies; //精液份数
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  MatingEvent({
    required this.id,
    required this.date,
    this.cowHouseId,
    this.cowHouseName,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.type,
    required this.maleCowId,
    this.maleCowCode,
    this.semenNumber,
    required this.copies,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  MatingEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    type = json['type'];
    maleCowId = json['maleCowId'];
    maleCowCode = json['maleCowCode'];
    semenNumber = json['semenNumber'];
    copies = json['copies'];
    executor = json['executor'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['type'] = type;
    data['maleCowId'] = maleCowId;
    data['maleCowCode'] = maleCowCode;
    data['semenNumber'] = semenNumber;
    data['copies'] = copies;
    data['executor'] = executor;
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

///产犊事件传入参数
class CalvEvent {
  late final String id; //ID
  late final String date; //产犊时间
  late final String? cowHouseId; //栋舍编码
  late final String? cowHouseName; //栋舍名称
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String? executor; //技术员
  late final int reason; //产护1：顺产；2：难产；3：难产助产；
  late final int nums; //产犊数
  late final double weight; //犊牛重量
  late final int dieNums; //死亡数量
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  CalvEvent({
    required this.id,
    required this.date,
    this.cowHouseId,
    this.cowHouseName,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    this.executor,
    required this.reason,
    required this.nums,
    required this.weight,
    required this.dieNums,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CalvEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    executor = json['executor'];
    reason = json['reason'];
    nums = json['nums'];
    weight = double.parse((json['weight'] ?? 0).toString());
    dieNums = json['dieNums'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['executor'] = executor;
    data['reason'] = reason;
    data['nums'] = nums;
    data['weight'] = weight;
    data['dieNums'] = dieNums;
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

///防疫事件传入参数
class PreventionEvent {
  late final String id; //ID
  late final String date; //防疫时间
  late final int loimia; //疫病 1：口蹄疫、2：牛布氏杆菌病、3：牛病毒性腹泻、4：牛副伤寒、5：牛巴氏杆菌病、6：牛传染性胸膜肺炎、7：魏氏梭菌病、8：牛传染性鼻气管炎
  late final int vaccine; //疫苗 1：口蹄疫疫苗、2：牛布氏杆菌病疫苗、3：牛病毒性腹泻疫苗、4：牛副伤寒灭活菌苗、5：牛巴氏杆菌病灭活菌苗、6：牛传染性胸膜肺炎疫苗、7：魏氏梭菌病疫苗、8：牛传染性鼻气管炎
  late final String? cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? batchNo; //批次号
  late final String? cowHouseId; //栋舍
  late final String? cowHouseName; //栋舍名称
  late final int status; //当前状态 1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  late final int count; //头数
  late final double dosage; //单头剂量
  late final int? unit; //剂量单位
  late final double total; //总剂量
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  PreventionEvent({
    required this.id,
    required this.date,
    required this.loimia,
    required this.vaccine,
    this.cowId,
    this.cowCode,
    this.batchNo,
    this.cowHouseId,
    this.cowHouseName,
    required this.status,
    required this.count,
    required this.dosage,
    this.unit,
    required this.total,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  PreventionEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    loimia = json['loimia'] ?? 0;
    vaccine = json['vaccine'] ?? 0;
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    batchNo = json['batchNo'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    if (json['status'] != null) {
      status = json['status'];
    } else if (json['state'] != null) {
      status = json['state'];
    }
    count = json['count'] ?? 0;
    dosage = double.parse((json['dosage'] ?? 0).toString());
    unit = json['unit'];
    total = double.parse((json['total'] ?? 0).toString());
    executor = json['executor'];
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
    data['date'] = date;
    data['loimia'] = loimia;
    data['vaccine'] = vaccine;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['batchNo'] = batchNo;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['status'] = status;
    data['count'] = count;
    data['dosage'] = dosage;
    data['unit'] = unit;
    data['total'] = total;
    data['executor'] = executor;
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

///保健事件传入参数
class HealthCareEvent {
  late final String id; //ID
  late final String cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍
  late final String cowId; //牛只编码
  late final String? batchNo; //批次号
  late final String date; //保健时间
  late final int status; //当前状态 1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  late final int type; //保健类型 1：驱虫；2：消毒；
  late final int count; //头数
  late final String? pharmacy; //用药
  late final double? dosage; //单头剂量
  late final double? total; //总剂量
  late final int unit; //剂量单位
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  HealthCareEvent({
    required this.id,
    required this.cowHouseId,
    this.cowHouseName,
    required this.cowId,
    this.batchNo,
    required this.date,
    required this.status,
    required this.type,
    required this.count,
    this.pharmacy,
    required this.dosage,
    required this.total,
    required this.unit,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  HealthCareEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    cowId = json['cowId'];
    batchNo = json['batchNo'];
    date = json['date'];
    status = json['status'];
    type = json['type'];
    count = json['count'];
    pharmacy = json['pharmacy'];
    dosage = double.parse((json['dosage'] ?? 0).toString());
    total = double.parse((json['total'] ?? 0).toString());
    unit = json['unit'];
    executor = json['executor'];
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
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['cowId'] = cowId;
    data['batchNo'] = batchNo;
    data['date'] = date;
    data['status'] = status;
    data['type'] = type;
    data['count'] = count;
    data['pharmacy'] = pharmacy;
    data['dosage'] = dosage;
    data['total'] = total;
    data['unit'] = unit;
    data['executor'] = executor;
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

///盘点事件传入参数
class CheckEvent {
  late final String id; //ID
  late final String date; //盘点时间
  late final String cowHouseId; //栋舍
  late final String? cowHouseName; //栋舍名称
  late final int count; //数量
  late final String? executor; //盘点人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  CheckEvent({
    required this.id,
    required this.date,
    required this.cowHouseId,
    this.cowHouseName,
    required this.count,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CheckEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    count = json['count'];
    executor = json['executor'];
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
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['count'] = count;
    data['executor'] = executor;
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

///饲喂事件传入参数
class FeedEvent {
  late final String id; //ID
  late final String date; //饲喂时间
  late final String cowHouseId; //栋舍
  late final String? cowHouseName; //栋舍名称
  late final int count; //头数
  late final double total; //总量
  late final String? executor; //饲喂人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本
  late final String? formulaId; //配方id
  late final String? formulaName; //配方名称
  late final int? dosage; //校正饲喂量

  FeedEvent({
    required this.id,
    required this.date,
    required this.cowHouseId,
    this.cowHouseName,
    required this.count,
    required this.total,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
    this.formulaId,
    this.formulaName,
    this.dosage,
  });
  FeedEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    count = json['count'];
    total = double.parse((json['total'] ?? 0).toString());
    executor = json['executor'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    formulaId = json['formulaId'];
    formulaName = json['formulaName'];
    dosage = json['dosage'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['date'] = date;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['count'] = count;
    data['total'] = total;
    data['executor'] = executor;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    data['formulaId'] = formulaId;
    data['formulaName'] = formulaName;
    data['dosage'] = dosage;
    return data;
  }
}

///转群事件传入参数
class ChangeGroupEvent {
  late final String id; //ID
  late final String date; //转群时间
  late final int type; //类型1：种牛；2：犊牛-育肥牛；
  late final String cowId; //牛只编码
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String? batchNo; //批次号
  late final int count; //数量
  late final String outCowHouseId; //转出栋舍
  late final String? outCowHouseName; //转出栋舍名称
  late final String? outColumn; //转出栏位
  late final String inCowHouseId; //转入栋舍
  late final String? inCowHouseName; //转入栋舍名称
  late final String? inColumn; //转入栏位
  late final String? executor; //转群人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  ChangeGroupEvent({
    required this.id,
    required this.date,
    required this.type,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    this.batchNo,
    required this.count,
    required this.outCowHouseId,
    this.outCowHouseName,
    this.outColumn,
    required this.inCowHouseId,
    this.inCowHouseName,
    this.inColumn,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  ChangeGroupEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    type = json['type'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    batchNo = json['batchNo'];
    count = json['count'];
    outCowHouseId = json['outCowHouseId'];
    outCowHouseName = json['outCowHouseName'];
    outColumn = json['outColumn'];
    inCowHouseId = json['inCowHouseId'];
    inCowHouseName = json['inCowHouseName'];
    inColumn = json['inColumn'];
    executor = json['executor'];
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
    data['date'] = date;
    data['type'] = type;
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['batchNo'] = batchNo;
    data['count'] = count;
    data['outCowHouseId'] = outCowHouseId;
    data['outCowHouseName'] = outCowHouseName;
    data['outColumn'] = outColumn;
    data['inCowHouseId'] = inCowHouseId;
    data['inCowHouseName'] = inCowHouseName;
    data['inColumn'] = inColumn;
    data['executor'] = executor;
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

///诊疗事件传入参数
class TreatmentEvent {
  late final String id; //ID
  late final String? cowId; //牛只ID
  late final String? cowCode; //耳号
  late final String? batchNo; //批次号
  late final String date; //诊疗时间
  late final int illness; //疾病名称 1：口蹄疫、2：病毒性腹泻、3：疟疾、4：高热呼吸道病毒性病害（BHV-1）、5：传染性鼻气管炎、6：瘤胃酸中毒、7：钙缺乏症、8：肺炎、9：产后子宫炎
  late final int? count; //事件的头数
  late final String? symptom; //症状
  late final String? treatmentPerson; //诊疗人
  late final String? pharmacy; //用药
  late final double dosage; //剂量
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  TreatmentEvent({
    required this.id,
    this.cowId,
    this.cowCode,
    this.batchNo,
    required this.date,
    required this.illness,
    this.count,
    this.symptom,
    this.treatmentPerson,
    this.pharmacy,
    required this.dosage,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  TreatmentEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    batchNo = json['batchNo'];
    date = json['date'];
    illness = json['illness'];
    count = json['count'];
    symptom = json['symptom'];
    treatmentPerson = json['treatmentPerson'];
    pharmacy = json['pharmacy'];
    dosage = double.parse((json['dosage'] ?? 0).toString());
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['batchNo'] = batchNo;
    data['date'] = date;
    data['illness'] = illness;
    data['count'] = count;
    data['symptom'] = symptom;
    data['treatmentPerson'] = treatmentPerson;
    data['pharmacy'] = pharmacy;
    data['dosage'] = dosage;
    data['executor'] = executor;
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

///品相评估事件传入参数
class AssessmentModel {
  late final String id; //ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String cowId; //牛只ID
  late final String date; //评估日期
  late final int forebreast; //前胸 1：优秀；2：合格；3：不合格；
  late final int allFours; //四肢 1：优秀；2：合格；3：不合格；
  late final int stance; //站立姿势 1：优秀；2：合格；3：不合格；
  late final int hipDrive; //驱臀 1：优秀；2：合格；3：不合格；
  late final int testis; //睾丸 1：优秀；2：合格；3：不合格；
  late final int breast; //乳房 1：优秀；2：合格；3：不合格；
  late final int vulva; //阴户 1：优秀；2：合格；3：不合格；
  late final int geneticDefect; //遗传缺陷 1：有；2：无；
  late final double? score; //综合评分 1-5分
  late final String? executor; //评估人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  AssessmentModel({
    required this.id,
    this.cowCode,
    this.cowEleCode,
    required this.cowId,
    required this.date,
    required this.forebreast,
    required this.allFours,
    required this.stance,
    required this.hipDrive,
    required this.testis,
    required this.breast,
    required this.vulva,
    required this.geneticDefect,
    required this.score,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  AssessmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    cowId = json['cowId'];
    date = json['date'];
    forebreast = json['forebreast'];
    allFours = json['allFours'];
    stance = json['stance'];
    hipDrive = json['hipDrive'];
    testis = json['testis'];
    breast = json['breast'];
    vulva = json['vulva'];
    geneticDefect = json['geneticDefect'];
    score = double.parse((json['score'] ?? 0).toString());
    executor = json['executor'];
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
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['cowId'] = cowId;
    data['date'] = date;
    data['forebreast'] = forebreast;
    data['allFours'] = allFours;
    data['stance'] = stance;
    data['hipDrive'] = hipDrive;
    data['testis'] = testis;
    data['breast'] = breast;
    data['vulva'] = vulva;
    data['geneticDefect'] = geneticDefect;
    data['score'] = score;
    data['executor'] = executor;
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

/// 后裔登记事件
class DescendantsModel {
  late final String id; //ID
  late final String? cowEleCode; //电子耳号
  late final String cowId; //牛只ID
  late final String? code; //犊牛耳号
  late final String date; //登记日期
  late final String? paternalCowId; //父系
  late final String? paternalCowCode; //父系耳号
  late final String? maternalCowId; //母系
  late final String? maternalCowCode; //母系耳号
  late final String cowHouseId; //栋舍ID
  late final String? cowHouseName; //栋舍
  late final String birth; //出生日期
  late final double? birthWeight; //犊牛体重（kg）
  late final int gender; //性别1：公；2：母；
  late final int kind; //品种1：安格斯；2：西门塔尔；3：利木赞；4：皮埃蒙特；5：夏洛莱牛；6：澳洲和牛；7：秦川牛；8：黄牛；
  late final String? executor; //登记人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  DescendantsModel({
    required this.id,
    this.cowEleCode,
    required this.cowId,
    this.code,
    required this.date,
    this.paternalCowId,
    this.paternalCowCode,
    this.maternalCowId,
    this.maternalCowCode,
    required this.cowHouseId,
    this.cowHouseName,
    required this.birth,
    this.birthWeight,
    required this.gender,
    required this.kind,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  DescendantsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowEleCode = json['cowEleCode'];
    cowId = json['cowId'];
    code = json['code'];
    date = json['date'];
    paternalCowId = json['paternalCowId'];
    paternalCowCode = json['paternalCowCode'];
    maternalCowId = json['maternalCowId'];
    maternalCowCode = json['maternalCowCode'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    birth = json['birth'];
    birthWeight = double.parse((json['birthWeight'] ?? 0).toString());
    gender = json['gender'];
    kind = json['kind'];
    executor = json['executor'];
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
    data['cowEleCode'] = cowEleCode;
    data['cowId'] = cowId;
    data['code'] = code;
    data['date'] = date;
    data['paternalCowId'] = paternalCowId;
    data['paternalCowCode'] = paternalCowCode;
    data['maternalCowId'] = maternalCowId;
    data['maternalCowCode'] = maternalCowCode;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['birth'] = birth;
    data['birthWeight'] = birthWeight;
    data['gender'] = gender;
    data['kind'] = kind;
    data['executor'] = executor;
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

/// 体尺测定事件
class MeasurementEvent {
  late final String id; //ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String cowId; //牛只ID
  late final String date; //测定日期
  late final double? foreheadSize; //额宽cm
  late final double? bodyHeight; //体高cm
  late final double? bodyLen; //体长cm
  late final double? bodyDiagonalLen; //体斜长cm
  late final double? chestWide; //胸宽cm
  late final double? chestDepth; //胸深cm
  late final double? chest; //胸围cm
  late final double? waistline; //腰角宽cm
  late final double? cocbone; //管围cm
  late final double? wight; //体重kg
  late final int source; //来源 1：手动录入；2：设备测定；
  late final String deviceId; //设备ID
  late final String? executor; //测定人
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  MeasurementEvent({
    required this.id,
    this.cowCode,
    this.cowEleCode,
    required this.cowId,
    required this.date,
    required this.foreheadSize,
    required this.bodyHeight,
    required this.bodyLen,
    required this.bodyDiagonalLen,
    required this.chestWide,
    required this.chestDepth,
    required this.chest,
    required this.waistline,
    required this.cocbone,
    required this.wight,
    required this.source,
    required this.deviceId,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  MeasurementEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    cowId = json['cowId'];
    date = json['date'];
    foreheadSize = double.parse((json['foreheadSize'] ?? 0).toString());
    bodyHeight = double.parse((json['bodyHeight'] ?? 0).toString());
    bodyLen = double.parse((json['bodyLen'] ?? 0).toString());
    bodyDiagonalLen = double.parse((json['bodyDiagonalLen'] ?? 0).toString());
    chestWide = double.parse((json['chestWide'] ?? 0).toString());
    chestDepth = double.parse((json['chestDepth'] ?? 0).toString());
    chest = double.parse((json['chest'] ?? 0).toString());
    waistline = double.parse((json['waistline'] ?? 0).toString());
    cocbone = double.parse((json['cocbone'] ?? 0).toString());
    wight = double.parse((json['wight'] ?? 0).toString());
    source = json['source'];
    deviceId = json['deviceId'];
    executor = json['executor'];
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
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['cowId'] = cowId;
    data['date'] = date;
    data['foreheadSize'] = foreheadSize;
    data['bodyHeight'] = bodyHeight;
    data['bodyLen'] = bodyLen;
    data['bodyDiagonalLen'] = bodyDiagonalLen;
    data['chestWide'] = chestWide;
    data['chestDepth'] = chestDepth;
    data['chest'] = chest;
    data['waistline'] = waistline;
    data['cocbone'] = cocbone;
    data['wight'] = wight;
    data['source'] = source;
    data['deviceId'] = deviceId;
    data['executor'] = executor;
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

// 性状统计
class CharactersArgument {
  late final String id; //ID
  late final String cowId; //牛只ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final double? dailyGain; //日增重
  late final double? efficiencyOfFeed; //饲料利用率
  late final double? birthWeight; //出生重
  late final double? weanWeight; //断奶重
  late final double? weanDailyGain; //断奶后日增重
  late final double? adultWeight; //成年体重
  late final double? pregnancyRateOfBulls; //公牛受胎率
  late final double? calvRate; //产犊率
  late final double? rateOfWean; //犊牛断奶成活率
  late final double? deadWeight; //屠宰量
  late final double? fatThickness; //脂肪厚度
  late final double? eyeMuscleArea; //眼肌面积
  late final double? musclePh; //肌肉PH
  late final double? muscleFatRate; //肌肉脂肪率
  late final double? backfatThickness; //背膘厚度
  late final double? pureMeatRate; //净肉率
  late final int fleshcolor; //肉色 1-5级
  late final int marble; //大理石纹 1分-仅有痕迹，2分-微量脂肪，3分-少量脂肪，4分-适量脂肪，5分-过量脂肪
  late final double? tenderness; //嫩度
  late final double? waterHold; //系水力
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  CharactersArgument({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.dailyGain,
    required this.efficiencyOfFeed,
    required this.birthWeight,
    required this.weanWeight,
    required this.weanDailyGain,
    required this.adultWeight,
    required this.pregnancyRateOfBulls,
    required this.calvRate,
    required this.rateOfWean,
    required this.deadWeight,
    required this.fatThickness,
    required this.eyeMuscleArea,
    required this.musclePh,
    required this.muscleFatRate,
    required this.backfatThickness,
    required this.pureMeatRate,
    required this.fleshcolor,
    required this.marble,
    required this.tenderness,
    required this.waterHold,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  CharactersArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    dailyGain = double.parse((json['dailyGain'] ?? 0).toString());
    efficiencyOfFeed = double.parse((json['efficiencyOfFeed'] ?? 0).toString());
    birthWeight = double.parse((json['birthWeight'] ?? 0).toString());
    weanWeight = double.parse((json['weanWeight'] ?? 0).toString());
    weanDailyGain = double.parse((json['weanDailyGain'] ?? 0).toString());
    adultWeight = double.parse((json['adultWeight'] ?? 0).toString());
    pregnancyRateOfBulls = double.parse((json['pregnancyRateOfBulls'] ?? 0).toString());
    calvRate = double.parse((json['calvRate'] ?? 0).toString());
    rateOfWean = double.parse((json['rateOfWean'] ?? 0).toString());
    deadWeight = double.parse((json['deadWeight'] ?? 0).toString());
    fatThickness = double.parse((json['fatThickness'] ?? 0).toString());
    eyeMuscleArea = double.parse((json['eyeMuscleArea'] ?? 0).toString());
    musclePh = double.parse((json['musclePh'] ?? 0).toString());
    muscleFatRate = double.parse((json['muscleFatRate'] ?? 0).toString());
    backfatThickness = double.parse((json['backfatThickness'] ?? 0).toString());
    pureMeatRate = double.parse((json['pureMeatRate'] ?? 0).toString());
    fleshcolor = json['fleshcolor'];
    marble = json['marble'];
    tenderness = double.parse((json['tenderness'] ?? 0).toString());
    waterHold = double.parse((json['waterHold'] ?? 0).toString());
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['dailyGain'] = dailyGain;
    data['efficiencyOfFeed'] = efficiencyOfFeed;
    data['birthWeight'] = birthWeight;
    data['weanWeight'] = weanWeight;
    data['weanDailyGain'] = weanDailyGain;
    data['adultWeight'] = adultWeight;
    data['pregnancyRateOfBulls'] = pregnancyRateOfBulls;
    data['calvRate'] = calvRate;
    data['rateOfWean'] = rateOfWean;
    data['deadWeight'] = deadWeight;
    data['fatThickness'] = fatThickness;
    data['eyeMuscleArea'] = eyeMuscleArea;
    data['musclePh'] = musclePh;
    data['muscleFatRate'] = muscleFatRate;
    data['backfatThickness'] = backfatThickness;
    data['pureMeatRate'] = pureMeatRate;
    data['fleshcolor'] = fleshcolor;
    data['marble'] = marble;
    data['tenderness'] = tenderness;
    data['waterHold'] = waterHold;
    data['executor'] = executor;
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

// 选育测定
class AssayArgument {
  late final String id; //ID
  late final String cowId; //牛只ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final String date; //测定日期
  late final int result; //测定结果 0：未知；1：选种；2：淘汰；
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  AssayArgument({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.date,
    required this.result,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  AssayArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    date = json['date'];
    result = json['result'];
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['date'] = date;
    data['result'] = result;
    data['executor'] = executor;
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

/// 近交测定
class InBreedArgument {
  late final String id; //ID
  late final String cowId; //母牛ID
  late final String? cowCode; //母牛耳号
  late final String? maleCowId; //公牛ID
  late final String? maleCowCode; //公牛耳号
  late final String date; //测定时间
  late final double? coefficient; //近交系数
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  InBreedArgument({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.maleCowId,
    this.maleCowCode,
    required this.date,
    required this.coefficient,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  InBreedArgument.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    maleCowId = json['maleCowId'];
    maleCowCode = json['maleCowCode'];
    date = json['date'];
    coefficient = double.parse((json['coefficient'] ?? 0).toString());
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['maleCowId'] = maleCowId;
    data['maleCowCode'] = maleCowCode;
    data['date'] = date;
    data['coefficient'] = coefficient;
    data['executor'] = executor;
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

// 育种值统计
class BreedValueEvent {
  late final String id; //ID
  late final String cowId; //牛只ID
  late final String? cowCode; //耳号
  late final String? cowEleCode; //电子耳号
  late final double? value; //育种值
  late final double? avgValue; //平均育种值
  late final String? source; //数据来源
  late final String? executor; //技术员
  late final String? remark; //备注
  late final String tenantId; //租户
  late final String created; //创建时间
  late final String? createdBy; //创建人
  late final String? modified; //修改时间
  late final String? modifiedBy; //修改人
  late final String rowVersion; //行版本

  BreedValueEvent({
    required this.id,
    required this.cowId,
    this.cowCode,
    this.cowEleCode,
    required this.value,
    required this.avgValue,
    this.source,
    this.executor,
    this.remark,
    required this.tenantId,
    required this.created,
    this.createdBy,
    this.modified,
    this.modifiedBy,
    required this.rowVersion,
  });
  BreedValueEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cowId = json['cowId'];
    cowCode = json['cowCode'];
    cowEleCode = json['cowEleCode'];
    value = double.parse((json['value'] ?? 0).toString());
    avgValue = double.parse((json['avgValue'] ?? 0).toString());
    source = json['source'];
    executor = json['executor'];
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
    data['cowId'] = cowId;
    data['cowCode'] = cowCode;
    data['cowEleCode'] = cowEleCode;
    data['value'] = value;
    data['avgValue'] = avgValue;
    data['source'] = source;
    data['executor'] = executor;
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

//采购事件
class PurchaseEvent {
  late final String id;
  late final String no; //单号
  late final String date;
  late final int type;
  late final String name; //名称
  late final String manufacturers; //厂家
  late final int count; //数量
  late final double price; //单价
  late final double amount; //总价
  late final double breakage;
  late final String executor;
  late final String remark;
  late final String tenantId;
  late final String created;
  late final String createdBy;
  late final String modified;
  late final String modifiedBy;
  late final String rowVersion;

  PurchaseEvent.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? "";
    no = json['no'] ?? "";
    date = json['date'] ?? "";
    type = int.parse((json['type'] ?? 0).toString());
    name = json['name'] ?? "";
    manufacturers = json["manufacturers"] ?? "";
    count = int.parse((json['count'] ?? 0).toString());
    price = double.parse((json['price'] ?? 0).toString());
    amount = double.parse((json['amount'] ?? 0).toString());
    breakage = double.parse((json['breakage'] ?? 0).toString());
    executor = json['executor'] ?? "";
    remark = json['remark'] ?? "";
    tenantId = json['tenantId'] ?? "";
    created = json['created'] ?? "";
    createdBy = json['createdBy'] ?? "";
    modified = json['modified'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    rowVersion = json['rowVersion'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["id"] = this.id;
    data["no"] = this.no;
    data["date"] = this.date;
    data["type"] = this.type;
    data["name"] = this.name;
    data["manufacturers"] = this.manufacturers;
    data["count"] = this.count;
    data["price"] = this.price;
    data["amount"] = this.amount;
    data["breakage"] = this.breakage;
    data["executor"] = this.executor;
    data["remark"] = this.remark;
    data["tenantId"] = this.tenantId;
    data["created"] = this.created;
    data["createdBy"] = this.createdBy;
    data["modified"] = this.modified;
    data["modifiedBy"] = this.modifiedBy;
    data["rowVersion"] = this.rowVersion;

    return data;
  }
}

// 人工事件
class ManualWorkEvent {
  late final String id;
  late final String no;
  late final String date;
  late final int type;
  late final double amount;
  late final String employee;
  late final String post;
  late final String remark;
  late final String executor;
  late final String tenantId;
  late final String created;
  late final String createdBy;
  late final String modified;
  late final String modifiedBy;
  late final String rowVersion;

  ManualWorkEvent.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? "";
    no = json['no'] ?? "";
    date = json['date'] ?? "";
    type = int.parse((json['type'] ?? 0).toString());
    amount = double.parse((json['amount'] ?? 0).toString());
    employee = json['employee'] ?? "";
    post = json['post'] ?? "";
    executor = json['executor'] ?? "";
    remark = json["remark"] ?? "";
    tenantId = json['tenantId'] ?? "";
    created = json['created'] ?? "";
    createdBy = json['createdBy'] ?? "";
    modified = json['modified'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    rowVersion = json['rowVersion'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["id"] = this.id;
    data["no"] = this.no;
    data["date"] = this.date;
    data["type"] = this.type;
    data["amount"] = this.amount;
    data["employee"] = this.employee;
    data["post"] = this.post;
    data["remark"] = this.remark;
    data["executor"] = this.executor;
    data["tenantId"] = this.tenantId;
    data["created"] = this.created;
    data["createdBy"] = this.createdBy;
    data["modified"] = this.modified;
    data["modifiedBy"] = this.modifiedBy;
    data["rowVersion"] = this.rowVersion;

    return data;
  }
}

// 健康评估
class HealthAssessEvent {
  late final String id;
  late final String cowId;
  late final String cowCode;
  late final String date;
  late final int ageOfDay;
  late final int calvNum;
  late final String illness;
  late final int treatCount;
  late final int state;
  late final String executor;
  late final String remark;
  late final String tenantId;
  late final String created;
  late final String createdBy;
  late final String modified;
  late final String modifiedBy;
  late final String rowVersion;

  HealthAssessEvent.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? "";
    cowId = json['cowId'] ?? "";
    cowCode = json['cowCode'] ?? "";
    date = json['date'] ?? "";
    ageOfDay = int.parse((json['ageOfDay'] ?? 0).toString());
    calvNum = int.parse((json['calvNum'] ?? 0).toString());
    illness = json['illness'] ?? "";
    treatCount = int.parse((json['treatCount'] ?? 0).toString());
    state = int.parse((json['state'] ?? 0).toString());
    executor = json['executor'] ?? "";
    remark = json['remark'] ?? "";
    tenantId = json['tenantId'] ?? "";
    created = json['created'] ?? "";
    createdBy = json['createdBy'] ?? "";
    modified = json['modified'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    rowVersion = json['rowVersion'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["id"] = this.id;
    data["cowId"] = this.cowId;
    data["cowCode"] = this.cowCode;
    data["date"] = this.date;
    data["ageOfDay"] = this.ageOfDay;
    data["calvNum"] = this.calvNum;
    data["illness"] = this.illness;
    data["treatCount"] = this.treatCount;
    data["state"] = this.state;
    data["executor"] = this.executor;
    data["remark"] = this.remark;
    data["tenantId"] = this.tenantId;
    data["created"] = this.created;
    data["createdBy"] = this.createdBy;
    data["modified"] = this.modified;
    data["modifiedBy"] = this.modifiedBy;
    data["rowVersion"] = this.rowVersion;

    return data;
  }
}

// 效益评估-出栏
class SalesAssessEvent {
  late final String id;
  late final String no;
  late final String date;
  late final int type;
  late final int count;
  late final double price;
  late final double breakage;
  late final double amount;
  late final String executor;
  late final String remark;
  late final String tenantId;
  late final String created;
  late final String createdBy;
  late final String modified;
  late final String modifiedBy;
  late final String rowVersion;

  SalesAssessEvent.fromJson(Map<String, dynamic> json) {
    if (json == null) {
      return;
    }
    id = json['id'] ?? "";
    no = json['no'] ?? "";
    date = json['date'] ?? "";
    type = int.parse((json['type'] ?? 0).toString());
    count = int.parse((json['count'] ?? 0).toString());
    price = double.parse((json['price'] ?? 0).toString());
    breakage = double.parse((json['breakage'] ?? 0).toString());
    amount = double.parse((json['amount'] ?? 0).toString());
    executor = json['executor'] ?? "";
    remark = json['remark'] ?? "";
    tenantId = json['tenantId'] ?? "";
    created = json['created'] ?? "";
    createdBy = json['createdBy'] ?? "";
    modified = json['modified'] ?? "";
    modifiedBy = json['modifiedBy'] ?? "";
    rowVersion = json['rowVersion'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    data["id"] = this.id;
    data["no"] = this.no;
    data["date"] = this.date;
    data["type"] = this.type;
    data["count"] = this.count;
    data["price"] = this.price;
    data["breakage"] = this.breakage;
    data["amount"] = this.amount;
    data["executor"] = this.executor;
    data["remark"] = this.remark;
    data["tenantId"] = this.tenantId;
    data["created"] = this.created;
    data["createdBy"] = this.createdBy;
    data["modified"] = this.modified;
    data["modifiedBy"] = this.modifiedBy;
    data["rowVersion"] = this.rowVersion;

    return data;
  }
}
