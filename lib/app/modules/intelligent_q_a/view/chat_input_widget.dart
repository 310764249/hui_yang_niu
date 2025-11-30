import 'package:flutter/material.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String text) onSend; // 点击发送
  final Function()? onVoice; // 语音输入预留回调

  const ChatInputWidget({super.key, required this.onSend, this.onVoice});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          /// 输入框
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  /// 文本输入
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      minLines: 1,
                      maxLines: 4,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "请输入内容...",
                      ),
                    ),
                  ),

                  /// 语音按钮（预留）
                  // GestureDetector(
                  //   onTap: widget.onVoice,
                  //   child: const Padding(
                  //     padding: EdgeInsets.symmetric(horizontal: 4),
                  //     child: Icon(Icons.mic_none, size: 22),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 12),

          /// 发送按钮
          GestureDetector(
            onTap: _send,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Text("发送", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}
