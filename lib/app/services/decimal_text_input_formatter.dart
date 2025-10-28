import 'package:flutter/services.dart';

/// 只允许数字和小数点，并控制小数点后位数的 InputFormatter
/// 使用示例：
/*
TextField(
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [
    // 先限制字符集为数字和点
    FilteringTextInputFormatter.allow(RegExp(r'[0-9.]')),
    // 再限制小数位数为 2
    DecimalTextInputFormatter(decimalRange: 2),
  ],
)
*/
class DecimalTextInputFormatter extends TextInputFormatter {
  final int decimalRange;

  DecimalTextInputFormatter({required this.decimalRange}) : assert(decimalRange >= 0);

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final String newText = newValue.text;

    // 允许删除（清空）
    if (newText.isEmpty) {
      return newValue;
    }

    // 如果是单独输入 '.'，自动转换为 '0.'
    if (newText == '.') {
      final resultText = '0.';
      return TextEditingValue(
        text: resultText,
        selection: TextSelection.collapsed(offset: resultText.length),
      );
    }

    // 只允许数字和点（前面配合 FilteringTextInputFormatter 使用，这里做一次兜底）
    if (!RegExp(r'^[0-9.]*$').hasMatch(newText)) {
      return oldValue;
    }

    // 不允许多个小数点
    final dotCount = '.'.allMatches(newText).length;
    if (dotCount > 1) {
      return oldValue;
    }

    // 如果包含小数点，检查小数位数
    if (newText.contains('.')) {
      final parts = newText.split('.');
      // split 可能产生多个部分，但上面已保证 dotCount<=1
      final fraction = parts.length > 1 ? parts[1] : '';

      // 小数位长度超过限制，拒绝此次输入
      if (fraction.length > decimalRange) {
        return oldValue;
      }
    }

    // 通过所有校验，返回 newValue（但要尽量保留光标位置）
    // newValue 中的 selection 一般已正确，但如果你对 newText 做了修改（例如把 "." -> "0."），要调整 selection。
    // 上面我们已经处理了 "." 的特殊情况并直接返回了新的 TextEditingValue。
    return newValue;
  }
}
