import 'dart:io';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';

import 'package:get/get.dart';
import 'package:intellectual_breed/app/network/file_upload.dart';
import 'package:intellectual_breed/app/routes/app_pages.dart';
import 'package:intellectual_breed/app/services/common_service.dart';
import 'package:intellectual_breed/app/widgets/alert.dart';
import 'package:intellectual_breed/app/widgets/picker.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../models/cow_house.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/constant.dart';
import '../../../services/keepAliveWrapper.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../services/storage.dart';
import '../controllers/mine_controller.dart';

class MineView extends GetView<MineController> {
  //手动绑定 MineController 注意移除 binding 中的懒加载
  @override
  final MineController controller = Get.put(MineController());

  MineView({Key? key}) : super(key: key);

  Widget _backgroundImg() {
    return const Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: LoadAssetImage(
        AssetsImages.mineBg,
        fit: BoxFit.fitWidth,
      ),
    );
    // return const Image(
    //   image: AssetImage(AssetsImages.mineBg),
    //   fit: BoxFit.fitWidth,
    // );
    // return Container(
    //   decoration: const BoxDecoration(
    //       image: DecorationImage(
    //     image: AssetImage(AssetsImages.mineBg),
    //     fit: BoxFit.fitWidth,
    //   )),
    // );
  }

  Widget _userInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // Roby-用了ListView作为页面的整体布局后, 顶部的起始位置就是从状态栏开始的, 就不需要这里的 martinTop了
        // SizedBox(height: ScreenAdapter.height(56)),
        // 头像名字信息等
        Row(
          children: [
            InkWell(
              /*
              onTap: () async {
                List<Media> _listImagePaths = await ImagePickers.pickerPaths(
                    galleryMode: GalleryMode.image,
                    selectCount: 1,
                    showGif: false,
                    showCamera: true,
                    compressSize: 1000,
                    uiConfig:
                        UIConfig(uiThemeColor: SaienteColors.search_color),
                    cropConfig:
                        CropConfig(enableCrop: true, width: 1, height: 1));

                if (_listImagePaths.isNotEmpty) {
                  controller.updateHeader(_listImagePaths.first.path);
                }
              },
              */
              child: Hero(
                tag: "avatar",
                child: Container(
                  width: ScreenAdapter.width(65),
                  height: ScreenAdapter.width(65),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: Colors.white, width: 2), // 白色边
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(ScreenAdapter.width(60)),
                    child: LoadImage(
                      controller.headerImg.value,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.nickName.value,
                  style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(20),
                      fontWeight: FontWeight.w700),
                ),
                SizedBox(height: ScreenAdapter.height(6)),
                Row(
                  children: [
                    // Chip(
                    //   label: Text(
                    //     "138****8888",
                    //     style: TextStyle(
                    //         fontSize: ScreenAdapter.fontSize(13),
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.white),
                    //   ),
                    //   backgroundColor: SaienteColors.blue66275CF3,
                    // ),
                    // SizedBox(width: ScreenAdapter.width(6)),
                    // Chip(
                    //   label: Text(
                    //     "生产部",
                    //     style: TextStyle(
                    //         fontSize: ScreenAdapter.fontSize(13),
                    //         fontWeight: FontWeight.w400,
                    //         color: Colors.white),
                    //   ),
                    //   backgroundColor: SaienteColors.blue66275CF3,
                    // ),

                    // 电话号码
                    Container(
                      height: ScreenAdapter.height(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: SaienteColors.blue66275CF3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(8), 0,
                            ScreenAdapter.width(8), 0),
                        child: Text(
                          controller.phoneNum.value,
                          style: TextStyle(
                              fontSize: ScreenAdapter.fontSize(13),
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(width: ScreenAdapter.width(6)),
                    // 所属部门
                    Container(
                      height: ScreenAdapter.height(20),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: SaienteColors.blue66275CF3,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(ScreenAdapter.width(8), 0,
                            ScreenAdapter.width(8), 0),
                        child: Text(
                          controller.deptName.value,
                          style: TextStyle(
                              fontSize: ScreenAdapter.fontSize(13),
                              fontWeight: FontWeight.w400,
                              color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            )
          ],
        )
      ],
    );
  }

  // 点赞, 收藏
  Widget _supportAndCollection() {
    return Row(children: [
      /*
      Expanded(
          child: Center(
        child: Text.rich(TextSpan(children: [
          TextSpan(
              text: "关注",
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(13),
                  fontWeight: FontWeight.w500)),
          const TextSpan(
            text: " ",
          ),
          TextSpan(
              text: "0",
              style: TextStyle(
                  fontSize: ScreenAdapter.fontSize(20),
                  fontWeight: FontWeight.w700))
        ])),
      )),
      */
      Expanded(
          child: InkWell(
        onTap: () {
          Get.toNamed(Routes.LIKE_ARTICLE_LIST, arguments: 1);
        },
        child: Center(
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: "点赞",
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(18),
                    fontWeight: FontWeight.w500)),
            const TextSpan(
              text: " ",
            ),
            TextSpan(
                text: controller.dianZhanNum.value.toString(),
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(20),
                    fontWeight: FontWeight.w700))
          ])),
        ),
      )),
      Expanded(
          child: InkWell(
        onTap: () {
          Get.toNamed(Routes.LIKE_ARTICLE_LIST, arguments: 2);
        },
        child: Center(
          child: Text.rich(TextSpan(children: [
            TextSpan(
                text: "收藏",
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(18),
                    fontWeight: FontWeight.w500)),
            const TextSpan(
              text: " ",
            ),
            TextSpan(
                text: controller.favoritesNum.value.toString(),
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(20),
                    fontWeight: FontWeight.w700))
          ])),
        ),
      )),
    ]);
  }

  Widget _cardItem(String name, String value,
      {bool smallValue = false, VoidCallback? onPressed}) {
    return Expanded(
      child: InkWell(
        onTap: onPressed,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(value,
              maxLines: 1,
              style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: ScreenAdapter.fontSize(smallValue ? 19 : 21),
                  fontWeight: FontWeight.bold)),
          Text(name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: ScreenAdapter.fontSize(12),
                  fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }

  // 农场Card
  Widget _farmCard(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        // backgroundBlendMode: BlendMode.darken,
        image: DecorationImage(
            image: AssetImage(AssetsImages.mineCardBg), fit: BoxFit.cover),
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      child: Column(
        children: [
          // 农场名称
          SizedBox(
            height: ScreenAdapter.height(51),
            child: Row(children: [
              SizedBox(width: ScreenAdapter.width(15)),
              Text(
                controller.farmName.value,
                maxLines: 1,
                style: TextStyle(
                    overflow: TextOverflow.ellipsis,
                    color: Colors.white,
                    fontSize: ScreenAdapter.fontSize(21),
                    fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  Map userRes = await Storage.getData(Constant.userResData);
                  List farms = userRes['farms'];
                  List farmNames = farms.map((item) => item['name']).toList();
                  Picker.showSinglePicker(
                    context,
                    farmNames,
                    title: '选择养殖场',
                    onConfirm: (data, position) {
                      print(data);
                      Map selectedFarm = farms[position];
                      Storage.setData(Constant.selectFarmData, selectedFarm);
                      controller.updateSelFarm();
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                      ScreenAdapter.width(10),
                      ScreenAdapter.height(5),
                      ScreenAdapter.width(8),
                      ScreenAdapter.height(5)),
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        bottomLeft: Radius.circular(20),
                      ),
                      gradient: LinearGradient(
                        colors: [Color(0xFFFFD493), Color(0xFFFFB54B)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      )),
                  child: Text(
                    '切换养殖场',
                    style: TextStyle(
                        color: const Color(0xFF9E4C00),
                        fontSize: ScreenAdapter.fontSize(12)),
                  ),
                ),
              )
            ]),
          ),

          // 农场信息
          SizedBox(
            height: ScreenAdapter.height(68),
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _cardItem('管理员', controller.principal.value, smallValue: true),
              _cardItem(
                '栋舍汇总>',
                controller.cowHouseCount.value,
                onPressed: () {
                  Get.toNamed(Routes.CATTLE_HOUSE_LIST)?.then((value) {
                    if (ObjectUtil.isEmpty(value)) {
                      return;
                    }
                    //拿到牛只数组，默认 single: true, 单选
                    List<CowHouse> list = value as List<CowHouse>;
                    //保存选中的牛只模型
                    CowHouse temp = list.first;
                    print(temp.name);
                  });
                },
              ),
              _cardItem('养牛总数', controller.cowCount.value),
              _cardItem('职工总数', controller.employeeCount.value),
            ]),
          )
        ],
      ),
    );
  }

  Widget _line() {
    return Divider(
      color: SaienteColors.separateLine,
      height: ScreenAdapter.height(0.5),
    );
  }

  Widget _actionItem(String iconPath, String title, Function() onTapEvent) {
    return InkWell(
        onTap: onTapEvent,
        child: SizedBox(
          height: ScreenAdapter.height(52),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(width: ScreenAdapter.width(9)),
            LoadAssetImage(iconPath),
            SizedBox(width: ScreenAdapter.width(6)),
            Text(
              title,
              style: TextStyle(
                  color: SaienteColors.blackE5,
                  fontSize: ScreenAdapter.fontSize(14)),
            ),
            const Spacer(),
            const LoadAssetImage(AssetsImages.rightArrow),
            SizedBox(width: ScreenAdapter.width(18)),
          ]),
        ));
  }

  Widget _actionLayout() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
      ),
      child: Column(children: [
        controller.showRecord.value
            ? _actionItem(AssetsImages.events, '备案中心', () {
                Get.toNamed(Routes.RECORD_CENTER);
              })
            : const SizedBox(),
        _line(),
        _actionItem(AssetsImages.contact, '联系我们', () {
          //Get.snackbar('提示', '联系我们', snackPosition: SnackPosition.BOTTOM);
          Alert.showActionSheet(
            ['业务热线-151xxxx5073', '技术支持-159xxxx5019'],
            title: '确定拨打客服电话？',
            onConfirm: (index) {
              if (index == 0) {
                controller.launchPhone('15129365073');
              } else {
                controller.launchPhone('15929555019');
              }
            },
          );
        }),
        _line(),
        _actionItem(AssetsImages.feedback, '问题反馈', () {
          Get.toNamed(Routes.FEED_BACK);
        }),
        _line(),
        _actionItem(AssetsImages.lock, '隐私政策', () {
          Get.snackbar('提示', '隐私政策', snackPosition: SnackPosition.BOTTOM);
        }),
        _line(),
        _actionItem(AssetsImages.about, '关于软件', () {
          Get.toNamed(Routes.ABOUT_US);
        }),
      ]),
    );
  }

  // 退出按钮
  Widget _logoutButton() {
    return InkWell(
      onTap: () {
        Alert.showConfirm(
          '确定退出登录吗?',
          onConfirm: () {
            CommonService().clearUserData();
            Toast.success(msg: '退出登录成功');
          },
        );
      },
      child: Container(
        color: Colors.white,
        height: ScreenAdapter.height(52),
        alignment: Alignment.center,
        child: Text(
          '退出登录',
          style: TextStyle(
              fontSize: ScreenAdapter.fontSize(14),
              fontWeight: FontWeight.w500,
              color: SaienteColors.blackE5),
        ),
      ),
    );
  }

  // 版本号 & 技术支持
  Widget _versionAndTechSupport() {
    return const Column(
      children: [
        Text(
          'V1.0.0',
          style: TextStyle(color: SaienteColors.black4D),
        ),
        // Text(
        //   '技术支持：西安赛恩特信息科技有限公司',
        //   style: TextStyle(color: SaienteColors.black4D),
        // )
      ],
    );
  }

  Widget _pageContent(BuildContext context) {
    return Positioned(
      top: 0, //这里保证布局从屏幕左上角开始
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
        child: GetBuilder<MineController>(
            //obx的第三种写法,为了initState方法
            init: controller,
            initState: (state) {
              debugPrint("initState 每次进入【我的】页面时触发");
              //更新用户信息
              controller.refreshPage();
            },
            builder: (controller) {
              return ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics()),
                  children: [
                    //这里留出导航栏高度
                    SizedBox(height: ScreenAdapter.getNavBarHeight()),
                    // 个人信息
                    _userInfo(),
                    SizedBox(height: ScreenAdapter.height(40)),
                    // 点赞, 收藏
                    _supportAndCollection(),
                    SizedBox(height: ScreenAdapter.height(22)),
                    // 农场Card
                    _farmCard(context),
                    SizedBox(height: ScreenAdapter.height(11)),
                    // 联系我们, 问题反馈, 隐私政策, 关于我们
                    _actionLayout(),
                    SizedBox(height: ScreenAdapter.height(11)),
                    // 退出登录
                    _logoutButton(),
                    SizedBox(height: ScreenAdapter.height(16)),
                    // 版本号 & 技术支持
                    //_versionAndTechSupport(),
                  ]);
            }),
      ),
    );
  }

  Widget _appBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Get.toNamed(Routes.USER_PROFILE);
              },
              icon: const LoadAssetImage(AssetsImages.editPng))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      _backgroundImg(),
      // Page content
      _pageContent(context),
      // App bar
      _appBar(),
    ]));
  }
}
