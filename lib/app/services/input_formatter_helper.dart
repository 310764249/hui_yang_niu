import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class InputFormattersHelper {
  /// 根据键盘类型，限制输入内容
  /// @param type 键盘类型
  /// @return 输入限制
  static TextInputFormatter getFormatterWith(TextInputType? type) {
    type ??= TextInputType.text;
    if (type == TextInputType.number) {
      return FilteringTextInputFormatter.digitsOnly;
    } else if (type == const TextInputType.numberWithOptions(decimal: true)) {
      // return FilteringTextInputFormatter.allow(RegExp(r'[0-9]'));
      return UsNumberTextInputFormatter();
    } else {
      return FilteringTextInputFormatter.singleLineFormatter;
    }
  }
}

//处理小数点
class UsNumberTextInputFormatter extends TextInputFormatter {
  static const defaultDouble = 0.01;
  static double strToFloat(String str, [double defaultValue = defaultDouble]) {
    try {
      return double.parse(str);
    } catch (e) {
      return defaultValue;
    }
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String value = newValue.text;
    int selectionIndex = newValue.selection.end;
    if (value == ".") {
      value = "0.";
      selectionIndex++;
    } else if (value != "" &&
        value != defaultDouble.toString() &&
        strToFloat(value, defaultDouble) == defaultDouble) {
      value = oldValue.text;
      selectionIndex = oldValue.selection.end;
    }
    return new TextEditingValue(
      text: value,
      selection: new TextSelection.collapsed(offset: selectionIndex),
    );
  }
}
