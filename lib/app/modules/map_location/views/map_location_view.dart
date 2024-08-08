import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:flutter_baidu_mapapi_map/flutter_baidu_mapapi_map.dart';
import 'package:intellectual_breed/app/services/map_tools.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';
import 'package:intellectual_breed/app/widgets/empty_view.dart';

import '../../../services/colors.dart';
import '../controllers/map_location_controller.dart';

class MapLocationView extends GetView<MapLocationController> {
  const MapLocationView({Key? key}) : super(key: key);

  Widget _createAPPBarContainer() {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent, //透明导航
          systemOverlayStyle: SystemUiOverlayStyle.dark, // 更改状态栏颜色
        ));
  }

  Widget _createMapContainer() {
    return Container(
        width: double.infinity,
        height: double.infinity,
        child: BMFMapWidget(
          onBMFMapCreated: (vc) {
            controller.onBMFMapCreated(vc);
          },
          mapOptions: controller.initMapOptions(),
        ));
  }

  Widget _createInfoContainer() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Container(
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(
              ScreenAdapter.width(20), 0, ScreenAdapter.width(20), 0),
          padding: EdgeInsets.all(ScreenAdapter.width(10)),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ]),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.locationInfo.value,
                      style: TextStyle(
                        color: SaienteColors.blackE5,
                        fontSize: ScreenAdapter.fontSize(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapter.height(2),
                    ),
                    Text(
                      '纬度:${controller.latitude.value},经度:${controller.longitude.value}',
                      style: TextStyle(
                        color: SaienteColors.black80,
                        fontSize: ScreenAdapter.fontSize(15),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: ScreenAdapter.height(2),
                    ),
                    Text(
                      '提示：拖动地图后即可获取当前指针位置信息',
                      style: TextStyle(
                        color: SaienteColors.gray66,
                        fontSize: ScreenAdapter.fontSize(13),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: ScreenAdapter.width(5),
              ),
              InkWell(
                onTap: () {
                  Get.back(result: {
                    'lat': controller.latitude.value,
                    'lng': controller.longitude.value,
                    'address': controller.locationInfo.value
                  });
                },
                child: Container(
                    width: ScreenAdapter.width(80),
                    height: ScreenAdapter.width(80),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xff0066FC), Color(0xff0085FA)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "保存\n位置",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenAdapter.fontSize(18),
                          fontWeight: FontWeight.w500),
                    )),
              )
            ],
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    //安卓这里需要取出设备的像素密度
    Platform.isAndroid
        ? controller.devicePixelRatio = MediaQuery.of(context).devicePixelRatio
        : controller.devicePixelRatio = 1.0;

    return Scaffold(
        body: Obx(() => Stack(children: [
              //地图显示区域
              _createMapContainer(),
              //信息展示
              _createInfoContainer(),
              //appbar 显示返回按钮
              _createAPPBarContainer(),
            ])));
  }
}
