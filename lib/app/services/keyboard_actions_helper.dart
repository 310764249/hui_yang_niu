import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

class KeyboardActionsHelper {
  // 显示键盘上面的按钮
  static KeyboardActionsItem getDefaultItem(FocusNode node) {
    return KeyboardActionsItem(
        focusNode: node,
        // displayDoneButton: true,
        toolbarButtons: [
          //button 1
          (node) {
            return GestureDetector(
              onTap: () => node.unfocus(),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: const Text(
                  "关闭键盘",
                  style: TextStyle(color: Colors.black),
                ),
              ),
            );
          },
        ]);
  }
}
