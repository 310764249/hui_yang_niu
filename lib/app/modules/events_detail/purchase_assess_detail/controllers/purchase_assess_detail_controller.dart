import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import '../../../../models/cattle.dart';
import '../../../../models/cattle_event.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class PurchaseAssessDetailController extends GetxController {
  //TODO: Implement PreventionDetailController
  //传入的参数
  var argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  //事件列表传入
  PurchaseEvent? event;
  //是否正在加载
  RxBool isLoading = true.obs;
  //牛只详情
  Cattle? cattle;

  //采购评估
  late List purchaseAssessList;

  @override
  void onInit() {
    super.onInit();
    purchaseAssessList = AppDictList.searchItems('wzfl') ?? [];
    //处理传入参数
    handleArgument();
  }

  //处理传入参数
  //一类是事件列表时传入件对应的传入模型 SimpleEvent
  //二类是 牛只档案生产记录传入的
  void handleArgument() async {
    Toast.showLoading(msg: '加载中');
    if (ObjectUtil.isEmpty(argument)) {
      Toast.dismiss();
      //不传值异常
      Toast.failure(msg: '未传入参数');
      Get.back();
      return;
    }
    if (argument is SimpleEvent) {
      //时间列表进来的详情页面，传入的是 SimpleEvent
      event = PurchaseEvent.fromJson(argument.data);
    }
    update();
    Toast.dismiss();
    isLoading.value = false;
  }

  //获取牛只详情
  Future<void> getCattleMoreData(String cowId) async {
    try {
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      cattle = Cattle.fromJson(response);
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
