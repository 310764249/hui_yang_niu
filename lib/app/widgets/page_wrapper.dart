import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../services/colors.dart';

///
/// 页面包裹基类
///
class PageWrapper extends StatefulWidget {
  const PageWrapper({super.key, required this.child, this.config});

  // 页面内容
  final Widget child;
  // 键盘默认配置
  final KeyboardActionsConfig? config;

  @override
  State<PageWrapper> createState() => _PageWrapperState();
}

class _PageWrapperState extends State<PageWrapper> {
  KeyboardActionsConfig defaultConfig(BuildContext context) {
    return const KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
        color: SaienteColors.backGrey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: KeyboardActions(
              config: widget.config ?? defaultConfig(context),
              child: widget.child,
            ),
          ),
        ));
  }
}
