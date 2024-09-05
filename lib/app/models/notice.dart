import '../services/constant.dart';

///
/// 消息总类
///
class Notice {
  late final String? id; // 主键
  late final String? receiver; // 接收人
  late final String? cowId; // 牛只ID
  late final String? cowHouseId; // 栋舍ID
  late final String? cowHouseName; // 栋舍
  late final int? gender; // 公母
  late final int? growthStage; // 生长阶段1：犊牛；2：育肥牛；3：后备牛；4：种牛；5：妊娠母牛；6：哺乳母牛；7：空怀母牛；8：已淘汰；9：已销售；10：已死亡；
  late final String? batchNo; // 牛只批次
  late final String? cowCode; // 牛只耳号
  late final String? content; // 内容 有三只牛需要查情；
  late final int? status; // 状态 0：未知；1：待推送；2：推送成功；3：推送失败；
  late final int? category; // 消息大类 100：普通类；200：预警明细类；300：预警统计类；400：生产繁殖类；500：生产繁殖统计类；600：健康类；700：物资类；800：效益类；900：设备类；
  late final bool? isPush; // 是否需要推送
  late final int?
      type; // 业务类型 101：业务通知；102：系统通知；201：未发情；202：发情未配；203：未孕检；204：未产犊；205：未淘汰；401：待查情；402：待配种；403：待孕检；404：待产犊；405：待断奶；406：待淘汰；407：待销售；408：待防疫；409：待保健；901：环境异常；902：设备故障；903：行为异常；
  late final String? readTime; // 已读时间
  late final String? remark; // 备注
  late final String? tenantId; // 租户
  late final String? created; // 创建时间
  late final String? createdBy; // 创建人
  late final String? modified; // 修改时间
  late final String? modifiedBy; // 修改人
  late final String? rowVersion; // 行版本
  String? articleId; // 生产指南的id
  int? articleType; // 生产指南的type

  Notice({
    required this.id,
    required this.receiver,
    required this.cowId,
    required this.cowHouseId,
    required this.cowHouseName,
    required this.gender,
    required this.growthStage,
    required this.batchNo,
    required this.cowCode,
    required this.content,
    required this.status,
    required this.category,
    required this.isPush,
    required this.type,
    required this.readTime,
    required this.remark,
    required this.tenantId,
    required this.created,
    required this.createdBy,
    required this.modified,
    required this.modifiedBy,
    required this.rowVersion,
    this.articleId,
    this.articleType,
  });

  Notice.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    receiver = json['receiver'];
    cowId = json['cowId'];
    cowHouseId = json['cowHouseId'];
    cowHouseName = json['cowHouseName'];
    gender = json['gender'];
    growthStage = json['growthStage'];
    batchNo = json['batchNo'];
    cowCode = json['cowCode'];
    content = json['content'];
    status = json['status'];
    category = json['category'];
    isPush = json['isPush'];
    type = json['type'];
    readTime = json['readTime'];
    remark = json['remark'];
    tenantId = json['tenantId'];
    created = json['created'];
    createdBy = json['createdBy'];
    modified = json['modified'];
    modifiedBy = json['modifiedBy'];
    rowVersion = json['rowVersion'];
    articleId = json['articleId'];
    articleType = json['articleType'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['id'] = id;
    data['receiver'] = receiver;
    data['cowId'] = cowId;
    data['cowHouseId'] = cowHouseId;
    data['cowHouseName'] = cowHouseName;
    data['gender'] = gender;
    data['growthStage'] = growthStage;
    data['batchNo'] = batchNo;
    data['cowCode'] = cowCode;
    data['content'] = content;
    data['status'] = status;
    data['category'] = category;
    data['isPush'] = isPush;
    data['type'] = type;
    data['readTime'] = readTime;
    data['remark'] = remark;
    data['tenantId'] = tenantId;
    data['created'] = created;
    data['createdBy'] = createdBy;
    data['modified'] = modified;
    data['modifiedBy'] = modifiedBy;
    data['rowVersion'] = rowVersion;
    data['articleId'] = articleId;
    data['articleType'] = articleType;
    return data;
  }

  /// 显示标题
  static String getItemTitle(Notice model) {
    String title = '';
    if (model.cowCode == null) {
      if (model.batchNo == null) {
        title = '栋舍-${model.cowHouseName}';
      } else {
        title = '批次号-${model.batchNo}';
      }
    } else {
      title = '耳号-${model.cowCode}';
    }
    return title;
  }

  // 101：业务通知；102：系统通知；201：未发情；202：发情未配；203：未孕检；204：未产犊；205：未淘汰；401：待查情；402：待配种；403：待孕检；404：待产犊；405：待断奶；406：待淘汰；407：待销售；408：待防疫；409：待保健；901：环境异常；902：设备故障；903：行为异常
  static String getEventNameByCode(int code) {
    switch (code) {
      case 101:
        return '业务通知';
      case 102:
        return '系统通知';
      case 201:
        return '未发情';
      case 202:
        return '发情未配';
      case 203:
        return '未孕检';
      case 204:
        return '未产犊';
      case 205:
        return '未淘汰';
      case 401:
        return '待查情';
      case 402:
        return '待配种';
      case 403:
        return '待孕检';
      case 404:
        return '待产犊';
      case 405:
        return '待断奶';
      case 406:
        return '待淘汰';
      case 407:
        return '待销售';
      case 408:
        return '待防疫';
      case 409:
        return '待保健';
      case 901:
        return '环境异常';
      case 902:
        return '设备故障';
      case 903:
        return '行为异常';
      //410：查返情；411：待补饲；412：待换料
      case 410:
        return '查返情';
      case 411:
        return '待补饲';
      case 412:
        return '待换料';
      //
      case 210:
        return '生产指南';
      default:
        return Constant.placeholder;
    }
  }
}
