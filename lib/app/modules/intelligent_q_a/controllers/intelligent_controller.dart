import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart' hide FormData, MultipartFile, Response;
import 'package:intellectual_breed/app/models/answer_item_model.dart';
import 'package:intellectual_breed/app/models/answer_model.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../models/authModel.dart';
import '../../../services/user_info_tool.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/cupertino.dart';
import 'package:http_parser/http_parser.dart';

import 'package:intellectual_breed/app/services/constant.dart';

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
      isSending = false;
      update();
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

  void addVideoQuestionAnswer({required File problem, required int duration}) async {
    String api = '/api/intelligentqa/createintelligentqa';
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        problem.path,
        filename: problem.path.split('/').last,
        contentType: MediaType.parse('audio/aac'),
      ),
    });
    AuthModel authModel = UserInfoTool.auth!;
    String accessToken = authModel.accessToken;
    Options options = Options(
      headers: {'Authorization': 'Bearer $accessToken'},
      contentType: 'multipart/form-data',
    );

    Dio dio = Dio();

    Response response = await dio.post(
      '${Constant.uploadFile}$api',
      data: formData,
      options: options,
      onSendProgress: (progress, total) {
        print('上传进度: $progress / $total');
      },
    );

    print(response.data);
  }
}
