import 'package:get/get.dart';
import 'package:common_utils/common_utils.dart';

import '../../../../models/cattle.dart';
import '../../../../models/cattle_event.dart';
import '../../../../models/cow_batch.dart';
import '../../../../models/event_argument.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/file_upload.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/AssetsImages.dart';
import '../../../../services/Log.dart';
import '../../../../services/constant.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';

class DieCattleDetailController extends GetxController {
  //TODO: Implement DieCattleDetailController
  //传入的参数
  var argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();

  //牛只详情
  Cattle? cattle;
  //牛只详情
  CowBatch? cowBatch;

  //事件列表传入
  DeathArgument? event;
  //是否正在加载
  RxBool isLoading = true.obs;
  //生长阶段
  late List szjdList;
  //品种
  late List pzList;
  //公母
  late List gmList;
  //批次类别
  late List pclbList;

  //上传图片显示地址
  RxList<String> imgsList = <String>[].obs;

  // "原因"可选项
  List reasonList = [];

  //显示数据
  String code = ''; //牛只耳号或者批次号
  String icon = ''; //牛只图片
  String genderCode = '';
  String gender = '';
  String szjd = '';
  String pz = '';
  String cowHouseName = '';
  String ageOfDay = '';
  String eleOrCount = '电子耳号: ';
  String eleOrCountValue = '';

  @override
  void onInit() {
    super.onInit();
    szjdList = AppDictList.searchItems('szjd') ?? [];
    pzList = AppDictList.searchItems('pz') ?? [];
    pclbList = AppDictList.searchItems('pclb') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
    //原因
    reasonList = AppDictList.searchItems('swyy') ?? [];
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
      //事件列表进来的详情页面，传入的是 SimpleEvent
      event = DeathArgument.fromJson(argument.data);
      if (event!.cowCode != null) {
        //获取牛只详情
        await getCattleMoreData(event!.cowId!);
        //处理头部显示的数据
        handleCattleHeader();
      } else if (event!.batchNo != null) {
        //获取批次详情
        await getBatchMoreData(event!.batchNo!);
        //处理头部显示的数据
        handleBatchHeader();
      }
    } else if (argument is CattleEvent) {
      //生产记录传入的只有耳号
      CattleEvent cattleEvent = argument;
      //获取牛只详情
      await getCattleMoreData(cattleEvent.cowId!);
      //处理头部显示的数据
      handleCattleHeader();
      //请求事件详情
      await getCattleEvent(cattleEvent.busiId);
    }

    if (!ObjectUtil.isEmpty(event!.attach) &&
        event!.attach != Constant.placeholder) {
      //图片
      List imgIDs = (event!.attach ?? '').split(',');
      //把 ID 换为 图片地址
      List<String> temp = [];
      for (String ID in imgIDs) {
        String path = await FileUploadTool().requestUploadPath(ID);
        temp.add('${Constant.uploadFile}/$path?id=$ID');
        //https://file.zbxx.info/uploads/jxzx/breed/breedmini/4e.jpg?id=1
      }
      imgsList.value = temp;
      // imgsList.value =
      //     temp.map((item) => Constant.uploadFileUrl + item).toList();
    }

    update();
    Toast.dismiss();
    isLoading.value = false;
  }

  //设置牛只详情头部信息
  void handleCattleHeader() {
    //处理头部显示的数据
    code = cattle!.code ?? '';
    genderCode = cattle!.gender.toString();
    gender = AppDictList.findLabelByCode(gmList, genderCode);
    szjd =
        AppDictList.findLabelByCode(szjdList, cattle!.growthStage.toString());
    pz = AppDictList.findLabelByCode(pzList, cattle!.kind.toString());
    cowHouseName = cattle!.cowHouseName ?? Constant.placeholder;
    ageOfDay = cattle!.ageOfDay.toString();
    icon = genderCode == '2' ? AssetsImages.cow : AssetsImages.bull;
    eleOrCount = '电子耳号: ';
    eleOrCountValue = cattle!.eleCode ?? Constant.placeholder;
  }

  //设置批次详情头部信息
  void handleBatchHeader() {
    //处理头部显示的数据
    code = cowBatch!.batchNo ?? '';
    genderCode = cowBatch!.gender.toString();
    gender = AppDictList.findLabelByCode(gmList, genderCode);
    szjd = AppDictList.findLabelByCode(pclbList, cowBatch!.type.toString());
    pz = AppDictList.findLabelByCode(pzList, cowBatch!.kind.toString());
    cowHouseName = cowBatch!.cowHouseName ?? Constant.placeholder;
    ageOfDay = cowBatch!.ageOfDay.toString();
    icon = AssetsImages.batchPng;
    eleOrCount = '总   数: ';
    eleOrCountValue = cowBatch!.count.toString();
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

  //获取批次详情
  Future<void> getBatchMoreData(String batchId) async {
    try {
      var response = await httpsClient.get(
        "/api/cowbatch/getbybatchno",
        queryParameters: {"batchNo": batchId},
      );
      cowBatch = CowBatch.fromJson(response);
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
        "/api/death/$businessId",
      );
      event = DeathArgument.fromJson(response);
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
