import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article.dart';
import 'package:intellectual_breed/app/modules/deviceserial/device_serial_page.dart';
import 'package:intellectual_breed/app/modules/message/views/message_view.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/widgets/information_item.dart';
import 'package:intellectual_breed/generated/assets.dart';
import 'package:intellectual_breed/route_utils/business_logger.dart';

import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/constant.dart';
import '../../../services/keepAliveWrapper.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/back_image_button.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../../mine/controllers/mine_controller.dart';
import '../controllers/home_controller.dart';

/// A finite PageView with infinite-loop behaviour.
///
/// `flutter_swiper_view` implements `loop: true` by exposing roughly two
/// billion pages to Flutter's sliver. That makes the scroll extent overflow
/// and can cause the banner subtree to be laid out repeatedly. This widget
/// keeps a small virtual range and recenters the controller at either edge,
/// so the user still gets seamless looping without an unbounded PageView.
class _LoopingBanner extends StatefulWidget {
  const _LoopingBanner({
    required this.images,
    this.loop = true,
    this.autoplayDelay = const Duration(seconds: 3),
    this.duration = const Duration(milliseconds: 300),
    this.onTap,
  });

  final List<String> images;
  final bool loop;
  final Duration autoplayDelay;
  final Duration duration;
  final ValueChanged<int>? onTap;

  @override
  State<_LoopingBanner> createState() => _LoopingBannerState();
}

class _LoopingBannerState extends State<_LoopingBanner> {
  // Keep the virtual range deliberately small. A large finite count can still
  // trip Flutter's fractional itemExtent precision assertion (for example,
  // 3000 pages x 363.52 logical pixels). The controller is recentered before
  // reaching either edge, so users still get an effectively infinite loop.
  static const int _virtualCycles = 20;

  late PageController _pageController;
  Timer? _autoplayTimer;
  int _virtualItemCount = 0;
  int _anchorPage = 0;
  int _currentIndex = 0;
  bool _isAnimating = false;
  bool _isUserDragging = false;

  int get _imageCount => widget.images.length;

  @override
  void initState() {
    super.initState();
    _createPageController();
    _startAutoplay();
  }

  void _createPageController() {
    final count = _imageCount;
    final isLooping = widget.loop && count > 1;
    _virtualItemCount = isLooping ? count * _virtualCycles : count;
    _anchorPage = isLooping ? count * (_virtualCycles ~/ 2) : 0;
    _pageController = PageController(initialPage: _anchorPage);
  }

  void _startAutoplay() {
    _autoplayTimer?.cancel();
    if (!widget.loop || _imageCount < 2) {
      return;
    }
    _autoplayTimer = Timer.periodic(widget.autoplayDelay, (_) {
      _advance();
    });
  }

  void _advance() {
    if (!mounted ||
        !_pageController.hasClients ||
        _isAnimating ||
        _isUserDragging) {
      return;
    }

    final currentPage = _pageController.page?.round() ?? _anchorPage;
    var nextPage = currentPage + 1;

    // Recenter before the finite virtual range is exhausted. The page index
    // remains equivalent modulo the real image count, so this is seamless.
    if (nextPage >= _virtualItemCount - _imageCount) {
      final realIndex = currentPage % _imageCount;
      _pageController.jumpToPage(_anchorPage + realIndex);
      nextPage = _anchorPage + realIndex + 1;
    }

    _isAnimating = true;
    _pageController
        .animateToPage(nextPage, duration: widget.duration, curve: Curves.ease)
        .whenComplete(() {
      _isAnimating = false;
    });
  }

