import 'package:flutter/material.dart';
import 'package:markdown_widget/markdown_widget.dart';

class ChatBubble extends StatelessWidget {
  /// 显示内容（支持 Markdown）
  final String content;

  /// true = 用户提问（右边，蓝底白字）
  /// false = 系统回答（左边，白底黑字）
  final bool isSender;

  const ChatBubble({super.key, required this.content, required this.isSender});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      child: Row(
        mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSender ? Colors.blue : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isSender ? 16 : 0),
                  bottomRight: Radius.circular(isSender ? 0 : 16),
                ),
                border: isSender ? null : Border.all(color: Colors.grey.shade300),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75, // 自动收缩
              ),
              child: DefaultTextStyle(
                style: TextStyle(color: isSender ? Colors.white : Colors.black87, fontSize: 12),
                child: MarkdownBlock(
                  data: content,
                  config: MarkdownConfig(
                    configs: const [
                      PConfig(textStyle: TextStyle(fontSize: 15)),
                      H1Config(style: TextStyle(fontSize: 16)),
                      H2Config(style: TextStyle(fontSize: 16)),
                      H3Config(style: TextStyle(fontSize: 16)),
                      H4Config(style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
