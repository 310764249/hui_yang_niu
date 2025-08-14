import 'package:em_chat_uikit/chat_sdk_service/src/chat_sdk_define.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';

class ChatBubbleText extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String content;
  final bool isSelf;
  final Color bubbleColor;
  final Color textColor;
  final String defaultAvatarAsset;
  final Message msg;
  final Function(Message msg)? onLongPress;

  const ChatBubbleText({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.content,
    required this.isSelf,
    this.bubbleColor = const Color(0xFFE0E0E0),
    this.textColor = Colors.black87,
    this.defaultAvatarAsset = Assets.imagesAvatar,
    required this.msg,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
        child: GestureDetector(
          onLongPress: () => onLongPress?.call(msg),
          child: Image.network(
            avatarUrl,
            fit: BoxFit.cover,
            width: 36,
            height: 36,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(defaultAvatarAsset, fit: BoxFit.cover, width: 36, height: 36);
            },
          ),
        ),
      ),
    );

    List<InlineSpan> parseTextWithEmoji(String text) {
      final List<InlineSpan> spans = [];
      final reg = RegExp(r'@[^\s]+'); // 匹配 @ 开头直到空格
      int start = 0;

      for (final match in reg.allMatches(text)) {
        if (match.start > start) {
          final normalText = text.substring(start, match.start);
          spans.addAll(
            EmojiPickerUtils().setEmojiTextStyle(
              normalText,
              emojiStyle: TextStyle(fontSize: 14, color: textColor),
            ),
          );
        }

        final atText = text.substring(match.start, match.end);

        // 整段 @xxx 高亮，不调用 Emoji 工具
        spans.add(TextSpan(text: atText, style: const TextStyle(fontSize: 14, color: Colors.blue)));

        start = match.end;
      }

      if (start < text.length) {
        final remainingText = text.substring(start);
        spans.addAll(
          EmojiPickerUtils().setEmojiTextStyle(
            remainingText,
            emojiStyle: TextStyle(fontSize: 14, color: textColor),
          ),
        );
      }

      return spans;
    }

    final messageContent = Column(
      crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(nickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(8)),
          child: Text.rich(TextSpan(children: parseTextWithEmoji(content))),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        children:
            isSelf
                ? [Flexible(child: messageContent), const SizedBox(width: 8), avatar]
                : [avatar, const SizedBox(width: 8), Flexible(child: messageContent)],
      ),
    );
  }
}
