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
import 'custom_room_messages_widget.dart';

class ChatRoomContainPage extends StatefulWidget {
  const ChatRoomContainPage({super.key});

  @override
  State<ChatRoomContainPage> createState() => _ChatRoomContainPageState();
}

class _ChatRoomContainPageState extends State<ChatRoomContainPage>
    with RoomObserver, ChatUIKitThemeMixin {
  RoomInputBarController inputBarController = RoomInputBarController();
  late AppLifecycleObserver _lifecycleObserver;

  ValueNotifier<int> messageCount = ValueNotifier(0);

  // 发送礼物列表 使用
  List<ChatroomGiftPageController> controllers = [];

  String get roomId => ChatRoomUtils.publicRoomId;
  bool isOwner = false;
  List<Message> historyMessages = [];

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
            memberCount();
            getHistoryMessage();
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

  //聊天室人数
  void memberCount() async {
    EMChatRoom? room = await EMClient.getInstance.chatRoomManager.getChatRoomWithId(roomId);
    debugPrint("聊天室人数： ${room?.memberCount}");
    messageCount.value = room?.memberCount ?? 0;
    EMClient.getInstance.chatRoomManager.addEventHandler(
      'UNIQUE_HANDLER_ID',
      ChatRoomEventHandler(
        onMemberJoinedFromChatRoom: (String roomId, String participant, String? ext) async {
          EMChatRoom? room = await EMClient.getInstance.chatRoomManager.getChatRoomWithId(roomId);
          debugPrint("聊天室人数： ${room?.memberCount}");
          messageCount.value = room?.memberCount ?? 0;
        },
        onMemberExitedFromChatRoom: (roomId, roomName, participant) async {
          EMChatRoom? room = await EMClient.getInstance.chatRoomManager.getChatRoomWithId(roomId);
          debugPrint("聊天室人数： ${room?.memberCount}");
          messageCount.value = room?.memberCount ?? 0;
        },
      ),
    );
  }

  //获取历史消息
  void getHistoryMessage() async {
    FetchMessageOptions options = const FetchMessageOptions(
      msgTypes: [MessageType.TXT, MessageType.IMAGE],
      needSave: false,
    );
    EMCursorResult<EMMessage> result = await EMClient.getInstance.chatManager
        .fetchHistoryMessagesByOption(
          roomId,
          EMConversationType.ChatRoom,
          options: options,
          pageSize: 20,
        );
    setState(() {
      historyMessages = result.data;
    });
  }

  @override
  void dispose() {
    _lifecycleObserver.stop();
    ChatUIKit.instance.removeObserver(this);

    EMClient.getInstance.chatRoomManager.removeEventHandler('UNIQUE_HANDLER_ID');
    super.dispose();
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = Column(
      children: [
        Expanded(
          child: CustomChatRoomMessagesWidget(
            key: ValueKey(historyMessages),
            roomId: roomId,
            messages: historyMessages,
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
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: messageCount,
          builder: (context, value, child) {
            return Text('哞哞达人($value人)');
          },
        ),
        centerTitle: true,
      ),
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
