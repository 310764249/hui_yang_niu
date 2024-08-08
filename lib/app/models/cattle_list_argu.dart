/// 普通牛只列表参数
class CattleListArgument {
  /// 是否单选，默认单选
  final bool single;

  /// 是否选择后点击选择返回数据
  final bool goBack;

  /// 选择后跳转的路由 例如 '/cattlelist'
  final String? routerStr;

  /// 公母的字典数组，传入后限制列表筛选条件
  final List? gmList;

  /// 限制生长阶段筛选
  final List? szjdList;

  /// 是否过滤无效的牛 淘汰 采精 发情 禁配  解禁 配种 孕检 产犊 断奶
  bool? isFilterInvalid;

  CattleListArgument({
    required this.goBack,
    required this.single,
    this.routerStr,
    this.gmList,
    this.szjdList,
    this.isFilterInvalid = false,
  });
}

/// 事件筛查牛只专用，与牛只列表无关！！！！！
class EventsCattleListArgument {
  /// 事件类型
  final int type;

  /// 例如 '待查情'
  final String title;

  /// 选择后跳转的路由 例如 '/cattlelist'
  final String routerStr;

  EventsCattleListArgument(
    this.type,
    this.title,
    this.routerStr,
  );
}
