import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/page_wrapper.dart';

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
                  builder:
                      (IntelligentController controller) => ListView.separated(
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
                      ),
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
