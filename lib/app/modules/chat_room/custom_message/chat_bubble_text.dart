import 'package:flutter/material.dart';

import '../../../../generated/assets.dart';

class ChatBubbleText extends StatelessWidget {
  final String avatarUrl;
  final String nickname;
  final String content;
  final bool isSelf;
  final Color bubbleColor;
  final Color textColor;
  final String defaultAvatarAsset; // 本地默认头像资源路径

  const ChatBubbleText({
    super.key,
    required this.avatarUrl,
    required this.nickname,
    required this.content,
    required this.isSelf,
    this.bubbleColor = const Color(0xFFE0E0E0),
    this.textColor = Colors.black87,
    this.defaultAvatarAsset = Assets.imagesAvatar,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(
      radius: 18,
      backgroundColor: Colors.grey.shade200,
      child: ClipOval(
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
    );

    final messageContent = Column(
      crossAxisAlignment: isSelf ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Text(nickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          decoration: BoxDecoration(color: bubbleColor, borderRadius: BorderRadius.circular(8)),
          child: Text(content, style: TextStyle(fontSize: 14, color: textColor)),
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
