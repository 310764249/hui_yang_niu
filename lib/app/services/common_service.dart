import 'dart:convert';
import 'dart:ffi';

import 'package:common_utils/common_utils.dart';
import 'package:event_bus/event_bus.dart';
import 'package:intellectual_breed/app/models/cattle.dart';
import 'package:intellectual_breed/app/models/farm.dart';
import 'package:intellectual_breed/app/models/feeds.dart';
import 'package:intellectual_breed/app/models/stock.dart';
import 'package:intellectual_breed/app/services/JPush_tool.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/storage.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';
import 'package:jpush_flutter/jpush_flutter.dart';

import '../models/authModel.dart';
import '../models/cow_house.dart';
import '../models/user_resource.dart';
import '../network/apiException.dart';
import '../network/file_upload.dart';
import '../network/httpsClient.dart';
import '../widgets/dict_list.dart';
import 'event_bus_util.dart';

class CommonService {
  static final CommonService _instance = CommonService._internal();
  factory CommonService() {
    return _instance;
  }
  // 构造函数私有化，防止外部直接实例化
  CommonService._internal();

  //
  HttpsClient httpsClient = HttpsClient();

  /// 请求用户相关数据，每次登录成功后、每次冷启动进入 APP 后请求
  Future<void> requestAllUserInfo() async {
    // 发送请求前，获取当前有效的 Token
    var auth = await Storage.getData(Constant.authData);
    if (auth != null) {
      AuthModel authModel = AuthModel.fromJson(auth);
      //写到内存中，方便使用
      UserInfoTool.auth = authModel;
    }
    //获取用户资源
    await requestUserResource();
    //获取字典
    await requestDictAll();

    //获取上传使用的 token 缓存备用
    FileUploadTool().requestUploadToken();
    //通知登录成功
    EventBusUtil.fireEvent(UserLogInEvent(UserState.Login));
    // 关联用户和推送ID
    registerPushID(JPushTool.getRegistrationID);
    return Future.value();
  }

  /// 用户退出登录时需要清除用户相关数据
  Future<void> clearUserData() async {
    //解绑推送 ID
    unbindPushID();
    // 登录后的回话信息
    await Storage.removeData(Constant.authData);
    // 用户信息
    await Storage.removeData(Constant.userResData);
    // 用户切换的养殖场记录
    await Storage.removeData(Constant.selectFarmData);
    //清除内存数据
    UserInfoTool.user = null;
    UserInfoTool.auth = null;

    //通知注销登录
    EventBusUtil.fireEvent(UserLogInEvent(UserState.Logout));
  }

