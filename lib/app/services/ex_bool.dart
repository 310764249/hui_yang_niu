///
/// 可空bool?类的扩展类
/// **注意是[空类型bool?]对象的扩展类**
///
extension ExBool on bool? {
  /// bool对象为null时返回false
  bool orFalse() {
    return this ?? false;
  }
}
