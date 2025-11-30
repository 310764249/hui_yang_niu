import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pickers/time_picker/time_utils.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/tools.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/refresh_header_footer.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:intellectual_breed/generated/assets.dart';

import '../../../models/intelligent_question_history_model.dart';
import '../../../services/colors.dart';

class IntelligentHistoryPage extends StatefulWidget {
  const IntelligentHistoryPage({super.key});

  @override
  State<IntelligentHistoryPage> createState() => _IntelligentHistoryPageState();
}

class _IntelligentHistoryPageState extends State<IntelligentHistoryPage> {
  HttpsClient httpsClient = HttpsClient();
  int pageIndex = 1;
  int pageSize = 20;

  bool hasMore = true;

  List<QuestionHistoryItem> questionHistoryList = [];

  EasyRefreshController controller = EasyRefreshController(
    controlFinishRefresh: true,
    controlFinishLoad: true,
  );

  @override
  void initState() {
    super.initState();
    refresh();
  }

  //刷新
  Future refresh() async {
    await getHistory(pageIndex: 1, pageSize: pageSize);
  }

  //加载更多
  Future loadMore() async {
    await getHistory(pageIndex: pageIndex + 1, pageSize: pageSize);
  }

  ///api/intelligentqa?PageIndex=1&PageSize=20
  ///获取历史记录
  Future getHistory({required int pageIndex, required int pageSize}) async {
    try {
      var response = await httpsClient.get(
        '/api/intelligentqa?PageIndex=$pageIndex&PageSize=$pageSize',
      );
      IntelligentQuestionHistoryModel model = IntelligentQuestionHistoryModel.fromJson(response);
      if (mounted) {
        setState(() {
          if (pageIndex == 1) {
            questionHistoryList = model.list ?? [];
          } else {
            questionHistoryList.addAll(model.list ?? []);
          }
          if ((model.list ?? []).length < pageSize) {
            hasMore = false;
          } else {
            hasMore = true;
          }
        });
      }
    } catch (e) {
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      print(e);
    }
  }

  ///api/intelligentqa
  //删除{
  //   "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //   "rowVersion": "2025-11-27T11:10:05.004Z"
  // }
  Future deleteHistory(String id, String row) async {
    try {
      await httpsClient.delete('/api/intelligentqa', data: {"id": id, "rowVersion": row});

      if (mounted) {
        setState(() {
          questionHistoryList.removeWhere((element) => element.id == id);
        });
      }
    } catch (e) {
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
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
            title: const Text('历史记录'),
            centerTitle: true,
          ),
          body: SafeArea(
            child: EasyRefresh(
              controller: controller,
              // 指定刷新时的头部组件
              header: CustomRefresh.refreshHeader(),
              // 指定加载时的底部组件
              footer: CustomRefresh.refreshFooter(),
              onRefresh: () async {
                await refresh();
                controller.finishRefresh();
                controller.resetFooter();
              },
              onLoad: () async {
                // 如果没有更多直接返回
                if (!hasMore) {
                  controller.finishLoad(IndicatorResult.noMore);
                  return;
                }
                // 上拉加载更多数据请求
                await loadMore();
                // 设置状态
                controller.finishLoad(hasMore ? IndicatorResult.success : IndicatorResult.noMore);
              },
              child: ListView.builder(
                itemBuilder: (context, index) {
                  final item = questionHistoryList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.back(result: item.id);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(Assets.imagesAppLogo, width: 48),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.title ?? '',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      Tools.formatTime(item.created ?? ''),
                                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Alert.showConfirm(
                                          '确定要删除吗？',
                                          onConfirm: () {
                                            deleteHistory(item.id ?? '', item.rowVersion ?? '');
                                          },
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.delete_outline,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  item.title ?? '',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
                itemCount: questionHistoryList.length,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
