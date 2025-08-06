import 'package:em_chat_uikit/chat_uikit.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:intellectual_breed/app/modules/chat_room/chat_room_utils.dart';

import '../../models/user_resource.dart';
import '../../services/colors.dart';
import '../../services/constant.dart';
import '../../services/storage.dart';
import 'app_lifecycle_observer.dart';
import 'chat_input_bar.dart';
import 'custom_message/chat_bubble_text.dart';
import 'custom_message/chat_image_message.dart';

class ChatRoomContainPage extends StatefulWidget {
  const ChatRoomContainPage({super.key});

  @override
  State<ChatRoomContainPage> createState() => _ChatRoomContainPageState();
}

class _ChatRoomContainPageState extends State<ChatRoomContainPage>
    with RoomObserver, ChatUIKitThemeMixin {
  RoomInputBarController inputBarController = RoomInputBarController();
  late AppLifecycleObserver _lifecycleObserver;
  // 发送礼物列表 使用
  List<ChatroomGiftPageController> controllers = [];

  String get roomId => ChatRoomUtils.publicRoomId;
  bool isOwner = false;

  @override
  void initState() {
    super.initState();
    ChatUIKit.instance.addObserver(this);
    theme.setColor(ChatUIKitColor.light());
    setup();
    _lifecycleObserver = AppLifecycleObserver(
      onResumed: () {
        setup();
      },
    )..start();
  }

  @override
  void dispose() {
    _lifecycleObserver.stop();
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  void setup() async {
    // 先获取自己的信息，之后再加入聊天室
    await setupMyInfo();
    joinChatRoom();
  }

  // 加入聊天室
  void joinChatRoom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ChatUIKit.instance
          .joinChatRoom(roomId: roomId)
          .then((_) {
            debugPrint('join chat room');
          })
          .catchError((e) {
            debugPrint('join chat room error: $e');
          });
    });
  }

  // 设置自己在聊天室中的信息
  Future<void> setupMyInfo() async {
    var res = await Storage.getData(Constant.userResData);
    if (res != null) {
      UserResource resourceModel = UserResource.fromJson(res);
      ChatUIKitProfile profile = ChatRoomUserInfo.createUserProfile(
        userId: ChatUIKit.instance.currentUserId!,
        nickname: resourceModel.nickName,
        avatarUrl: resourceModel.avatarUrl,
      );
      ChatUIKitProvider.instance.addProfiles([profile], roomId);
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Column(
      children: [
        Expanded(
          child: ChatRoomMessagesWidget(
            roomId: roomId,
            itemBuilder: (ctx, msg, user) {
              debugPrint('msg: $msg');
              Map<String, dynamic>? attributes = msg.attributes;
              String? nickname = attributes?['chatroom_uikit_userInfo']?['nickname'];
              String avatarURL = attributes?['chatroom_uikit_userInfo']?['avatarURL'] ?? '';

              bool isSelf = msg.direction == MessageDirection.SEND;
              if (msg.body.type == MessageType.TXT) {
                return ChatBubbleText(
                  avatarUrl: '${Constant.uploadFileUrl}$avatarURL',
                  nickname: nickname ?? '游客',
                  content: msg.textContent,
                  isSelf: isSelf,
                );
              } else if (msg.body.type == MessageType.IMAGE) {
                EMImageMessageBody body = msg.body as EMImageMessageBody;
                return ChatImageMessage(
                  avatarUrl: '${Constant.uploadFileUrl}$avatarURL',
                  nickname: nickname ?? '游客',
                  imageUrl: body.remotePath ?? '',
                  isSelf: isSelf,
                );
              }
              return const SizedBox();
            },
          ),
        ),
        ChatInputBar(
          onSendText: (msg) {
            if (msg.trim().isEmpty) {
              return;
            }
            ChatUIKit.instance.sendMessage(message: ChatRoomMessage.roomMessage(roomId, msg));
          },
          onSendImage: () async {
            List<Media> medias = await ImagePickers.pickerPaths(
              galleryMode: GalleryMode.image,
              selectCount: 1,
              showGif: false,
              showCamera: true,
              uiConfig: UIConfig(uiThemeColor: SaienteColors.search_color),
            );
            if (medias.isNotEmpty && medias.first.path != null) {
              EMMessage message = Message.createImageSendMessage(
                targetId: roomId,
                filePath: medias.first.path!,
                chatType: ChatType.ChatRoom,
              );
              message.addUserInfo(roomId);
              await ChatUIKit.instance.sendMessage(message: message);
            }
          },
        ),
      ],
    );

    content = Scaffold(
      appBar: AppBar(title: const Text('智能问答'), centerTitle: true),
      body: SafeArea(child: content),
    );

    content = PopScope(
      onPopInvokedWithResult: (didPop, result) async {
        ChatUIKit.instance
            .leaveChatRoom(roomId)
            .then((_) {
              debugPrint('leave chat room');
            })
            .catchError((e) {
              debugPrint('leave chat room error: $e');
            });
      },
      child: content,
    );

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: content,
    );
  }
}
