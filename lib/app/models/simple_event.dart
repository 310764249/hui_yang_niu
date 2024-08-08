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
  late final Map data;//保存原始数据，具体页面具体解析
  late final String? no; //采购单号


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
    data = json;
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
    return temp;
  }
}
