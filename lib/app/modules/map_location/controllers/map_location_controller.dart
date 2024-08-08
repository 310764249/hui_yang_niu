import 'dart:io';
import 'package:get/get.dart';

import 'package:app_settings/app_settings.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_baidu_mapapi_base/flutter_baidu_mapapi_base.dart';
import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:flutter_baidu_mapapi_search/flutter_baidu_mapapi_search.dart';
import 'package:flutter_bmflocation/flutter_bmflocation.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../widgets/alert.dart';

class MapLocationController extends GetxController {
  //传入的参数
  var argument = Get.arguments;
  //
  LocationFlutterPlugin myLocPlugin = LocationFlutterPlugin();
  BaiduLocation _locationResult = BaiduLocation();

  /// 我的位置
  BMFUserLocation? _userLocation;

  /// 定位模式
  BMFUserTrackingMode _userTrackingMode = BMFUserTrackingMode.None;

  bool _suc = false;
  late BMFMapController _myMapController;

  //是否正在加载
  RxBool isLoading = true.obs;
  //需要显示的经纬度
  RxDouble latitude = 0.0.obs;
  RxDouble longitude = 0.0.obs;
  //位置信息
  RxString locationInfo = ''.obs;
  //用于地图创建中心点
  double devicePixelRatio = 1.0;

