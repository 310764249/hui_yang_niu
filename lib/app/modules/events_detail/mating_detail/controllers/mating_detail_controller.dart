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

class MatingDetailController extends GetxController {
  //TODO: Implement MatingDetailController
  //传入的参数
  var argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  //事件列表传入
  MatingEvent? event;
  //是否正在加载
  RxBool isLoading = true.obs;
  //牛只详情
  Cattle? cattle;
  //生长阶段
  late List szjdList;
  //品种
  late List pzList;
  //公母
  late List gmList;

  //类型
  late List passList;

  @override
  void onInit() {
    super.onInit();
    szjdList = AppDictList.searchItems('szjd') ?? [];
    pzList = AppDictList.searchItems('pz') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
    passList = AppDictList.searchItems('pzfs') ?? [];
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
      event = MatingEvent.fromJson(argument.data);
      await getCattleMoreData(event!.cowId!);
    } else if (argument is CattleEvent) {
      //生产记录传入的
      CattleEvent cattleEvent = argument;
      await getCattleMoreData(cattleEvent.cowId!);
      await getCattleEvent(cattleEvent.busiId);
    }
    update();
    Toast.dismiss();
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
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

  //获取事件详情
  Future<void> getCattleEvent(String businessId) async {
    try {
      var response = await httpsClient.get(
        "/api/mating/$businessId",
      );
      event = MatingEvent.fromJson(response);
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
