import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/formula.dart';
import 'package:intellectual_breed/app/network/apiException.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/feeds.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/common_service.dart';
import '../../../../widgets/toast.dart';

class FeedCattleDetailController extends GetxController {
  //TODO: Implement FeedCattleDetailController

  //传入的参数
  var argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  //事件列表传入
  FeedEvent? event;
  //是否正在加载
  RxBool isLoading = true.obs;

  // 饲料类型
  // List<Feeds> feedsTypeList = <Feeds>[];
  // 使用的饲料名称
  String feedsTypeName = Constant.placeholder;
  //校正饲喂量
  String dosage = Constant.placeholder;

  //配方详情信息
  RxList<FormulaItemModel> modelList = <FormulaItemModel>[].obs;

  @override
  void onInit() async {
    super.onInit();

    //TODO 没哟配方名称和和校正饲喂量

    if (argument is SimpleEvent) {
      event = FeedEvent.fromJson(argument.data);
      feedsTypeName = event?.formulaName ?? Constant.placeholder;
      dosage = '${event?.dosage ?? Constant.placeholder}';

      update();
    }

    // handleArgument();
    //获取饲喂事件详情
    getFormulaItems();
  }

  //处理传入参数
  //一类是事件列表时传入件对应的传入模型 SimpleEvent
  // void handleArgument() async {
  //   Toast.showLoading(msg: '加载中');
  //
  //   //饲料类型
  //   feedsTypeList = await CommonService().requestFeedStuffAll();
  //
  //   if (ObjectUtil.isEmpty(argument)) {
  //     Toast.dismiss();
  //     //不传值异常
  //     Toast.failure(msg: '未传入参数');
  //     Get.back();
  //     return;
  //   }
  //   if (argument is SimpleEvent) {
  //     //时间列表进来的详情页面，传入的是 SimpleEvent
  //     event = FeedEvent.fromJson(argument.data);
  //     //根据 ID 筛选出 饲料名称
  //     for (Feeds item in feedsTypeList) {
  //       if (item.id == event!.feedstuffId) {
  //         feedsTypeName = item.name ?? Constant.placeholder;
  //         break;
  //       }
  //     }
  //   }
  //   Toast.dismiss();
  //   isLoading.value = false;
  //   update();
  // }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

/*  void getFeedCattleDetail() {
    String id = argument is SimpleEvent ? argument.id : '';
    Log.d('id = $id');
    httpsClient.get('/api/feed/$id').then((value) {
      Log.d(value.toString());
    });
  }*/

  //获取配方详情
  //获取事件详情
  Future<void> getFormulaItems() async {
    Toast.showLoading();
    try {
      var response = await httpsClient.get("/api/formulaItems/getAll", queryParameters: {
        "formulaId": event?.formulaId,
      });
      Log.d(response.toString());
      Toast.dismiss();

      for (var item in response) {
        FormulaItemModel model = FormulaItemModel.fromJson(item);
        modelList.add(model);
      }
      // items.value = modelList;
      isLoading.value = false;
      update();
    } catch (error) {
      isLoading.value = false;
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
