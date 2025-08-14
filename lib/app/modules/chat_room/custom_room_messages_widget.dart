import 'package:chat_uikit_theme/chat_uikit_theme.dart';
import 'package:em_chat_uikit/chat_sdk_service/chat_sdk_service.dart';
import 'package:em_chat_uikit/chat_uikit/chat_uikit.dart';
import 'package:em_chat_uikit/chat_uikit_provider/chat_uikit_provider.dart';
import 'package:em_chat_uikit/chatroom_uikit/chatroom_uikit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class CustomChatRoomMessagesWidget extends StatefulWidget {
  const CustomChatRoomMessagesWidget({
    required this.roomId,
    this.onTap,
    this.onLongPress,
    this.itemBuilder,
    this.showTime = true,
    this.showIdentify = true,
    this.showAvatar = true,
    this.showNickname = true,
    super.key,
    required this.messages,
  });

  final String roomId;
  final bool showTime;
  final bool showIdentify;
  final bool showAvatar;
  final bool showNickname;
  final List<Message> messages;

  final Widget? Function(BuildContext context, Message msg, ChatUIKitProfile? user)? itemBuilder;
  final void Function(BuildContext context, Message msg, ChatUIKitProfile? user)? onTap;
  final void Function(BuildContext context, Message msg, ChatUIKitProfile? user)? onLongPress;

  @override
  State<CustomChatRoomMessagesWidget> createState() => _CustomChatRoomMessagesWidgetState();
}

class _CustomChatRoomMessagesWidgetState extends State<CustomChatRoomMessagesWidget>
    with ChatObserver, MessageObserver, ChatUIKitProviderObserver, ChatUIKitThemeMixin {
  final ScrollController scrollController = ScrollController();
  List<Message> messages = [];

  final Map<String, ChatUIKitProfile> profileCache = {};
  int unreadCount = 0;
  ValueNotifier<bool> canMoveToBottom = ValueNotifier(true);

  @override
  void initState() {
    super.initState();
    ChatUIKitProvider.instance.addObserver(this);
    ChatUIKit.instance.addObserver(this);

    messages.addAll(widget.messages);
  }

  @override
  void dispose() {
    ChatUIKitProvider.instance.removeObserver(this);
    ChatUIKit.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void onProfilesUpdate(Map<String, ChatUIKitProfile> map, [String? belongId]) {
    if (belongId == widget.roomId) {
      for (var entry in map.entries) {
        profileCache[entry.key] = entry.value;
      }
      setState(() {});
    }
  }

  @override
  Widget themeBuilder(BuildContext context, ChatUIKitTheme theme) {
    Widget content = ListView.separated(
      reverse: true, // 反转列表，从底部开始渲染
      padding: EdgeInsets.zero,
      controller: scrollController,
      itemCount: messages.length,
      itemBuilder: (context, index) {
        // 倒序取消息
        final msg = messages[messages.length - 1 - index];
        final profile = profileCache[msg.from!];
        Widget? listItem =
            widget.itemBuilder?.call(context, msg, profile) ??
            RoomMessageListItemManager.getMessageListItem(
              msg,
              profile,
              showTime: widget.showTime,
              showIdentify: widget.showIdentify,
              showAvatar: widget.showAvatar,
              showNickname: widget.showNickname,
            );

        return InkWell(
          key: ValueKey(msg.msgId),
          onLongPress:
              widget.onLongPress != null
                  ? () => widget.onLongPress?.call(context, msg, profile)
                  : null,
          onTap: widget.onTap != null ? () => widget.onTap?.call(context, msg, profile) : null,
          child: listItem,
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 4),
    );

    // 监听滚动，更新未读消息提示
    content = NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is UserScrollNotification &&
            notification.direction == ScrollDirection.reverse) {
          canMoveToBottom.value = false;
        } else if (notification is ScrollEndNotification) {
          canMoveToBottom.value =
              scrollController.position.pixels <= scrollController.position.minScrollExtent;
          if (canMoveToBottom.value) {
            unreadCount = 0;
          }
        }
        return false;
      },
      child: content,
    );

    content = Stack(children: [content, Positioned(bottom: 0, child: unreadCountWidget(theme))]);

    return content;
  }

  Widget unreadCountWidget(ChatUIKitTheme theme) {
    return InkWell(
      onTap: () {
        unreadCount = 0;
        moveToBottom();
      },
      child: ValueListenableBuilder(
        valueListenable: canMoveToBottom,
        builder: (context, value, child) {
          if (value || unreadCount == 0) return const SizedBox.shrink();
          return Container(
            constraints: const BoxConstraints(maxHeight: 26, maxWidth: 181),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: (theme.color.isDark ? theme.color.neutralColor1 : theme.color.neutralColor98),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 16,
                  color:
                      (theme.color.isDark ? theme.color.primaryColor6 : theme.color.primaryColor5),
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: Text(
                    unreadCount < 99 ? '$unreadCount 条新消息' : '99+ 条新消息',
                    style: TextStyle(
                      height: 1.2,
                      fontWeight: theme.font.labelMedium.fontWeight,
                      fontSize: theme.font.labelMedium.fontSize,
                      color:
                          (theme.color.isDark
                              ? theme.color.primaryColor6
                              : theme.color.primaryColor5),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void onMessagesReceived(messages) {
    List<Message> localMsgs = List.from(messages)
      ..removeWhere((element) => element.conversationId != widget.roomId || element.isBroadcast);

    for (var msg in localMsgs) {
      final profile = msg.getUserInfo();
      if (profile != null && profile.type == ChatUIKitProfileType.contact) {
        profileCache[profile.id] = profile;
      }
    }

    setState(() {
      this.messages.addAll(localMsgs);
      if (canMoveToBottom.value) {
        moveToBottom();
      } else {
        unreadCount += localMsgs.length;
      }
    });
  }

  @override
  void onMessagesRecalledInfo(List<RecallMessageInfo> infos, List<Message> replaces) {
    List<String> needDeleteMsgIds = infos.map((info) => info.recallMessageId).toList();

    messages.removeWhere((element) => needDeleteMsgIds.contains(element.msgId));
    setState(() {});
  }

  @override
  void onMessageSendSuccess(String msgId, Message msg) {
    if (msg.bodyType == MessageType.CMD) return;

    if (msg.conversationId == widget.roomId && !msg.isBroadcast) {
      final profile = msg.getUserInfo();
      if (profile != null && profile.type == ChatUIKitProfileType.contact) {
        profileCache[profile.id] = profile;
      }
      setState(() {
        messages.add(msg);
        canMoveToBottom.value = true;
        unreadCount = 0;
        moveToBottom();
      });
    }
  }

  void moveToBottom() {
    if (!scrollController.hasClients) return;
    scrollController.animateTo(
      0, // 反转列表顶部即底部
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }
}
