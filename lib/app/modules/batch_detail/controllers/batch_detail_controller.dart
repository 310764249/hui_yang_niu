import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/cow_batch.dart';

import '../../../network/httpsClient.dart';
import '../../../widgets/dict_list.dart';

class BatchDetailController extends GetxController {
  //传入的参数
  CowBatch argument = Get.arguments;
  HttpsClient httpsClient = HttpsClient();
  // "批次类型"可选项
  List typeList = [];
  //生长阶段
  late List szjdList;
  //品种
  late List pzList;
  //公母
  late List gmList;

  @override
  void onInit() {
    super.onInit();
    typeList = AppDictList.searchItems('pclb') ?? [];
    szjdList = AppDictList.searchItems('szjd') ?? [];
    pzList = AppDictList.searchItems('pz') ?? [];
    gmList = AppDictList.searchItems('gm') ?? [];
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
