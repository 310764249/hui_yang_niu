import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';

class CustomRefresh {
  /// 自定义 header
  static Header refreshHeader() {
    return const ClassicHeader(
      hitOver: true,
      safeArea: false,
      processedDuration: Duration.zero, //结束后的动画时间
      showMessage: false, //是否显示描述文字 ‘上次更新时间’
      showText: true, //是否显示下面的文字
      // 下面是一些文本配置
      processingText: "正在刷新...",
      readyText: "正在刷新...",
      armedText: "释放以刷新",
      dragText: "下拉刷新",
      processedText: "刷新成功",
      failedText: "刷新失败",
      // textStyle: TextStyle(color: Colors.black, fontSize: 14),
    );
  }

  /// 自定义 footer
  static Footer refreshFooter() {
    return const ClassicFooter(
      processedDuration: Duration.zero, //结束后的动画时间
      showMessage: false, //是否显示描述文字 ‘上次更新时间’
      showText: true, //是否显示下面的文字
      // 下面是一些文本配置
      processingText: "加载中...",
      processedText: "加载成功",
      readyText: "加载中...",
      armedText: "释放以加载更多",
      dragText: "上拉加载",
      failedText: "加载失败",
      noMoreText: "没有更多内容",
    );
  }
}
