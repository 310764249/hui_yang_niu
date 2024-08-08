import 'package:common_utils/common_utils.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/keyboard_actions_helper.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/toast.dart';

class FeedBackController extends GetxController {
  //TODO: Implement FeedBackController
  TextEditingController titleController = TextEditingController();
  TextEditingController inputController = TextEditingController();
  //
  final FocusNode titleNode = FocusNode();
  final FocusNode inputNode = FocusNode();
  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(titleNode),
        KeyboardActionsHelper.getDefaultItem(inputNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();
  //反馈问题类型
  List fkwtList = [];
  List fkwtNameList = [];
  String curNameID = '';
  RxString curNameValue = ''.obs;

  @override
  void onInit() {
    super.onInit();

    fkwtList = AppDictList.searchItems('fkwt') ?? [];
    fkwtNameList =
        List<String>.from(fkwtList.map((item) => item['label']).toList());
    curNameID = fkwtList.isNotEmpty ? fkwtList.first['value'] : '';
    curNameValue.value = fkwtList.isNotEmpty ? fkwtList.first['label'] : '';
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void updateFKWT(String value, int index) {
    curNameID = fkwtList[index]['value'];
    curNameValue.value = value;
    update();
  }

  // 提交数据
  void requestCommit() async {
    String title = titleController.text.trim();
    if (ObjectUtil.isEmpty(title)) {
      Toast.show('请输入标题');
      return;
    }
    String count = inputController.text.trim();
    if (ObjectUtil.isEmpty(count)) {
      Toast.show('请输入内容');
      return;
    }
    Toast.showLoading();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'issueType': curNameID,
        'title': titleController.text, //
        'content': inputController.text, //
      };
      await httpsClient.post("/api/feedback", data: para);
      Toast.dismiss();
      Toast.success(msg: '提交成功');
      Get.back();
    } catch (error) {
      Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
        Toast.failure(msg: error.toString());
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
