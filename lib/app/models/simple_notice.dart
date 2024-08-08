// 基本消息
class SimpleNotice {
  late final String id; //主键
  late final String? receiver; //接收人
  late final String? busiId; //业务ID
  late final String? content; //内容 有三只牛需要查情；
  late final int status; //状态 0：未知；1：待推送；2：推送成功；3：推送失败；
  late final int
      category; //消息大类 1：普通类；2：预警类；4：生产类；6：繁殖类；8：健康类；10：物资类；12：效益类；14：设备类；
  late final int type; //业务类型
// 1：业务通知；2：系统通知；
// 21：未发情；22：发情未配；23：未孕检；24：未产犊；25：未淘汰；
// 41：待查情；42：待配种；43：待孕检；44：待产犊；45：待断奶；46：待淘汰；47：待销售；48：待防疫；49：待保健；
// 141：环境异常；142：设备故障；143：行为异常；
  late final String? readTime; //已读时间
  late final String created; //创建时间

  SimpleNotice({
    required this.id,
    this.receiver,
    this.busiId,
    this.content,
    required this.status,
    required this.category,
    required this.type,
    this.readTime,
    required this.created,
  });
  SimpleNotice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiver = json['receiver'];
    busiId = json['busiId'];
    content = json['content'];
    status = json['status'];
    category = json['category'];
    type = json['type'];
    readTime = json['readTime'];
    created = json['created'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['receiver'] = receiver;
    data['busiId'] = busiId;
    data['content'] = content;
    data['status'] = status;
    data['category'] = category;
    data['type'] = type;
    data['readTime'] = readTime;
    data['created'] = created;
    return data;
  }
}
