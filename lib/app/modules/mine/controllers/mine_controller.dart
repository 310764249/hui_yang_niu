import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/event_bus_util.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../models/user_resource.dart';
import '../../../network/apiException.dart';
import '../../../network/file_upload.dart';
import '../../../network/httpsClient.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/Log.dart';
import '../../../services/constant.dart';
import '../../../services/storage.dart';

class MineController extends GetxController {
  //TODO: Implement MineController
  HttpsClient httpsClient = HttpsClient();
  //点赞数
  RxInt dianZhanNum = 0.obs;
  //收藏数
  RxInt favoritesNum = 0.obs;

  RxString headerImg = AssetsImages.avatar.obs;
  RxString nickName = Constant.placeholder.obs;
  RxString phoneNum = Constant.placeholder.obs;
  RxString deptName = Constant.placeholder.obs;
  RxString farmName = ''.obs;
  RxBool showRecord = false.obs; //是否显示备案中心
  RxString principal = Constant.placeholder.obs; //管理员
  RxString cowHouseCount = Constant.placeholder.obs;
  RxString cowCount = Constant.placeholder.obs;
  RxString employeeCount = Constant.placeholder.obs;

  //是否开启大字模式
  RxBool isOpenBigFont = false.obs;

  @override
  void onInit() async {
    super.onInit();

    //监听用户登录状态
    EventBusUtil.addListener<UserLogInEvent>((event) {
      if (event.state == UserState.Login) {
        refreshPage();
      }
    });
    //监听用户头像更新
    EventBusUtil.addListener<UserIconChangeEvent>((event) {
      //更新头像
      headerImg.value = '${Constant.uploadFileUrl}${event.ID}';
      update();
    });
    isOpenBigFont.value = await Storage.getBool(Constant.isOpenBigFont);
  }

  updateBigFont(bool isOpen) {
    isOpenBigFont.value = isOpen;
    Storage.setBool(Constant.isOpenBigFont, isOpenBigFont.value).then((value) {
      EventBusUtil.fireEvent('bigFont');
    });
    update();
  }

  @override
  void onReady() {
    super.onReady();
    debugPrint('--onReady--');
  }

  @override
  void onClose() {
    super.onClose();
    debugPrint('--onClose--');
    //取消监听
    EventBusUtil.removeListener();
  }

  void updateSelFarm() async {
    //TODO-测试用，暂时 farm 数据结构没确定
    Map? selFarm = await Storage.getData(Constant.selectFarmData);
    if (selFarm == null) {
      //没有选择过，第一次启动，记得退出登录时清除缓存
      //TODO--默认选择第一个养殖场
      farmName.value = Constant.placeholder;
      principal.value = Constant.placeholder;
      cowHouseCount.value = Constant.placeholder;
      cowCount.value = Constant.placeholder;
      employeeCount.value = Constant.placeholder;
      return;
    }
    String ID = selFarm['id'];

    //TODO-测试用，暂未整理
    var response = await httpsClient.get("/api/farm/$ID");
    farmName.value = response['name'];
    principal.value = response['principal'];
    cowHouseCount.value = response['cowHouseCount'].toString();
    cowCount.value = response['cowCount'].toString();
    employeeCount.value = response['employeeCount'].toString();
    update();
  }

  void updateHeader(path) async {
    //上传图片
    String ID = await FileUploadTool().uploadWith(path);
    headerImg.value = '${Constant.uploadFileUrl}$ID';
    //更新
    //api/user/uploadprofilephoto
    await httpsClient.post("/api/user/uploadprofilephoto", data: {"id": UserInfoTool.userID(), "avatarUrl": ID});
    //UserInfoTool.user?.avatarUrl = ID;
    //通知头像更新
    EventBusUtil.fireEvent(UserIconChangeEvent(ID));

    update();
  }

  //页面每次显示获取数据
  void getUserData() async {
    var res = await Storage.getData(Constant.userResData);
    if (res != null) {
      UserResource resourceModel = UserResource.fromJson(res);

      nickName.value = resourceModel.nickName ?? '';
      String phoneNo = TextUtil.hideNumber(resourceModel.phone ?? '');
      phoneNum.value = phoneNo;
      deptName.value = resourceModel.farmer ?? '';

      //图片更新后优先展示 headerImg.value 如果为空则展示默认头像
      //print(UserInfoTool.avatarUrl());
      if (ObjectUtil.isEmptyString(UserInfoTool.avatarUrl())) {
        headerImg.value = AssetsImages.avatar;
      } else {
        headerImg.value = '${Constant.uploadFileUrl}${UserInfoTool.avatarUrl()}';
      }
      //农户散养 状态的不显示备案中心
      // showRecord.value = resourceModel.farmerType == 3 ? false : true;
      showRecord.value = resourceModel.type == 1 ? false : true;

      update();
    }
  }

  //打电话
  Future<void> launchPhone(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );

    if (!await launchUrl(launchUri)) {
      throw Exception('Could not launch $launchUri');
    }
  }

  //获取当前角色点赞数
  void requestDianZhan() async {
    try {
      var response = await httpsClient.get(
        "/api/tsan/count",
      );
      //print(response);
      dianZhanNum.value = response;
      update();
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //获取当前角色收藏数
  void requestCollection() async {
    try {
      var response = await httpsClient.get(
        "/api/favorites/count",
      );
      //print(response);
      favoritesNum.value = response;
      update();
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }

  //刷新页面数据
  void refreshPage() {
    //实时获取数据
    getUserData();
    //更新养殖场
    updateSelFarm();
    //点赞数
    requestDianZhan();
    //收藏数
    requestCollection();
  }
}
