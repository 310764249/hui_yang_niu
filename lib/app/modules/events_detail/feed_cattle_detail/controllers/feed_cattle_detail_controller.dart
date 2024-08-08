import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
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
  List<Feeds> feedsTypeList = <Feeds>[];
  // 使用的饲料名称
  String feedsTypeName = Constant.placeholder;

  @override
  void onInit() async {
    super.onInit();

    handleArgument();
  }

  //处理传入参数
  //一类是事件列表时传入件对应的传入模型 SimpleEvent
  void handleArgument() async {
    Toast.showLoading(msg: '加载中');

    //饲料类型
    feedsTypeList = await CommonService().requestFeedStuffAll();

    if (ObjectUtil.isEmpty(argument)) {
      Toast.dismiss();
      //不传值异常
      Toast.failure(msg: '未传入参数');
      Get.back();
      return;
    }
    if (argument is SimpleEvent) {
      //时间列表进来的详情页面，传入的是 SimpleEvent
      event = FeedEvent.fromJson(argument.data);
      //根据 ID 筛选出 饲料名称
      for (Feeds item in feedsTypeList) {
        if (item.id == event!.feedstuffId) {
          feedsTypeName = item.name ?? Constant.placeholder;
          break;
        }
      }
    }
    Toast.dismiss();
    isLoading.value = false;
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
}
