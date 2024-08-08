import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../models/common_data.dart';

class Constant {
  /// App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool inProduction = false; //kReleaseMode; ///这个值在自己调试时设置成false, 在发包的时候设置成true

  //auth
  static const String clientId = 'angular.security';
  static const String clientSecret = 'angular.P@ssw0rd_1@3\$5^';
  static const int grantType = 3;

  static const String authData = 'authData';
  static const String userResData = 'userResData';
  static const String selectFarmData = 'selectFarmData';

  //推送相关-业务接口使用
  static const String pushConfigId = '293bdfd1-6965-11ee-b2e0-0242ac110002';
  //极光推送 appKey
  static const String JPushAppKey = '262b2270982f4bc64145de1c';
  //百度地图 iOS AK
  static const String iOSMapAK = 'qENe98kBkABWijta2v9YjUs2LgGU3jg3';
  //百度地图 Android AK
  static const String AndroidMapAK = 'D4UBmglkui271YCQWIMoxuiTk8LfrOSl';

  //文章详情基地址
  // static const String articleHost = 'http://nxbreedcms.sdyihewan.com/#/details'; // 正式环境
  // static const String articleHost = 'http://breedcms.sdyihewan.com/#/details'; //测试环境
  // static const String articleHost = 'http://154.8.193.14:1235/#/details'; // 正式环境
  static const String articleHost = 'http://154.8.193.14:1237/#/details'; //测试环境

  //文件上传相关
  static const String uploadTokenUrl =
      'https://id.banggongshe.cn/connect/token';
  static const String upClientId = 'toink_security_api_empty';
  static const String upClientSecret =
      'aXFw1+V9DMuJg6K8nIWtSS5ZOAo5JIiGULXH6VOfm5A=';
  static const String upGrantType = 'client_credentials';
  static const String upScope = 'toink_security_api toink_wechat_access_api';
  static const String upAccessToken = 'up_access_token'; //上传使用的 token
// https://file.zbxx.info/api/file/preview?id=e4a4242f-9249-4f98-86f8-a27b043f5271
  static const String uploadFile = 'https://file.zbxx.info';
  static const String uploadFileUrl =
      'https://file.zbxx.info/api/file/preview?id=';
  static const String upProjectId = '0cbd22d8-f7ba-468b-aff9-6b16e173d825';

  //默认值、占位字符等
  static const String placeholder = '--';

  //network
  static const String code = 'code';
  static const String data = 'data';
  static const String message = 'message';

  // 网络视图库Alice用到的全局实例
  static late GlobalKey<NavigatorState>? navigatorKey;

  static const String dictList = 'dictList';

  static List<String> genderNameList = ['公牛', '母牛'];

  // "当前状态"可选项
  static List<CommonData> currentStageList = [
    CommonData(id: 1, name: '犊牛'), // Calf
    CommonData(id: 2, name: '育肥牛'), // Young cattle
    CommonData(id: 3, name: '后备牛'), // Reserve cattle
    CommonData(id: 4, name: '种牛'), // Breeding cattle
    CommonData(id: 5, name: '妊娠母牛'), // Pregnant cow
    CommonData(id: 6, name: '哺乳母牛'), // Milking cow
    CommonData(id: 7, name: '空怀母牛'), // Empty cow
  ];

  // "胎次"可选项
  static List<String> pregnancyNumList = [
    '0',
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
  ];
}
