///
/// int类的扩展类
///
extension ExInt on int {
  /// 格式化月份和天, 当月份小于10时, 自动补0
  String addZero() {
    return this < 10 ? '0$this' : '$this';
  }
}
