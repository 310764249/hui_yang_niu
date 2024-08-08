class PageInfo {
  PageInfo({
    required this.itemsCount, //总数
    required this.pageCount,
    required this.pageIndex, //从 1 开始
    required this.pageSize,
    required this.list,
  });
  late final int itemsCount;
  late final int pageCount;
  late final int pageIndex;
  late final int pageSize;
  late final List<dynamic> list;

  PageInfo.fromJson(Map<String, dynamic> json) {
    itemsCount = json['itemsCount'];
    pageCount = json['pageCount'];
    pageIndex = json['pageIndex'];
    pageSize = json['pageSize'];
    list = json['list'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['itemsCount'] = itemsCount;
    data['pageCount'] = pageCount;
    data['pageIndex'] = pageIndex;
    data['pageSize'] = pageSize;
    data['list'] = list;
    return data;
  }
}
