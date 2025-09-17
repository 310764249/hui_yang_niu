class Tools {
  Tools._();

  static String formatNumber(String input) {
    if (input.isEmpty) return "0";

    // 尝试解析成 double
    final number = double.tryParse(input);
    if (number == null) return input; // 无法解析就原样返回

    // 保留最多两位小数，四舍五入
    return number.toStringAsFixed(number.truncateToDouble() == number ? 0 : 2);
  }
}
