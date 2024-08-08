import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../../services/colors.dart';
import '../../../../services/screenAdapter.dart';
import '../../../../widgets/page_wrapper.dart';
import '../controllers/message_detail_controller.dart';

///
/// 消息详情
///
class MessageDetailView extends GetView<MessageDetailController> {
  const MessageDetailView({Key? key}) : super(key: key);

  Widget _messageContent() {
    return CustomScrollView(
      physics:
          const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(12),
                  ScreenAdapter.height(12),
                  ScreenAdapter.width(12),
                  ScreenAdapter.height(20)),
              child: Column(children: [
                Text(
                  controller.title,
                  style: TextStyle(
                      color: SaienteColors.blackE5,
                      fontSize: ScreenAdapter.fontSize(18),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: ScreenAdapter.height(8)),
                Text(
                  controller.time.replaceFirst('T', ' '),
                  style: TextStyle(
                      color: SaienteColors.black80,
                      fontSize: ScreenAdapter.fontSize(13),
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: ScreenAdapter.height(12)),
                FractionallySizedBox(
                  widthFactor: 1,
                  child: Text(
                    controller.content,
                    style: TextStyle(
                        color: SaienteColors.blackB2,
                        fontSize: ScreenAdapter.fontSize(16),
                        fontWeight: FontWeight.w600),
                  ),
                ),
              ]),
            ),
          ]),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map arguments =
        Get.arguments ?? {'title': '', 'content': '', 'time': ''};
    String title = arguments['title'] ?? '';
    String content = arguments['content'] ?? '';
    String time = arguments['time'] ?? '';
    controller.setMessageContent(title, content, time);

    return Scaffold(
        appBar: AppBar(
          leading: WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop();
              return false;
            },
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          title: const Text('消息详情'),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.white,
        ),
        body: PageWrapper(
          child: _messageContent(),
        ));
  }
}
