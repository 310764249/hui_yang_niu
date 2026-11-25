import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/chat_v2_models.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/tools.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/refresh_header_footer.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:intellectual_breed/generated/assets.dart';

import '../../../services/colors.dart';

class IntelligentHistoryPage extends StatefulWidget {
  const IntelligentHistoryPage({super.key});

  @override
  State<IntelligentHistoryPage> createState() => _IntelligentHistoryPageState();
}

class _IntelligentHistoryPageState extends State<IntelligentHistoryPage> {
  final HttpsClient httpsClient = HttpsClient();
  final EasyRefreshController refreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );
  List<ConversationSummaryModel> conversations = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  Future<void> getHistory() async {
    try {
      final response = await httpsClient.get('/api/chat/conversations');
      final items = response is List
          ? response
              .whereType<Map>()
              .map((item) => ConversationSummaryModel.fromJson(
                  item.cast<String, dynamic>()))
              .where((item) => item.id.isNotEmpty)
              .toList()
          : <ConversationSummaryModel>[];
      if (!mounted) return;
      setState(() {
        conversations = items;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() => isLoading = false);
      Toast.show(error is ApiException ? error.message : '历史会话加载失败');
    }
  }

  Future<void> deleteHistory(String id) async {
    try {
      await httpsClient.delete('/api/chat/conversations/$id');
      if (!mounted) return;
      setState(() => conversations.removeWhere((item) => item.id == id));
    } catch (error) {
      Toast.show(error is ApiException ? error.message : '会话删除失败');
    }
  }

  @override
  void dispose() {
    refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: const Text('历史会话'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : EasyRefresh(
                  controller: refreshController,
                  header: CustomRefresh.refreshHeader(),
                  onRefresh: () async {
                    await getHistory();
                    refreshController.finishRefresh();
                  },
                  child: conversations.isEmpty
                      ? const _EmptyHistoryView()
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          itemCount: conversations.length,
                          itemBuilder: (context, index) {
                            final item = conversations[index];
                            return _ConversationTile(
                              item: item,
                              onOpen: () => Get.back(result: item.id),
                              onDelete: () {
                                Alert.showConfirm(
                                  '确定要删除该会话吗？',
                                  onConfirm: () => deleteHistory(item.id),
                                );
                              },
                            );
                          },
                        ),
                ),
        ),
      ),
    );
  }
}

class _ConversationTile extends StatelessWidget {
  const _ConversationTile({
    required this.item,
    required this.onOpen,
    required this.onDelete,
  });

  final ConversationSummaryModel item;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final date = item.updatedAt ?? item.createdAt ?? '';
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onOpen,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(Assets.imagesAppLogo, width: 44, height: 44),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '${item.messageCount} 条消息${date.isEmpty ? '' : '  ${Tools.formatTime(date)}'}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '删除会话',
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyHistoryView extends StatelessWidget {
  const _EmptyHistoryView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('暂无历史会话', style: TextStyle(color: Colors.grey)),
    );
  }
}
