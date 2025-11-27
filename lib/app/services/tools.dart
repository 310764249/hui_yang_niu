import 'package:intl/intl.dart';

class Tools {
  Tools._();

  static String formatNumber(String input) {
    if (input.isEmpty) return "0";

    final number = double.tryParse(input);
    if (number == null) return input; // 无法解析就原样返回

    // 先四舍五入保留两位
    final rounded = number.toStringAsFixed(2);

    // 转换成 double 去掉多余的 0
    return double.parse(rounded).toString();
  }

  // String _checkStr(String v) {
  //   return v == null ? "" : v;
  // }
  /// 获取时分，例如 "16:43"
  static String formatTime(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      return DateFormat('HH:mm').format(dt);
    } catch (e) {
      return '';
    }
  }

  /// 获取日期显示
  /// 如果是今天，返回 "今天"，否则返回 "MM月dd日"
  static String formatDate(String dateTimeStr) {
    try {
      final dt = DateTime.parse(dateTimeStr);
      final now = DateTime.now();

      if (dt.year == now.year && dt.month == now.month && dt.day == now.day) {
        return '今天';
      } else {
        return DateFormat('MM月dd日').format(dt);
      }
    } catch (e) {
      return '';
    }
  }
}
