import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/modules/intelligent_q_a/view/voice_record_button.dart';
import 'dart:io';
import 'dart:math' as math;
import '../../chat_room/record_panel.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String text) onSend; // 文本消息
  final Function(File file, int duration)? onSendVoice; // 语音消息

  const ChatInputWidget({super.key, required this.onSend, this.onSendVoice});

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  final TextEditingController _controller = TextEditingController();
  bool _showRecordPanel = false; // 是否显示语音面板

  void _sendText() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSend(text);
    _controller.clear();
  }

  void _startVoiceRecord() {
    setState(() => _showRecordPanel = !_showRecordPanel);
  }

  void _closeVoiceRecord() {
    setState(() => _showRecordPanel = false);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        /// 输入栏
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.white,
          child: Row(
            children: [
              /// 输入框
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Row(
                    children: [
                      _showRecordPanel
                          ? Expanded(
                            child: VoiceRecordButton(
                              onSuccess: (file, duration) {
                                widget.onSendVoice?.call(file, duration);
                              },
                            ),
                          )
                          : Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: TextField(
                                controller: _controller,
                                minLines: 1,
                                maxLines: 4,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "请输入内容...",
                                  hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
                                ),
                              ),
                            ),
                          ),

                      // // 语音按钮
                      // if (!_showRecordPanel)
                      //   GestureDetector(
                      //     onTap: _startVoiceRecord,
                      //     child: const Padding(
                      //       padding: EdgeInsets.symmetric(horizontal: 4),
                      //       child: Icon(Icons.mic_none, size: 22),
                      //     ),
                      //   ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// 发送按钮
              GestureDetector(
                onTap: () {
                  if (_showRecordPanel) {
                    _closeVoiceRecord();
                  } else {
                    _sendText();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child:
                      _showRecordPanel
                          ? const Icon(Icons.keyboard, size: 22, color: Colors.white)
                          : const Text("发送", style: TextStyle(color: Colors.white, fontSize: 14)),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
