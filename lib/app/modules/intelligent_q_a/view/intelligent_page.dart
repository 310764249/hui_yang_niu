import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';
import 'package:intellectual_breed/generated/assets.dart';

import '../../../services/screenAdapter.dart';
import '../../mine/controllers/mine_controller.dart';
import '../controllers/intelligent_controller.dart';
import 'chat_input_widget.dart';
import 'intelligent_history_page.dart';
import 'qa_chat_bubble_item.dart';

class IntelligentPage extends GetView<IntelligentController> {
  const IntelligentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              SaienteColors.blue4D91F5,
              SaienteColors.backGrey,
              SaienteColors.backGrey,
              SaienteColors.backGrey,
              SaienteColors.backGrey,
            ],
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            title: const Text('智能问答'),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  Get.to(() => const IntelligentHistoryPage())?.then((value) {
                    controller.id = value;
                    controller.answerList.clear();
                    controller.getDetail();
                  });
                },
                icon: const Icon(Icons.list),
              ),
              IconButton(
                onPressed: () {
                  controller.addNewQuestion();
                },
                icon: const Icon(Icons.add_circle_outline_outlined),
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: GetBuilder(
                  builder: (IntelligentController controller) {
                    if (controller.answerList.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              GetBuilder<MineController>(
                                builder: (MineController controller) {
                                  return Text(
                                    "HI，${controller.nickName ?? ''}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: SaienteColors.blackE5,
                                      fontSize: ScreenAdapter.fontSize(20),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 40),
                              Image.asset(
                                Assets.imagesIcIntelligentNoData,
                                width: 150,
                                height: 150,
                              ),
                              const SizedBox(height: 20),
                              Text(
                                '我是牛小慧，在下方输入你想搜索的肉牛养殖内容吧。',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: SaienteColors.blue4D91F5,
                                  fontSize: ScreenAdapter.fontSize(16),
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return ListView.separated(
                      controller: controller.scrollController,
                      itemBuilder: (context, index) {
                        final item = controller.answerList[index];
                        return ChatBubble(
                          content: item.content ?? '',
                          isSender: item.role == 'user',
                        );
                      },
                      separatorBuilder: (_, __) {
                        return const SizedBox(height: 6);
                      },
                      itemCount: controller.answerList.length,
                    );
                  },
                ),
              ),
              ChatInputWidget(
                onSend: (String text) {
                  controller.addQuestionAnswer(problem: text);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
