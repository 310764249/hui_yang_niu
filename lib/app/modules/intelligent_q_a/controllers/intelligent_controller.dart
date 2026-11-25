import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/chat_v2_models.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../services/chat_stream_parser.dart';

class IntelligentController extends GetxController {
  final HttpsClient httpsClient = HttpsClient();
  final ScrollController scrollController = ScrollController();

  bool isSending = false;
  bool isLoadingConversation = false;
  String? id;
  String? streamError;
  List<ChatMessageModel> messages = [];
  List<ApprovalModel> pendingApprovals = [];
  final Set<String> decidingApprovalIds = {};

  Future<void> addQuestionAnswer({required String problem}) async {
    final text = problem.trim();
    if (text.isEmpty) return;
    if (isSending) {
      Toast.show('请等待当前回答完成');
      return;
    }

    messages.add(ChatMessageModel(content: text, role: 'user'));
    await _consumeStream(
      '/api/chat/stream',
      data: {'conversationId': id, 'message': text},
    );
  }

  Future<void> getDetail() async {
    final conversationId = id;
    if (conversationId == null || conversationId.isEmpty) return;

    isLoadingConversation = true;
    update();
    try {
      final result =
          await httpsClient.get('/api/chat/conversations/$conversationId');
      final detail = ConversationDetailModel.fromJson(
        (result as Map).cast<String, dynamic>(),
      );
      id = detail.id.isEmpty ? conversationId : detail.id;
      messages = detail.messages;
      await loadPendingApprovals();
      scrollToBottom();
    } catch (error) {
      _showError(error, fallback: '会话加载失败');
    } finally {
      isLoadingConversation = false;
      update();
    }
  }

  Future<void> loadPendingApprovals() async {
    final conversationId = id;
    if (conversationId == null || conversationId.isEmpty) {
      pendingApprovals = [];
      return;
    }
    try {
      final result =
          await httpsClient.get('/api/approvals/pending/$conversationId');
      if (result is List) {
        pendingApprovals = result
            .whereType<Map>()
            .map((item) => ApprovalModel.fromJson(item.cast<String, dynamic>()))
            .where((item) => item.id.isNotEmpty)
            .toList();
      }
    } catch (error) {
      _showError(error, fallback: '待确认操作加载失败');
    }
  }

  Future<void> decideApproval(
    ApprovalModel approval, {
    required bool approved,
    String? comment,
  }) async {
    if (isSending) {
      Toast.show('请等待当前操作完成');
      return;
    }
    if (approval.id.isEmpty || decidingApprovalIds.contains(approval.id)) {
      return;
    }
    decidingApprovalIds.add(approval.id);
    update();
    try {
      final completed = await _consumeStream(
        '/api/approvals/${approval.id}/decision',
        data: {'approved': approved, 'comment': comment},
      );
      if (completed) {
        pendingApprovals.removeWhere((item) => item.id == approval.id);
        await loadPendingApprovals();
      }
    } finally {
      decidingApprovalIds.remove(approval.id);
      update();
    }
  }

  Future<bool> _consumeStream(
    String path, {
    required Map<String, dynamic> data,
  }) async {
    isSending = true;
    streamError = null;
    var assistantIndex = -1;
    final parser = ChatStreamParser();
    update();
    scrollToBottom();

    var completed = true;
    try {
      await for (final chunk in httpsClient.postEventStream(path, data: data)) {
        for (final event in parser.add(chunk)) {
          assistantIndex = _applyStreamEvent(event, assistantIndex);
        }
      }
      for (final event in parser.finish()) {
        assistantIndex = _applyStreamEvent(event, assistantIndex);
      }

      if (assistantIndex >= 0 &&
          messages[assistantIndex].content.trim().isEmpty) {
        messages.removeAt(assistantIndex);
      }
      if (id != null) {
        await _refreshConversationAfterStream();
      }
      if (streamError != null) {
        completed = false;
        Toast.show(streamError!);
      }
    } catch (error) {
      completed = false;
      if (assistantIndex >= 0 &&
          assistantIndex < messages.length &&
          messages[assistantIndex].content.trim().isEmpty) {
        messages.removeAt(assistantIndex);
      }
      streamError = _errorMessage(error, fallback: '回答生成失败，请稍后重试');
      Toast.show(streamError!);
    } finally {
      isSending = false;
      update();
      scrollToBottom();
    }
    return completed;
  }

  int _applyStreamEvent(ChatStreamEvent event, int assistantIndex) {
    if (event.conversationId != null && event.conversationId!.isNotEmpty) {
      id = event.conversationId;
    }
    if (event.approval != null && event.approval!.id.isNotEmpty) {
      final index =
          pendingApprovals.indexWhere((item) => item.id == event.approval!.id);
      if (index >= 0) {
        pendingApprovals[index] = event.approval!;
      } else {
        pendingApprovals.add(event.approval!);
      }
    }
    if (event.error != null && event.error!.isNotEmpty) {
      streamError = event.error;
    }

    final content = event.content;
    if (content != null && content.isNotEmpty) {
      if (assistantIndex < 0) {
        messages.add(ChatMessageModel(content: '', role: 'assistant'));
        assistantIndex = messages.length - 1;
      }
      final current = messages[assistantIndex].content;
      if (event.isDelta) {
        messages[assistantIndex].content = current + content;
      } else if (current.isEmpty || content.startsWith(current)) {
        messages[assistantIndex].content = content;
      } else if (!current.endsWith(content)) {
        messages[assistantIndex].content = current + content;
      }
    }
    update();
    scrollToBottom();
    return assistantIndex;
  }

  Future<void> _refreshConversationAfterStream() async {
    try {
      final result = await httpsClient.get('/api/chat/conversations/$id');
      final detail = ConversationDetailModel.fromJson(
        (result as Map).cast<String, dynamic>(),
      );
      messages = detail.messages;
      await loadPendingApprovals();
    } catch (_) {
      // Keep streamed content when the follow-up snapshot is unavailable.
    }
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!scrollController.hasClients) return;
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void addNewQuestion() {
    messages = [];
    pendingApprovals = [];
    decidingApprovalIds.clear();
    streamError = null;
    id = null;
    update();
  }

  String _errorMessage(Object error, {required String fallback}) {
    if (error is ApiException) return error.message;
    return fallback;
  }

  void _showError(Object error, {required String fallback}) {
    Toast.show(_errorMessage(error, fallback: fallback));
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }
}
