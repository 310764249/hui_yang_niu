import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/chat_v2_models.dart';
import 'package:intellectual_breed/app/services/colors.dart';
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
      onTap: () => FocusScope.of(context).unfocus(),
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
              GetBuilder<IntelligentController>(
                builder: (controller) {
                  return IconButton(
                    tooltip: '历史会话',
                    onPressed: controller.isSending
                        ? null
                        : () {
                            Get.to(() => const IntelligentHistoryPage())
                                ?.then((value) {
                              if (value is! String || value.isEmpty) return;
                              controller.id = value;
                              controller.messages = [];
                              controller.pendingApprovals = [];
                              controller.getDetail();
                            });
                          },
                    icon: const Icon(Icons.history),
                  );
                },
              ),
              GetBuilder<IntelligentController>(
                builder: (controller) {
                  return IconButton(
                    tooltip: '新建会话',
                    onPressed:
                        controller.isSending ? null : controller.addNewQuestion,
                    icon: const Icon(Icons.add_comment_outlined),
                  );
                },
              ),
            ],
          ),
          body: GetBuilder<IntelligentController>(
            builder: (controller) {
              return Column(
                children: [
                  Expanded(child: _ConversationBody(controller: controller)),
                  ChatInputWidget(
                    enabled: !controller.isSending &&
                        !controller.isLoadingConversation,
                    onSend: (text) =>
                        controller.addQuestionAnswer(problem: text),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _ConversationBody extends StatelessWidget {
  const _ConversationBody({required this.controller});

  final IntelligentController controller;

  @override
  Widget build(BuildContext context) {
    if (controller.isLoadingConversation && controller.messages.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    if (controller.messages.isEmpty &&
        controller.pendingApprovals.isEmpty &&
        !controller.isSending) {
      return const _WelcomeView();
    }

    return CustomScrollView(
      controller: controller.scrollController,
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate((context, index) {
            final item = controller.messages[index];
            return ChatBubble(content: item.content, isSender: item.isUser);
          }, childCount: controller.messages.length),
        ),
        if (controller.pendingApprovals.isNotEmpty)
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final approval = controller.pendingApprovals[index];
                return _ApprovalCard(
                  approval: approval,
                  isSubmitting:
                      controller.decidingApprovalIds.contains(approval.id),
                  onDecision: (approved) {
                    controller.decideApproval(approval, approved: approved);
                  },
                );
              }, childCount: controller.pendingApprovals.length),
            ),
          ),
        if (controller.streamError != null)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Text(
                controller.streamError!,
                style: const TextStyle(color: Colors.redAccent, fontSize: 13),
              ),
            ),
          ),
        if (controller.isSending)
          const SliverToBoxAdapter(child: TypingBubble(isSender: false)),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
      ],
    );
  }
}

class _WelcomeView extends StatelessWidget {
  const _WelcomeView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<MineController>(
              builder: (controller) {
                return Text(
                  'HI，${controller.nickName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: SaienteColors.blackE5,
                    fontSize: ScreenAdapter.fontSize(20),
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
            const SizedBox(height: 40),
            Image.asset(Assets.imagesIcIntelligentNoData,
                width: 150, height: 150),
            const SizedBox(height: 20),
            Text(
              '我是牛小慧，在下方输入你想查询的肉牛养殖内容吧。',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: SaienteColors.blue4D91F5,
                fontSize: ScreenAdapter.fontSize(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ApprovalCard extends StatelessWidget {
  const _ApprovalCard({
    required this.approval,
    required this.isSubmitting,
    required this.onDecision,
  });

  final ApprovalModel approval;
  final bool isSubmitting;
  final ValueChanged<bool> onDecision;

  @override
  Widget build(BuildContext context) {
    final details = approval.summary?.trim().isNotEmpty == true
        ? approval.summary!.trim()
        : approval.arguments?.trim();
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: Colors.orange.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_user_outlined,
                    color: Colors.orange.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    approval.displayTitle,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
            if (details != null && details.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(details,
                  style: const TextStyle(fontSize: 14, color: Colors.black87)),
            ],
            const SizedBox(height: 12),
            if (isSubmitting)
              const Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => onDecision(false),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('拒绝'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => onDecision(true),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('确认'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class TypingBubble extends StatefulWidget {
  const TypingBubble({super.key, this.isSender = false});

  final bool isSender;

  @override
  State<TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _dot1;
  late final Animation<double> _dot2;
  late final Animation<double> _dot3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat();
    _dot1 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.6)),
    );
    _dot2 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.2, 0.8)),
    );
    _dot3 = Tween(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.4, 1.0)),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _dot(Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 2),
        child: Text('•', style: TextStyle(fontSize: 18, height: 1.1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bubbleColor = widget.isSender ? Colors.blueAccent : Colors.grey[300];
    final textColor = widget.isSender ? Colors.white : Colors.black87;
    return Align(
      alignment: widget.isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
            color: bubbleColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('思考中', style: TextStyle(color: textColor)),
            const SizedBox(width: 4),
            _dot(_dot1),
            _dot(_dot2),
            _dot(_dot3),
          ],
        ),
      ),
    );
  }
}
