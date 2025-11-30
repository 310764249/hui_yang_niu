import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/answer_item_model.dart';
import 'package:intellectual_breed/app/models/answer_model.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

class IntelligentController extends GetxController {
  HttpsClient httpsClient = HttpsClient();
  ScrollController scrollController = ScrollController();

  bool isSending = false;

  //会话ID
  String? id;
  List<AnswerItemModel> answerList = [];

  //添加问答
  //{
  //   "id": "3fa85f64-5717-4562-b3fc-2c963f66afa6",
  //   "problem": "string",
  // }
  Future addQuestionAnswer({required String problem}) async {
    isSending = true;
    update();
    scrollToBottom();
    String api = '/api/intelligentqa/create';
    try {
      final result = await httpsClient.post(api, data: {"id": id, "Problem": problem});
      AnswerModel answerModel = AnswerModel.fromJson(result);
      id = answerModel.id;
      await getDetail();
      isSending = false;
      update();
    } catch (e) {
      isSending = false;
      update();
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
    }
  }

  //获取详情信息
  Future getDetail() async {
    String api = '/api/intelligentqa/detail';
    try {
      final result = await httpsClient.get(api, queryParameters: {"id": id});
      answerList =
          result
              .map<AnswerItemModel>((e) => AnswerItemModel.fromJson(e as Map<String, dynamic>))
              .toList();
      scrollToBottom();
      update();
    } catch (e) {
      if (e is ApiException) {
        Toast.show(e.message);
        return;
      }
      debugPrint('intelligentqa: getDetail error$e');
    }
  }

  //滚动到底部
  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  void addNewQuestion() {
    answerList.clear();
    id = null;
    update();
  }
}
