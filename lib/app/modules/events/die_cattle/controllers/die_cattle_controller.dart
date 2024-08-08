import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/models/event_argument.dart';

import 'package:keyboard_actions/keyboard_actions.dart';
import '../../../../models/cattle.dart';
import '../../../../models/cow_batch.dart';
import '../../../../models/simple_event.dart';
import '../../../../network/apiException.dart';
import '../../../../network/file_upload.dart';
import '../../../../network/httpsClient.dart';
import '../../../../services/Log.dart';
import '../../../../services/constant.dart';
import '../../../../services/keyboard_actions_helper.dart';
import '../../../../services/user_info_tool.dart';
import '../../../../widgets/dict_list.dart';
import '../../../../widgets/toast.dart';
import '../../../../services/ex_string.dart';

class DieCattleController extends GetxController {
  //TODO: Implement DieCattleController
  //传入的参数
  var argument = Get.arguments;
  //编辑事件传入
  DeathArgument? event;
  //是否是编辑页面
  RxBool isEdit = false.obs;

  //输入框
  TextEditingController countController = TextEditingController();
  TextEditingController columnController = TextEditingController(); //栏位
  TextEditingController remarkController = TextEditingController();
  // TextEditingController sourceController = TextEditingController();
  //
  final FocusNode countNode = FocusNode();
  final FocusNode columnNode = FocusNode();
  final FocusNode remarkNode = FocusNode();