  @override
  void onInit() {
    super.onInit();

    // 设置是否隐私政策
    myLocPlugin.setAgreePrivacy(true);
    BMFMapSDK.setAgreePrivacy(true);

    /// 动态申请定位权限
    requestPermission();

    if (Platform.isIOS) {
      /// 设置ios端ak, android端ak可以直接在清单文件中配置
      myLocPlugin.authAK(Constant.iOSMapAK);
      BMFMapSDK.setApiKeyAndCoordType(Constant.iOSMapAK, BMF_COORD_TYPE.BD09LL);

      /// iOS端鉴权结果
      myLocPlugin.getApiKeyCallback(callback: (String result) {
        String str = result;
        print('鉴权结果：$str');
      });
    } else {
      BMFMapSDK.setCoordType(BMF_COORD_TYPE.BD09LL);
    }

    ///接受定位回调
    myLocPlugin.seriesLocationCallback(callback: (BaiduLocation result) {
      updateUserLocation(result);
      myLocPlugin.stopLocation();
      //获取定位结果
      _locationResult = result;
      print('定位结果:${result.getMap()}');

      //没有传参就使用自己的定位
      if (argument != null) {
        locationFinish(
          argument!['lat'],
          argument!['lng'],
          argument!['address'],
        );
      } else {
        String address = locationInfo.value = (_locationResult.address ?? '') +
            (_locationResult.locationDetail ?? '');
        locationFinish(
          _locationResult.latitude ?? 0.0,
          _locationResult.longitude ?? 0.0,
          address,
        );
      }
    });
    //
    myLocPlugin.updateHeadingCallback(callback: (BaiduHeading heading) {
      updateUserHeading(heading);
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    //
    myLocPlugin.stopLocation();
  }

  void requestPermission() async {
    if (await Permission.location.serviceStatus.isEnabled) {
      print('isEnabled为true');
      // 申请权限
      bool hasLocationPermission = await requestLocationPermission();
      if (hasLocationPermission) {
        // 权限申请通过
        locationAction();
      } else {
        print('无定位权限');
        Alert.showConfirm(
          '无法使用地图！，请去设置中打开定位权限！',
          title: '无定位权限',
          confirm: '设置',
          onConfirm: () {
            AppSettings.openAppSettings(type: AppSettingsType.location);
          },
        );
      }
    } else {
      print('isEnabled为false');
    }
  }

  /// 申请定位权限
  /// 授予定位权限返回true， 否则返回false
  Future<bool> requestLocationPermission() async {
    //获取当前的权限
    var status = await Permission.location.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.location.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
  /*
  void _locationAction() async {
    /// android 端设置定位参数
    BaiduLocationAndroidOption anOption = BaiduLocationAndroidOption(
        coorType: 'bd09ll',
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        locationPurpose: BMFLocationPurpose.sport,
        coordType: BMFLocationCoordType.bd09ll);
    Map androidMap = anOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        BMKLocationCoordinateType: 'BMKLocationCoordinateTypeBMK09LL',
        desiredAccuracy: BMFDesiredAccuracy.best);
    Map iosMap = iosOption.getMap();

    _suc = await myLocPlugin.prepareLoc(androidMap, iosMap);
    //print('设置定位参数：$androidMap');
    //
    _startLocation();
  }
  

  /// 启动定位
  Future<void> _startLocation() async {
    print('触发定位--_startLocation');
    if (Platform.isIOS) {
      _suc = await myLocPlugin
          .singleLocation({'isReGeocode': true, 'isNetworkState': true});
    } else if (Platform.isAndroid) {
      _suc = await myLocPlugin.startLocation();
    }
  }
  */

  /// 设置地图参数
  BMFMapOptions initMapOptions() {
    double lat = 39.917215;
    double lon = 116.380341;
    //没有传参就使用自己的定位
    if (argument != null) {
      lat = argument!['lat'];
      lon = argument!['lng'];
    }
    BMFMapOptions mapOptions = BMFMapOptions(
      center: BMFCoordinate(lat, lon),
      zoomLevel: 16,
      // mapPadding: BMFEdgeInsets(top: 0, left: 0, right: 0, bottom: 0),
      compassEnabled: true,
      compassPosition: BMFPoint(10, 10),
      showMapScaleBar: true,
      logoPosition: BMFLogoPosition.LeftBottom,
    );
    return mapOptions;
  }

  /// 创建完成回调
  void onBMFMapCreated(BMFMapController controller) {
    _myMapController = controller;

    /// 地图加载回调
    _myMapController.setMapDidLoadCallback(callback: () {
      print('mapDidLoad-地图加载完成');

      ///设置定位参数
      locationAction();

      ///启动定位
      //myLocPlugin.startLocation();

      _myMapController.showUserLocation(true);
      _myMapController.setUserTrackingMode(_userTrackingMode);
    });

    /// 点中底图空白处会回调此接口
    /// coordinate 经纬度
    _myMapController.setMapOnClickedMapBlankCallback(
        callback: (BMFCoordinate coordinate) {
      // print(
      //     'mapOnClickedMapBlank-->${coordinate.latitude}--${coordinate.longitude}');
    });

    /// 地图区域改变完成后会调用此接口
    /// mapStatus 地图状态信息
    /// reason 地图改变原因
    _myMapController.setMapRegionDidChangeWithReasonCallback(callback:
        (BMFMapStatus mapStatus, BMFRegionChangeReason regionChangeReason) {
      // print(
      //     '地图区域改变完成后会调用此接口4\n mapStatus = ${mapStatus.toMap()}\n reason = ${regionChangeReason.index}');
      reverseGeoCodeSearch(
          mapStatus.targetGeoPt!.latitude, mapStatus.targetGeoPt!.longitude);
    });
  }

  ///定位完成添加mark
  void locationFinish(double lat, double lng, String address) {
    num latTitle =
        NumUtil.getNumByValueStr(lat.toString(), fractionDigits: 5) ?? 0.0;
    num lonTitle =
        NumUtil.getNumByValueStr(lng.toString(), fractionDigits: 5) ?? 0.0;
    latitude.value = latTitle.toDouble();
    longitude.value = lonTitle.toDouble();
    //
    latitude.value = lat;
    longitude.value = lng;
    locationInfo.value = address;

    update();

    ///设置中心点
    _myMapController.setCenterCoordinate(BMFCoordinate(lat, lng), true);

    /// 创建BMFMarker
    BMFMarker marker =
        createMarker('定位', 'flutter_marker', latitude.value, longitude.value);

    /// 添加Marker
    _myMapController.addMarker(marker);

    /// 拖拽marker点击回调
    // _myMapController.setMapDragMarkerCallback(callback: (BMFMarker marker,
    //     BMFMarkerDragState newState, BMFMarkerDragState oldState) {
    //   if (newState == BMFMarkerDragState.Ending) {
    //     print(
    //         '拖拽marker停止后的回调--${marker.position.latitude}--${marker.position.longitude}');
    //     reverseGeoCodeSearch(
    //         marker.position.latitude, marker.position.longitude);
    //   }
    // });
  }

  /// 创建BMFMarker
  BMFMarker createMarker(
      String? title, String identifier, double? lat, double? lng) {
    /// 创建BMFMarker
    BMFMarker marker = BMFMarker.icon(
        position: BMFCoordinate(lat ?? 0.0, lng ?? 0.0),
        title: title ?? '标题',
        identifier: identifier,
        isLockedToScreen: true,
        screenPointToLock: BMFPoint(
            ScreenAdapter.getScreenWidth() * devicePixelRatio * 0.5,
            ScreenAdapter.getScreenHeight() * devicePixelRatio * 0.5),
        icon: AssetsImages.iconMarkPng);

    /// 创建BMFMarker
    /*
    BMFMarker marker = BMFMarker.icon(
        position: BMFCoordinate(lat ?? 0.0, lng ?? 0.0),
        title: title ?? '拖动定位',
        titleOptions: BMFTitleOptions(
          text: title ?? '拖动定位',
          bgColor: Colors.white,
        ),
        identifier: identifier,
        enabled: true,
        draggable: true,
        enabled3D: true,
        selected: true,
        icon: AssetsImages.iconMarkPng);
        */
    return marker;
  }

  ///定位完成添加mark
  void reverseGeoCodeSearch(double lat, double lng) async {
    // 构造检索参数
    BMFReverseGeoCodeSearchOption reverseGeoCodeSearchOption =
        BMFReverseGeoCodeSearchOption(location: BMFCoordinate(lat, lng));
    // 检索实例
    BMFReverseGeoCodeSearch reverseGeoCodeSearch = BMFReverseGeoCodeSearch();
    // 逆地理编码回调
    reverseGeoCodeSearch.onGetReverseGeoCodeSearchResult(callback:
        (BMFReverseGeoCodeSearchResult result, BMFSearchErrorCode errorCode) {
      // print("逆地理编码  errorCode = ${errorCode}, result = ${result?.toMap()}");
      if (errorCode == BMFSearchErrorCode.NO_ERROR) {
        // 保留小数
        num latTitle = NumUtil.getNumByValueStr(
                (result.location?.latitude ?? 0.0).toString(),
                fractionDigits: 5) ??
            0.0;
        num lonTitle = NumUtil.getNumByValueStr(
                (result.location?.longitude ?? 0.0).toString(),
                fractionDigits: 5) ??
            0.0;
        // 解析result
        latitude.value = latTitle.toDouble();
        longitude.value = lonTitle.toDouble();
        //
        locationInfo.value = result.address ?? '';
        update();
      }
    });
    // 发起检索
    bool flag = await reverseGeoCodeSearch
        .reverseGeoCodeSearch(reverseGeoCodeSearchOption);
  }

  //
  void locationAction() async {
    /// 设置android端和ios端定位参数
    /// android 端设置定位参数
    /// ios 端设置定位参数
    Map iosMap = _initIOSOptions().getMap();
    Map androidMap = _initAndroidOptions().getMap();

    await myLocPlugin.prepareLoc(androidMap, iosMap);

    ///启动定位
    myLocPlugin.startLocation();
  }

  /// 设置地图参数
  BaiduLocationAndroidOption _initAndroidOptions() {
    BaiduLocationAndroidOption options = BaiduLocationAndroidOption(
        locationMode: BMFLocationMode.hightAccuracy,
        isNeedAddress: true,
        isNeedAltitude: true,
        isNeedLocationPoiList: true,
        isNeedNewVersionRgc: true,
        isNeedLocationDescribe: true,
        openGps: true,
        scanspan: 4000,
        coordType: BMFLocationCoordType.bd09ll);
    return options;
  }

  BaiduLocationIOSOption _initIOSOptions() {
    BaiduLocationIOSOption options = BaiduLocationIOSOption(
        coordType: BMFLocationCoordType.bd09ll,
        desiredAccuracy: BMFDesiredAccuracy.best,
        allowsBackgroundLocationUpdates: true,
        pausesLocationUpdatesAutomatically: false);
    return options;
  }

  void updateUserHeading(BaiduHeading heading) {
    BMFUserLocation userLocation = BMFUserLocation(
      location: _userLocation!.location,
      heading: BMFHeading.fromMap(heading.getMap()),
      title: '我的位置',
    );
    _myMapController.updateLocationData(userLocation);
  }

  /// 更新位置
  void updateUserLocation(BaiduLocation result) {
    BMFCoordinate coordinate =
        BMFCoordinate(result.latitude!, result.longitude!);
    BMFLocation location = BMFLocation(
        coordinate: coordinate,
        altitude: result.altitude,
        course: result.course,
        accuracy: result.radius,
        horizontalAccuracy: result.horizontalAccuracy,
        verticalAccuracy: result.verticalAccuracy);
    BMFUserLocation userLocation = BMFUserLocation(
      location: location,
    );
    _userLocation = userLocation;
    _myMapController.updateLocationData(_userLocation!);
  }
}
