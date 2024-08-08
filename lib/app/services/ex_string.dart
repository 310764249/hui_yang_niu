///
/// String?类的扩展类
/// **注意是[空类型String?]对象的扩展类**
///
extension ExString on String? {
  /// String对象为null时返回空字符串
  String orEmpty() {
    return this ?? '';
  }

  /// 可空类型的[null && 空字符串]的判断
  bool isNotBlank() {
    return orEmpty().trim().isNotEmpty;
  }

  /// 可空类型的[空字符串]的判断
  bool isBlankEx() {
    return orEmpty().trim().isEmpty;
  }
}

extension ExNormalString on String {
  /// 传入日期是否在当前日期之前 时间格式 '2023-08-10';
  bool isBefore(String? date) {
    if (date == null) {
      return false;
    }
    // 将日期字符串解析为DateTime对象
    DateTime date1 = DateTime.parse(this);
    DateTime date2 = DateTime.parse(date);

    return date1.isBefore(date2);
  }

  /// 传入日期是否在当前日期之前或相等 时间格式 '2023-08-10';
  bool isBeforeOrAtSame(String? date) {
    if (date == null) {
      return false;
    }
    // 将日期字符串解析为DateTime对象
    DateTime date1 = DateTime.parse(this);
    DateTime date2 = DateTime.parse(date);

    return date1.isBefore(date2) || date1.isAtSameMomentAs(date2);
  }

  /// 传入日期是否在当前日期之后 时间格式 '2023-08-10';
  bool isAfter(String? date) {
    if (date == null) {
      return true;
    }
    // 将日期字符串解析为DateTime对象
    DateTime date1 = DateTime.parse(this);
    DateTime date2 = DateTime.parse(date);

    return date1.isAfter(date2);
  }

  /// 传入日期是否在当前日期之后或相等 时间格式 '2023-08-10';
  bool isAfterAtSame(String? date) {
    if (date == null) {
      return true;
    }
    // 将日期字符串解析为DateTime对象
    DateTime date1 = DateTime.parse(this);
    DateTime date2 = DateTime.parse(date);

    return date1.isAfter(date2) || date1.isAtSameMomentAs(date2);
  }

  /// 传入日期是否在当前日期相等 时间格式 '2023-08-10';
  bool isAtSame(String? date) {
    if (date == null) {
      return false;
    }
    // 将日期字符串解析为DateTime对象
    DateTime date1 = DateTime.parse(this);
    DateTime date2 = DateTime.parse(date);

    return date1.isAtSameMomentAs(date2);
  }
}
