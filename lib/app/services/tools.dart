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
}
