//通用事件模型，只有基本事件
class SimpleEvent {
  late final String id; //ID
  late final String? date; //时间
  late final String created; //时间
  late final String? cowCode; //耳号
  late final String? batchNo; //批次号
  late final String? cowHouseName; //栋舍名称
  late final String? executor; //操作人
  late final String? seller; //销售人
  late final String? remark; //备注
  late final String rowVersion; //行版本
  late final Map data; //保存原始数据，具体页面具体解析
  late final String? no; //采购单号
  late final String? formulaId; //配方id
  late final String? formulaName; //配方名称
  late final num? dosage; //校正饲喂量
  late final int? formulaType;
  late final double? totalWeight;

  int? loimia;
  int? illness;
  int? type;
  int? state;
  int? ageOfDay;
  int? calvNum;
  int? nonpregnantDay;
  int? weanCalfNum;
  int? calfNum;

  SimpleEvent({
    required this.id,
    this.date,
    required this.created,
    this.cowCode,
    this.batchNo,
    this.cowHouseName,
    this.executor,
    this.remark,
    this.no,
    required this.rowVersion,
    required this.data,
    this.seller,
    this.formulaId,
    this.formulaName,
    this.dosage,
    this.formulaType,
    this.totalWeight,
    this.loimia,
    this.illness,
    this.type,
    this.state,
    this.ageOfDay,
    this.calvNum,
    this.nonpregnantDay,
    this.weanCalfNum,
    this.calfNum,
  });
  SimpleEvent.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    created = json['created'];
    cowCode = json['cowCode'];
    batchNo = json['batchNo'];
    cowHouseName = json['cowHouseName'];
    executor = json['executor'];
    seller = json['seller'];
    remark = json['remark'];
    rowVersion = json['rowVersion'];
    no = json['no'];
    formulaId = json['formulaId'];
    formulaName = json['formulaName'];
    dosage = json['dosage'];
    data = json;
    formulaType = json['formulaType'];
    totalWeight = double.tryParse('${json['totalWeight']}');
    loimia = json['loimia'];
    illness = json['illness'];
    type = json['type'];
    state = json['state'];
    ageOfDay = json['ageOfDay'];
    calvNum = json['calvNum'];
    nonpregnantDay = json['nonpregnantDay'];
    weanCalfNum = json['weanCalfNum'];
    calfNum = json['calfNum'];
  }

  Map<String, dynamic> toJson() {
    final temp = <String, dynamic>{};
    temp['id'] = id;
    temp['date'] = date;
    temp['created'] = created;
    temp['cowCode'] = cowCode;
    temp['batchNo'] = batchNo;
    temp['cowHouseName'] = cowHouseName;
    temp['executor'] = executor;
    temp['seller'] = seller;
    temp['remark'] = remark;
    temp['rowVersion'] = rowVersion;
    temp['data'] = data;
    temp['no'] = no;
    temp['formulaId'] = formulaId;
    temp['formulaName'] = formulaName;
    temp['dosage'] = dosage;
    return temp;
  }
}