  void _onPageChanged(int page) {
    if (_imageCount == 0) {
      return;
    }

    final realIndex = page % _imageCount;
    if (mounted && _currentIndex != realIndex) {
      setState(() {
        _currentIndex = realIndex;
      });
    }

    // Also handle a user swipe reaching either edge of the virtual range.
    if (widget.loop &&
        (page < _imageCount || page >= _virtualItemCount - _imageCount)) {
      final targetPage = _anchorPage + realIndex;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _pageController.hasClients) {
          _pageController.jumpToPage(targetPage);
        }
      });
    }
  }

  bool _imagesChanged(_LoopingBanner oldWidget) {
    if (oldWidget.images.length != widget.images.length) {
      return true;
    }
    for (var i = 0; i < widget.images.length; i++) {
      if (oldWidget.images[i] != widget.images[i]) {
        return true;
      }
    }
    return false;
  }

  @override
  void didUpdateWidget(covariant _LoopingBanner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_imagesChanged(oldWidget) || oldWidget.loop != widget.loop) {
      _autoplayTimer?.cancel();
      _pageController.dispose();
      _currentIndex = 0;
      _createPageController();
      _startAutoplay();
    } else if (oldWidget.autoplayDelay != widget.autoplayDelay) {
      _startAutoplay();
    }
  }

  @override
  void dispose() {
    _autoplayTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildPage(int page) {
    final imageIndex = page % _imageCount;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: widget.onTap == null ? null : () => widget.onTap!(imageIndex),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
        child: LoadImage(widget.images[imageIndex], fit: BoxFit.fill),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_imageCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: ScreenAdapter.width(18),
          height: ScreenAdapter.height(3),
          margin: EdgeInsets.symmetric(horizontal: ScreenAdapter.width(2)),
          decoration: BoxDecoration(
            color: index == _currentIndex ? Colors.white : Colors.white54,
            borderRadius: BorderRadius.circular(ScreenAdapter.width(2)),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_imageCount == 0) {
      return const SizedBox.shrink();
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollStartNotification &&
                notification.dragDetails != null) {
              _isUserDragging = true;
            } else if (notification is ScrollEndNotification) {
              _isUserDragging = false;
            }
            return false;
          },
          child: PageView.builder(
            controller: _pageController,
            itemCount: _virtualItemCount,
            itemBuilder: (context, page) => _buildPage(page),
            onPageChanged: _onPageChanged,
          ),
        ),
        if (_imageCount > 1)
          Positioned(
            left: 0,
            right: 0,
            bottom: ScreenAdapter.height(8),
            child: Center(child: _buildPagination()),
          ),
      ],
    );
  }
}

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  //顶部渐变色背景
  Widget _backImg() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        height: ScreenAdapter.width(375),
        width: ScreenAdapter.width(375),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF639FF7), Color(0x00D8D8D8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }

  //页面导航
  Widget _appBar(context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Obx(() {
        controller.headerImg.value;
        return AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              //debugPrint("User");
              // Get.toNamed('/login');
            },
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenAdapter.width(16)),
              child: Image.asset(
                Assets.imagesAppLogo,
                width: ScreenAdapter.width(32),
                height: ScreenAdapter.width(32),
              ),
            ),
            color: Colors.white,
          ),
          title: InkWell(
            onTap: () {
              Get.toNamed(Routes.INFORMATION_LIST);
            },
            child: Container(
              height: ScreenAdapter.height(36),
              decoration: BoxDecoration(
                // color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(
                children: [
                  GetBuilder<MineController>(
                    builder: (MineController controller) {
                      return Expanded(
                        child: Text(
                          "${controller.nickName ?? ''}，您好，欢迎回来！",
                          maxLines: 1,
                          style: TextStyle(
                            color: SaienteColors.blackE5,
                            fontSize: ScreenAdapter.fontSize(16),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          /*
        actions: [
          IconButton(
            onPressed: () {
              print("alarm");
            },
            icon: LoadImage(AssetsImages.alarmPng,
                width: ScreenAdapter.width(22),
                height: ScreenAdapter.width(22)),
            color: Colors.white,
          ),
        ],
        */
        );
      }),
    );
  }

  //_homePage 中的轮播组件
  Widget _focus() {
    return SizedBox(
      width: ScreenAdapter.getScreenWidth(),
      height: ScreenAdapter.height(150),
      child: _LoopingBanner(
        images: controller.swipList,
        loop: true,
        autoplayDelay: const Duration(seconds: 3),
        duration: const Duration(milliseconds: 300),
        onTap: (index) {
          debugPrint('banner index: $index');
        },
      ),
    );
  }

  //消息通知
  Widget _announce() {
    return Positioned(
      top: ScreenAdapter.height(140),
      left: 0,
      right: 0,
      height: ScreenAdapter.height(45),
      child: Container(
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(45),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(ScreenAdapter.width(10)),
            bottomRight: Radius.circular(ScreenAdapter.width(10)),
          ),
          gradient: const LinearGradient(
            colors: [Color(0xFFFFDF9E), Color(0xFFFFD074)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(14),
            ScreenAdapter.height(10),
            0,
            0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BackImageButton(
                text: Text(
                  "消息通知",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: ScreenAdapter.fontSize(12),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                imagePath: AssetsImages.msgTitleBackPng,
                width: ScreenAdapter.width(64),
                height: ScreenAdapter.height(20),
                onPressed: () {},
              ),
              SizedBox(width: ScreenAdapter.width(5)),
              //需要包裹 Expanded 结合 TextOverflow.ellipsis, 才有效果
              Expanded(
                child: Text(
                  "您有143积分将于9月30日过期您有143积分将于9月30日过期",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(
                    color: const Color(0xFF925927),
                    fontSize: ScreenAdapter.fontSize(13),
                  ),
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const LoadImage(AssetsImages.msgClosePng),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //分类
  Widget _mainType() {
    return Padding(
      padding: EdgeInsets.only(top: ScreenAdapter.height(10)),
      child: Container(
        width: ScreenAdapter.getScreenWidth(),
        // height: ScreenAdapter.height(90),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.INFORMATION_LIST,
                        arguments: {'category': 0, 'type': 1},
                      );
                    },
                    child: Image.asset(
                      Assets.imagesIcTechnicalClassroom,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.RECIPE);
                    },
                    child: Image.asset(
                      Assets.imagesIcFormulaDesign,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => Get.toNamed(Routes.APPLICATION),
                    child: Image.asset(
                      Assets.imagesIcProductionManagement,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.to(MessageView())?.then((_) {
                        controller.getMessageCount();
                      });
                    },
                    child: Stack(
                      children: [
                        Image.asset(
                          Assets.imagesIcTaskReminder,
                          fit: BoxFit.fill,
                          width: double.infinity,
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 0),
                            child: Obx(
                              () => Badge(
                                label: Text(
                                    "${controller.messageUnReadCount.value}"),
                                //显示到第四个消息 tab 上，同时未读消息为 0 时不显示
                                isLabelVisible:
                                    controller.messageUnReadCount.value != 0,
                                backgroundColor: Colors.red[500],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      Get.toNamed(Routes.INTELLIGENT);
                      // Toast.showLoading();
                      // if (await ChatUIKit.instance.isLoginBefore()) {
                      //   Toast.dismiss();
                      //   Get.toNamed(Routes.CHATROOM);
                      // } else {
                      //   await ChatRoomUtils.login();
                      //   if (!await ChatUIKit.instance.isLoginBefore()) {
                      //     Toast.dismiss();
                      //     return;
                      //   }
                      //   Toast.dismiss();
                      //   Get.toNamed(Routes.CHATROOM);
                      // }
                    },
                    child: Image.asset(
                      Assets.imagesIcQuestionAnswer,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const DeviceSerialPage());
                    },
                    child: Image.asset(
                      Assets.imagesIcIntelligentMonitoring,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ],
            ),
            // Row(children: [
            //   Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 1});
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const LoadImage(
            //               AssetsImages.breedingPng,
            //             ),
            //             SizedBox(height: ScreenAdapter.height(10)),
            //             Text("繁殖技术",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
            //           ],
            //         ),
            //       )),
            //   Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 2});
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const LoadImage(
            //               AssetsImages.nutritionalPng,
            //             ),
            //             SizedBox(height: ScreenAdapter.height(10)),
            //             Text("营养调控",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
            //           ],
            //         ),
            //       )),
            //   Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 3});
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const LoadImage(
            //               AssetsImages.calfPng,
            //             ),
            //             SizedBox(height: ScreenAdapter.height(10)),
            //             Text("犊牛护理",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
            //           ],
            //         ),
            //       )),
            //   Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 4});
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const LoadImage(
            //               AssetsImages.questionPng,
            //             ),
            //             SizedBox(height: ScreenAdapter.height(10)),
            //             Text("能繁300问",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
            //           ],
            //         ),
            //       )),
            //   /*
            //   Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           print("使用教程");
            //           Get.toNamed(Routes.INFORMATION_LIST,
            //               arguments: {'category': 0, 'type': 5});
            //         },
            //         child: Column(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             const LoadImage(
            //               AssetsImages.handbooksPng,
            //             ),
            //             SizedBox(height: ScreenAdapter.height(10)),
            //             Text("使用教程",
            //                 style: TextStyle(
            //                     fontWeight: FontWeight.w400,
            //                     fontSize: ScreenAdapter.fontSize(13),
            //                     color: SaienteColors.blackE5)),
            //           ],
            //         ),
            //       )),
            //       */
            // ]),
          ],
        ),
      ),
    );
  }

  //视频类目
  Widget _videoType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -2,
                  child: SvgPicture.asset(Assets.imagesIcHomeLabel),
                ),
                Text(
                  '热门推荐',
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(20),
                    color: SaienteColors.blackE5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(
                  Routes.INFORMATION_LIST,
                  arguments: {'category': 1, 'type': 0},
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                alignment: Alignment.centerRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "查看更多",
                    style: TextStyle(
                      color: SaienteColors.black80,
                      fontSize: ScreenAdapter.fontSize(12),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: SaienteColors.black80,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => SizedBox(
            height: ScreenAdapter.height(208),
            child: EasyRefresh(
              child: ListView.builder(
                itemCount: controller.videoItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Article model = controller.videoItems[index];
                  return InformationItem(
                    image:
                        '${Constant.uploadFileUrl}${model.coverImg}&poster=true',
                    title: model.title ?? '',
                    userIcon: AssetsImages.avatar,
                    userName: model.publisher ?? '',
                    isVideo: true,
                    onPressed: () {
                      String openURL = Constant.getCMS(model.type, model.id);
                      Get.toNamed(Routes.INFORMATION_DETAIL,
                          arguments: openURL);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //文章类目
  Widget _articleType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -2,
                  child: SvgPicture.asset(Assets.imagesIcHomeLabel),
                ),
                Text(
                  '最新文章',
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(20),
                    color: SaienteColors.blackE5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () {
                Get.toNamed(
                  Routes.INFORMATION_LIST,
                  arguments: {'category': 0, 'type': 0},
                );
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                alignment: Alignment.centerRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "查看更多",
                    style: TextStyle(
                      color: SaienteColors.black80,
                      fontSize: ScreenAdapter.fontSize(12),
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: SaienteColors.black80,
                    size: 12,
                  ),
                ],
              ),
            ),
          ],
        ),
        Obx(
          () => SizedBox(
            height: ScreenAdapter.height(208),
            child: EasyRefresh(
              child: ListView.builder(
                itemCount: controller.wordItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Article model = controller.wordItems[index];
                  return InformationItem(
                    image:
                        '${Constant.uploadFileUrl}${model.coverImg}&poster=true',
                    title: model.title ?? '',
                    userIcon: AssetsImages.avatar,
                    userName: model.publisher ?? '',
                    isVideo: model.type == 4,
                    onPressed: () {
                      String openURL = Constant.getCMS(model.type, model.id);
                      Get.toNamed(Routes.INFORMATION_DETAIL,
                          arguments: openURL);
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  //页面主体
  Widget _homePage() {
    return Positioned(
      top: ScreenAdapter.getStatusBarHeight() + ScreenAdapter.getNavBarHeight(),
      // top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: EasyRefresh(
        controller: controller.refreshController,
        // 指定刷新时的头部组件
        header: CustomRefresh.refreshHeader(),
        onRefresh: () async {
          try {
            await controller.refreshData();
          } finally {
            // 即使接口异常，也必须结束刷新状态，避免刷新控件一直处于 processing。
            controller.refreshController.finishRefresh();
          }
        },
        child: ListView(
          padding: EdgeInsets.all(ScreenAdapter.width(10)),
          children: [
            ConstrainedBox(
              //这里限制固定大小，保证 Stack 的大小固定
              constraints: BoxConstraints(
                minHeight: ScreenAdapter.height(150), //185
                maxHeight: ScreenAdapter.height(150), //185
              ),
              child: Stack(
                children: [
                  //消息通知
                  //_announce(),
                  //轮播图
                  _focus(),
                ],
              ),
            ),
            //分类
            _mainType(),
            SizedBox(height: ScreenAdapter.height(10)),
            // 行业资讯内容保留；按图片要求隐藏的是底部导航中的“服务”入口。
            _information(),
            //文章类目
            _articleType(),
            //视频类目
            _videoType(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeepAliveWrapper(
        child: Stack(
          children: [
            //顶部渐变背景
            _backImg(),
            //主体
            _homePage(),
            //导航栏
            _appBar(context),
          ],
        ),
      ),
    );
  }

  Widget _information() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Positioned(
                  bottom: -2,
                  child: SvgPicture.asset(Assets.imagesIcHomeLabel),
                ),
                Text(
                  '行业资讯',
                  style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(20),
                    color: SaienteColors.blackE5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  String tag = '行业资讯/活牛价格';
                  BusinessLogger.instance.logEnter(tag);
                  await Get.toNamed(
                    Routes.INFORMATION_DETAIL,
                    arguments:
                        'https://www.feedtrade.com.cn/livestock/niujiage/index.html',
                  );
                  BusinessLogger.instance.logExit(tag);
                },
                child: Image.asset(
                  Assets.imagesIcPriceLiveCattle,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  String tag = '行业资讯/饲料原料';
                  BusinessLogger.instance.logEnter(tag);
                  await Get.toNamed(
                    Routes.INFORMATION_DETAIL,
                    arguments: 'https://www.feedtrade.com.cn/index/index',
                  );
                  BusinessLogger.instance.logExit(tag);
                },
                child: Image.asset(
                  Assets.imagesIcFeedIngredient,
                  fit: BoxFit.fill,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: GestureDetector(
                onTap: () async {
                  String tag = '行业资讯/农业新闻';
                  BusinessLogger.instance.logEnter(tag);
                  Get.toNamed(
                    Routes.INFORMATION_DETAIL,
                    arguments: 'https://news.ymt.com/arg_news',
                  );
                  BusinessLogger.instance.logExit(tag);
                },
                child: Image.asset(
                  Assets.imagesIcAgriculturalNews,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
