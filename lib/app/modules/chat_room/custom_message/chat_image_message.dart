import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/modules/chat_room/image_preview_dialog.dart';

class ChatImageMessage extends StatelessWidget {
  final String imageUrl;
  final String avatarUrl;
  final String nickname;
  final bool isSelf;

  const ChatImageMessage({
    super.key,
    required this.imageUrl,
    required this.avatarUrl,
    required this.nickname,
    required this.isSelf,
  });

  @override
  Widget build(BuildContext context) {
    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: Image.network(
        avatarUrl,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder:
            (_, __, ___) => Image.asset('assets/images/default_avatar.png', width: 40, height: 40),
      ),
    );

    final imageBubble = GestureDetector(
      onTap: () {
        ImagePreviewDialog.show(context, imageUrl);
      },
      child: Container(
        constraints: const BoxConstraints(maxWidth: 180, maxHeight: 240),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey.shade200,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Hero(
            tag: imageUrl,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder:
                  (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    alignment: Alignment.center,
                    child: const Icon(Icons.broken_image, size: 40, color: Colors.grey),
                  ),
            ),
          ),
        ),
      ),
    );

    final nicknameWidget = Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(nickname, style: const TextStyle(fontSize: 12, color: Colors.grey)),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      child: Row(
        mainAxisAlignment: isSelf ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            isSelf
                ? [
                  // 内容在右边（自己）
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [nicknameWidget, imageBubble],
                  ),
                  const SizedBox(width: 8),
                  avatar,
                ]
                : [
                  avatar,
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [nicknameWidget, imageBubble],
                  ),
                ],
      ),
    );
  }
}
