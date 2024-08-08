import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/pickers.dart';
import 'package:flutter_pickers/style/picker_style.dart';
import 'package:flutter_pickers/time_picker/model/date_mode.dart';
import 'package:flutter_pickers/time_picker/model/pduration.dart';
import 'package:get/get.dart';

import '../services/colors.dart';
import '../services/screenAdapter.dart';

class Picker {
  /// 单列 picker
  /// @param context 上下文
  /// @param list 备选数据
  /// @param title 中间标题，可选 默认为空
  /// @param selectData 选中数据 可选
  /// @param onConfirm 确认按钮回调 可选
  /// @param onCancel 取消按钮回调 可选
  static void showSinglePicker(BuildContext context, List list,
      {String title = '',
      dynamic selectData,
      Function(bool isCancel)? onCancel,
      Function(dynamic data, int position)? onConfirm}) {
    Pickers.showSinglePicker(context,
        data: list,
        selectData: selectData,
        pickerStyle: _getCustomStyle(title),
        onConfirm: onConfirm,
        onCancel: onCancel);
  }

  /// 时间单列 picker
  /// @param context 上下文
  /// @param title 中间标题，可选 默认为空
  /// @param onConfirm 确认按钮回调 可选
  /// @param onCancel 取消按钮回调 可选
  static void showDatePicker(BuildContext context,
      {String title = '',
      String? selectDate,
      DateMode? mode = DateMode.YMD,
      bool isMaxDate = true,
      Function(bool isCancel)? onCancel,
      Function(PDuration date)? onConfirm}) {
    Pickers.showDatePicker(context,
        mode: mode!,
        selectDate: selectDate?.isBlank ?? true
            ? PDuration.now()
            : PDuration.parse(DateTime.parse(selectDate ?? '')),
        pickerStyle: _getCustomStyle(title),
        maxDate: isMaxDate ? PDuration.now() : null,
        onConfirm: onConfirm,
        onCancel: onCancel);
  }

  /// 自定义 Picker 样式
  static PickerStyle _getCustomStyle(String title) {
    //选中背景色
    Widget itemOverlay = CupertinoPickerDefaultSelectionOverlay(
        background: const Color.fromARGB(255, 113, 115, 127).withOpacity(0.2));

    Widget titleText = Text(title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: SaienteColors.black28,
          fontSize: ScreenAdapter.fontSize(16),
        ));

    Widget commitButton = SizedBox(
      height: ScreenAdapter.height(54),
      width: ScreenAdapter.width(60),
      child: Center(
        child: Text('确认',
            style: TextStyle(
              color: SaienteColors.blue275CF3,
              fontSize: ScreenAdapter.fontSize(16),
            )),
      ),
    );
    Widget cancelButton = SizedBox(
      height: ScreenAdapter.height(54),
      width: ScreenAdapter.width(60),
      child: Center(
        child: Text('取消',
            style: TextStyle(
              color: SaienteColors.blue275CF3,
              fontSize: ScreenAdapter.fontSize(16),
            )),
      ),
    );

    return PickerStyle(
      backgroundColor: Colors.white,
      title: titleText,
      textSize: ScreenAdapter.fontSize(18), // item font size
      cancelButton: cancelButton,
      commitButton: commitButton,
      itemOverlay: itemOverlay,
    );
  }
}