  KeyboardActionsConfig buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      nextFocus: true,
      actions: [
        KeyboardActionsHelper.getDefaultItem(countNode),
        KeyboardActionsHelper.getDefaultItem(columnNode),
        KeyboardActionsHelper.getDefaultItem(remarkNode),
      ],
    );
  }

  HttpsClient httpsClient = HttpsClient();

  // "类型"可选项
  List chooseTypeList = [];
  List<String> chooseTypeNameList = [
    '种牛',
    '犊牛/育肥牛',
  ];
  // "类型"选中项: 默认第一项
  final chooseTypeIndex = 0.obs;
  //当前选中的牛
  late Cattle selectedCow;
  //耳号
  final codeString = ''.obs;
  //当前选中的批次模型
  late CowBatch selectedCowBatch;
  //批次号
  final batchNumber = ''.obs;
  //数量
  final countNum = 0.obs;

  // "死亡原因"可选项
  List reasonList = [];
  List<String> reasonNameList = [];
  String curReasonID = '';
  final reasonIndex = 0.obs;

  //上传图片显示地址
  RxList<String> imgsList = <String>[].obs;
  //上传图片ID
  List imgsPathList = [];

  //调拨时间
  final timesStr = ''.obs;
  //备注
  String remarkStr = '';
  //过滤之后的生长阶段，传给筛选页面
  List szjdListFiltered = [];

  @override
  void onInit() {
    super.onInit();

    //初始化为当前日期
    timesStr.value =
        DateUtil.formatDate(DateTime.now(), format: DateFormats.y_mo_d);
    //淘汰原因
    reasonList = AppDictList.searchItems('swyy') ?? [];
    curReasonID = reasonList.isNotEmpty ? reasonList.first['value'] : '';
    reasonNameList =
        List<String>.from(reasonList.map((item) => item['label']).toList());
    //获取生长阶段字典项
    List szjdList = AppDictList.searchItems('szjd') ?? [];
    // 筛选显示
    szjdListFiltered =
        AppDictList.findMapByCode(szjdList, ['3', '4', '5', '6', '7', '8']);
    //首先处理传入参数
    handleArgument();
  }

  //处理传入参数
  //一类是只传入 Cattle 模型取耳号就好 任务统计-列表-事件
  //二类是事件编辑时传入件对应的传入模型
  void handleArgument() async {
    if (ObjectUtil.isEmpty(argument)) {
      //不传值是新增
      return;
    }
    Toast.showLoading();
    if (argument is Cattle) {
      //任务事件
      selectedCow = argument;
      updateCodeString(selectedCow.code ?? '');
    } else if (argument is SimpleEvent) {
      isEdit.value = true;
      //编辑
      event = DeathArgument.fromJson(argument.data);
      //print(event!.rowVersion);
      //填充耳号/批次号
      if (ObjectUtil.isEmpty(event?.batchNo)) {
        updateChooseTypeIndex(0);
        updateCodeString(event?.cowCode ?? '');
        //获取牛只详情
        await getCattleMoreData(event!.cowId!);
      } else if (ObjectUtil.isEmpty(event?.cowCode)) {
        updateChooseTypeIndex(1);
        updateBatchNumber(event?.batchNo ?? '');
        //获取批次详情
        await getBatchMoreData(event!.batchNo!);
      }
      //填充数量
      countController.text = event!.count == 0 ? '' : event!.count.toString();
      //填充原因
      curReasonID = event!.cause.toString(); //提交数据
      reasonIndex.value = AppDictList.findIndexByCode(
          reasonList, event!.cause.toString()); //显示选中项

      if (!ObjectUtil.isEmpty(event!.attach) &&
          event!.attach != Constant.placeholder) {
        //图片
        imgsPathList = (event!.attach ?? '').split(',');
        //把 ID 换为 图片地址
        List<String> temp = [];
        for (String ID in imgsPathList) {
          //
          String path = await FileUploadTool().requestUploadPath(ID);
          temp.add('${Constant.uploadFile}/$path?id=$ID');
          //https://file.zbxx.info/uploads/jxzx/breed/breedmini/4e.jpg?id=1
        }
        // imgsList.value =
        //     imgsPathList.map((item) => Constant.uploadFileUrl + item).toList();
        imgsList.value = temp;
      }

      // print(imgsList);
      imgsList.refresh();
      //填充时间
      updateSeldate(event!.date);
      //填充备注
      remarkController.text = event?.remark ?? '';
      //更新
      update();
    }
    Toast.dismiss();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // 更新"当前状态"选中项
  void updateChooseTypeIndex(int index) {
    chooseTypeIndex.value = index;
    if (index == 0) {
      //选择种牛，清空 犊牛的填写数据
      batchNumber.value = '';
    } else {
      //选择犊牛，清空种牛的填写数据
      codeString.value = '';
      countController.text = '';
    }
    update();
  }

  // 时间
  void updateSeldate(String date) {
    timesStr.value = date;
    update();
  }

  // 更新 批次号
  void updateBatchNumber(String value) {
    batchNumber.value = value;
    update();
  }

  // 更新 耳号
  void updateCodeString(String value) {
    codeString.value = value;
    update();
  }

  // 更新选择原因
  void updateCurReason(int index) {
    curReasonID = reasonList[index]['value'];
    reasonIndex.value = index;
    update();
  }

  // 上传图片
  Future<void> uploadImages() async {
    imgsPathList = [];
    if (ObjectUtil.isNotEmpty(imgsList.value)) {
      for (String path in imgsList.value) {
        if (path.contains('http')) {
          //获取 url 后面的 ID 参数
          var uri = Uri.dataFromString(path);
          var para = uri.queryParameters;
          //图片已存在就不上传
          // path = path.replaceAll(Constant.uploadFileUrl, '');
          imgsPathList.add(para['id']);
        } else {
          //print('上传图片：$path');
          //上传本地图片
          String ID = await FileUploadTool().uploadWith(path);
          imgsPathList.add(ID);
        }
      }
    }
    return Future.value();
  }

  // 提交数据
  void requestCommit() async {
    if (chooseTypeIndex.value == 0) {
      //种牛
      if (ObjectUtil.isEmpty(codeString.value)) {
        Toast.show('耳号未获取,请点击耳号选择');
        return;
      }
      //时间不能小于入场日期
      if (timesStr.value.isBefore(selectedCow.inArea)) {
        Toast.show('死亡时间不能早于入场日期');
        return;
      }
      //时间不能小于出生日期
      if (timesStr.value.isBefore(selectedCow.birth)) {
        Toast.show('死亡时间不能早于出生日期');
        return;
      }
    } else {
      //育肥牛
      if (ObjectUtil.isEmpty(batchNumber.value)) {
        Toast.show('批次号未获取,请点击批次号选择');
        return;
      }
      String count = countController.text.trim();
      if (ObjectUtil.isEmpty(count)) {
        Toast.show('请输入数量');
        return;
      }
      //时间不能小于入场日期
      if (timesStr.value.isBefore(selectedCowBatch.inArea)) {
        Toast.show('死亡时间不能早于入场日期');
        return;
      }
    }

    //判断提交类型
    if (ObjectUtil.isEmpty(event)) {
      newAction();
    } else {
      editAction();
    }
  }

  //新增事件
  void newAction() async {
    Toast.showLoading();
    //
    await uploadImages();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'type': chooseTypeIndex.value + 1, //必传 integer 类型1：种牛；2：犊牛-育肥牛；
        'cowId': codeString.value.isEmpty ? '' : selectedCow.id, // string 牛只编码
        'batchNo': batchNumber.value, // string 批次号
        'count': countController.text.trim(), //必传 integer 数量
        'cause': int.parse(curReasonID), //必传 integer 死亡原因
        'executor': UserInfoTool.nickName(), // string 鉴定人
        'attach': ObjectUtil.isEmpty(imgsPathList.join(','))
            ? ''
            : imgsPathList.join(','), // string 附件 "xxx.png,xxx.png,xxx.png"
        'date': timesStr.value, //必传 string 死亡时间
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.post("/api/death", data: para);
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

  //编辑事件
  void editAction() async {
    Toast.showLoading();
    //
    await uploadImages();
    try {
      //接口参数
      Map<String, dynamic> para = {
        'id': event!.id, //事件 ID
        'rowVersion': event!.rowVersion, //事件行版本
        'type': chooseTypeIndex.value + 1, //必传 integer 类型1：种牛；2：犊牛-育肥牛；
        'cowId': codeString.value.isEmpty ? '' : event!.cowId, // string 牛只编码
        'batchNo': batchNumber.value, // string 批次号
        'count': countController.text.trim(), //必传 integer 数量
        'cause': int.parse(curReasonID), //必传 integer 死亡原因
        'executor': UserInfoTool.nickName(), // string 鉴定人
        'attach': ObjectUtil.isEmpty(imgsPathList.join(','))
            ? ''
            : imgsPathList.join(','), // string 附件 "xxx.png,xxx.png,xxx.png"
        'date': timesStr.value, //必传 string 死亡时间
        'remark': remarkController.text.trim(), // 备注
      };

      //print(para);
      await httpsClient.put("/api/death", data: para);
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

  //获取牛只详情
  Future<void> getCattleMoreData(String cowId) async {
    try {
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      selectedCow = Cattle.fromJson(response);
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
      selectedCowBatch = CowBatch.fromJson(response);
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