  //请求用户资源数据
  Future<void> requestUserResource() async {
    try {
      //print("----------/api/user/resource--------");
      var response = await httpsClient.get("/api/user/resource");
      //缓存用户资源信息
      UserResource resourceModel = UserResource.fromJson(response);
      //写到内存中，方便使用
      UserInfoTool.user = resourceModel;

      //缓存到本地磁盘
      await Storage.setData(Constant.userResData, response);
      //
      Map? selFarm = await Storage.getData(Constant.selectFarmData);
      if (selFarm == null) {
        //没有选择过，第一次启动，记得退出登录时清除缓存
        //TODO--默认选择第一个养殖场
        if (ObjectUtil.isNotEmpty(response['farms'])) {
          List farms = response['farms'];
          Map selectedFarm = farms.first;
          Storage.setData(Constant.selectFarmData, selectedFarm);
        }
      }
      return Future.value();
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

  //请求所有字典项数据
  Future<void> requestDictAll() async {
    try {
      //print("----------/api/dic/getlabelvalues--------");
      var response = await httpsClient.get("/api/dic/getlabelvalues");
      AppDictList.dictList = response;
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

  //栋舍列表
  Future<List<CowHouse>> requestCowHouse() async {
    String farmId = '';
    //获取当前选中养殖场的 farmId
    var res = await Storage.getData(Constant.selectFarmData);
    // print('res--$res');
    if (!ObjectUtil.isEmpty(res)) {
      farmId = res['id'] ?? '';
    }
    // print('farmId--$farmId');

    //栋舍列表
    List<CowHouse> houseList = <CowHouse>[];

    //接口参数
    Map<String, dynamic> para = {
      'farmId': farmId,
    };
    List response = await httpsClient.get("/api/cowhouse/getall", queryParameters: para);
    for (var dict in response) {
      CowHouse model = CowHouse.fromJson(dict);
      houseList.add(model);
      // print('${model.name} ${model.enable} ${model.principal} ${model.isFull}');
    }
    return Future.value(houseList);
  }

  /// 请求自动生成批次号
  /// 1 犊牛
  /// 2 育肥牛
  Future<String> requestNewBatchNumber(int type) async {
    try {
      //接口参数
      Map<String, dynamic> para = {
        'type': type,
      };
      var response = await httpsClient.post("/api/batch", data: para);
      //{"code":0,"data":"YC20230919001","message":"执行成功"}
      return Future.value(response);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value('');
    }
  }

  //获取当前角色所有养殖场
  Future<List<Farm>> requestAllFarms(String farmerId) async {
    try {
      //栋舍列表
      List<Farm> farmList = <Farm>[];
      //接口参数
      Map<String, dynamic> para = {
        'farmerId': farmerId,
      };
      List response = await httpsClient.get("/api/farm/getall", queryParameters: para);
      for (var dict in response) {
        Farm model = Farm.fromJson(dict);
        farmList.add(model);
        //print('${model.name} ${model.id} ${model.address} ${model.remark}');
      }
      return Future.value(farmList);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value([]);
    }
  }

  //请求所有饲料
  Future<List<Feeds>> requestFeedStuffAll() async {
    try {
      //饲料列表
      List<Feeds> feedsList = <Feeds>[];
      var response = await httpsClient.get("/api/feedstuff/getall");
      Log.d('eedstuff/getall' + response.toString());
      for (var dict in response) {
        Feeds model = Feeds.fromJson(dict);
        feedsList.add(model);
        // print('${model.name} ${model.enable} ${model.principal} ${model.isFull}');
      }
      return Future.value(feedsList);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value([]);
    }
  }

  //请求物资
  //物资类型 1 精液 2 饲料 3 兽药 4 疫苗
  Future<List<Stock>> requestStockAll(int type) async {
    try {
      //饲料列表
      List<Stock> stockList = <Stock>[];
      var response = await httpsClient.get("/api/stock/getall", queryParameters: {'category': type});
      for (var dict in response) {
        Stock model = Stock.fromJson(dict);
        stockList.add(model);
        // print('${model.name} ${model.enable} ${model.principal} ${model.isFull}');
      }
      return Future.value(stockList);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value([]);
    }
  }

  /// 退出登录完成后解绑推送 ID
  Future<void> unbindPushID() async {
    try {
      //接口参数
      Map<String, dynamic> para = {
        'pushConfigId': Constant.pushConfigId,
        'userId': UserInfoTool.userID(),
      };
      await httpsClient.post("/api/pushsubject/unbind", data: para);
      //{"code":0,"data":"YC20230919001","message":"执行成功"}
      return Future.value(Void);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value(Void);
    }
  }

  /// 登录完成后绑定推送 ID
  Future<void> registerPushID(String registerId) async {
    if (ObjectUtil.isEmptyString(registerId)) {
      Log.d('推送 RegistrationId 为空');
      return;
    }
    try {
      //接口参数
      Map<String, dynamic> para = {
        'pushConfigId': Constant.pushConfigId,
        'userId': UserInfoTool.userID(),
        'registerId': registerId,
      };
      await httpsClient.post("/api/pushsubject/register", data: para);
      return Future.value(Void);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value(Void);
    }
  }

  //请求所有机构列表
  Future<List> requestOrgAll() async {
    try {
      String url = "/api/org/tree";
      //机构列表 [{},{}]
      var response = await httpsClient.get(url);
      return Future.value(response);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value([]);
    }
  }

  //请求所有行政区划列表
  Future<List> requestAreaAll() async {
    try {
      String url = "/api/area/tree";
      //机构列表 [{},{}]
      var response = await httpsClient.get(url);
      return Future.value(response);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return Future.value([]);
    }
  }

  //获取牛只详情
  Future<Cattle?> getCattleDetail(String cowId) async {
    try {
      var response = await httpsClient.get(
        "/api/cow/$cowId",
      );
      Cattle model = Cattle.fromJson(response);
      return Future.value(model);
    } catch (error) {
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
      return null;
    }
  }
}
