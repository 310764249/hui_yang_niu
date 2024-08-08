import 'package:get/get.dart';

///
/// RxString类的扩展类
/// **注意是[空类型RxString?]对象的扩展类**
///
extension ExRxString on RxString? {
  /// String对象为null时返回空字符串
  RxString orEmpty() {
    return this ?? RxString('');
  }

  /// 可空类型的[null && 空字符串]的判断
  bool isRxStringNotBlank() {
    return orEmpty().trim().isNotEmpty;
  }
}
