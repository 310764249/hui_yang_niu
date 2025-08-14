import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intellectual_breed/app/modules/chat_room/record_panel.dart';

class ChatInputWidget extends StatefulWidget {
  final Function(String text) onSendText;
  final Function(File image) onSendImage;
  final Function(File video) onSendVideo;
  final Function(File video, int duration) onSendVoice;
  final TextEditingController controller;

  const ChatInputWidget({
    super.key,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendVideo,
    required this.onSendVoice,
    required this.controller,
  });

  @override
  State<ChatInputWidget> createState() => _ChatInputWidgetState();
}

class _ChatInputWidgetState extends State<ChatInputWidget> {
  TextEditingController get _controller => widget.controller;
  final FocusNode _focusNode = FocusNode();

  bool _showEmoji = false;
  bool _showMore = false;
  bool _showVoice = false;

  bool _recording = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        setState(() {
          _showEmoji = false;
          _showMore = false;
          _showVoice = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _toggleEmoji() {
    hideAllPanel();
    setState(() {
      _showEmoji = !_showEmoji;
      _showMore = false;
      if (_showEmoji) {
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  void _onEmojiSelected(Emoji emoji) {
    _controller
      ..text += emoji.emoji
      ..selection = TextSelection.fromPosition(TextPosition(offset: _controller.text.length));
  }

  void _toggleMore() {
    hideAllPanel();
    setState(() {
      _showMore = !_showMore;
      _showEmoji = false;
      if (_showMore) {
        _focusNode.unfocus();
      } else {
        _focusNode.requestFocus();
      }
    });
  }

  void _sendText() {
    String text = _controller.text.trim();
    if (text.isNotEmpty) {
      widget.onSendText(text);
      _controller.clear();
    }
  }

  Future<void> _pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) widget.onSendImage(File(picked.path));
  }

  Future<void> _takePhoto() async {
    final picked = await _picker.pickImage(source: ImageSource.camera);
    if (picked != null) widget.onSendImage(File(picked.path));
  }

  Future<void> _pickVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.gallery);
    if (picked != null) widget.onSendVideo(File(picked.path));
  }

  Future<void> _takeVideo() async {
    final picked = await _picker.pickVideo(source: ImageSource.camera);
    if (picked != null) widget.onSendVideo(File(picked.path));
  }

  Widget _buildEmojiPicker() {
    return SizedBox(
      height: 250,
      child: EmojiPicker(
        onEmojiSelected: (category, emoji) => _onEmojiSelected(emoji),
        config: const Config(height: 250, locale: Locale('zh')),
      ),
    );
  }

  Widget _buildMorePanel() {
    return SizedBox(
      height: 150,
      child: GridView(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          childAspectRatio: 1,
        ),
        children: [
          _moreItem(Icons.image, '图片', () {
            _pickImage();
          }),
          _moreItem(Icons.image, '视频', () {
            _pickVideo();
          }),
          _moreItem(Icons.videocam, '拍摄', () {
            showMediaPickerBottomSheet(
              context: context,
              onPickPhoto: _takePhoto,
              onPickVideo: _takeVideo,
            );
          }),
        ],
      ),
    );
  }

  Widget _moreItem(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.withAlpha(20),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 28),
          ),

          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  /// 显示底部选择弹窗
  Future<void> showMediaPickerBottomSheet({
    required BuildContext context,
    required VoidCallback onPickPhoto,
    required VoidCallback onPickVideo,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return SafeArea(
          child: Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildActionButton(
                  text: '照片',
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickPhoto();
                  },
                ),
                const Divider(height: 1),
                _buildActionButton(
                  text: '视频',
                  onTap: () {
                    Navigator.pop(ctx);
                    onPickVideo();
                  },
                ),
                const Divider(height: 1),
                _buildActionButton(
                  text: '取消',
                  textColor: Colors.red,
                  onTap: () {
                    Navigator.pop(ctx);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onTap,
    Color textColor = Colors.black87,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(
          text,
          style: TextStyle(fontSize: 16, color: textColor, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!_recording)
          Row(
            children: [
              IconButton(
                icon:
                    _showVoice
                        ? const Icon(Icons.keyboard_alt_outlined)
                        : const Icon(Icons.keyboard_voice),
                onPressed: _onTapVoice,
              ),
              Expanded(
                child: Container(
                  height: 45,
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    decoration: const InputDecoration(
                      hintText: '说点什么...',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                      isDense: true,
                    ),
                  ),
                ),
              ),
              IconButton(icon: const Icon(Icons.emoji_emotions_outlined), onPressed: _toggleEmoji),
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return value.text.isEmpty
                      ? IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: _toggleMore,
                      )
                      : IconButton(icon: const Icon(Icons.send), onPressed: _sendText);
                },
              ),
            ],
          ),
        if (_showEmoji) _buildEmojiPicker(),
        if (_showMore) _buildMorePanel(),
        if (_showVoice) _buildVoicePanel(),
      ],
    );
  }

  void _onTapVoice() {
    _focusNode.unfocus();
    setState(() {
      hideAllPanel();
      _showVoice = !_showVoice;
    });
  }

  void hideAllPanel() {
    _showEmoji = false;
    _showMore = false;
    _showVoice = false;
  }

  _buildVoicePanel() {
    return SizedBox(
      height: 200,
      child: RecordPanel(
        onPressedDown: () {
          setState(() {
            _recording = true;
          });
        },
        onEnd: () {
          setState(() {
            _recording = false;
          });
        },
        onCancel: () {
          setState(() {
            _recording = false;
          });
        },
        onSuccess: (File value, int duration) {
          widget.onSendVoice(value, duration);
        },
      ),
    );
  }
}

class EmojiTextParser {
  /// 检查字符串是否包含 emoji
  static bool containsEmoji(String text) {
    final regex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    return regex.hasMatch(text);
  }

  /// 提取所有 emoji
  static List<String> extractEmojis(String text) {
    final regex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    return regex.allMatches(text).map((m) => m.group(0) ?? '').toList();
  }

  /// 移除所有 emoji
  static String removeEmojis(String text) {
    final regex = RegExp(
      r'(\u00a9|\u00ae|[\u2000-\u3300]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff])',
    );
    return text.replaceAll(regex, '');
  }
}
