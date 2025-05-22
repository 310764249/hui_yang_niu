import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/models/article.dart';
import 'package:intellectual_breed/app/modules/message/views/message_view.dart';
import 'package:intellectual_breed/app/modules/recipe/views/recipe_view.dart';
import 'package:intellectual_breed/app/modules/tabs/controllers/tabs_controller.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/user_info_tool.dart';
import 'package:intellectual_breed/app/widgets/information_item.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:intellectual_breed/generated/assets.dart';

import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/constant.dart';
import '../../../services/keepAliveWrapper.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/back_image_button.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../controllers/home_controller.dart';

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
        )),
      ),
    );
  }

  //页面导航
  Widget _appBar(context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Obx(
        () => AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            onPressed: () {
              //debugPrint("User");
              // Get.toNamed('/login');
            },
            icon: ClipRRect(
              borderRadius: BorderRadius.circular(ScreenAdapter.width(16)),
              child: LoadImage(controller.headerImg.value, width: ScreenAdapter.width(32), height: ScreenAdapter.width(32)),
            ),
            color: Colors.white,
          ),
          title: InkWell(
            onTap: () {
              Get.toNamed(Routes.INFORMATION_LIST);
            },
            child: Container(
              height: ScreenAdapter.height(36),
              width: ScreenAdapter.width(260),
              decoration: BoxDecoration(
                // color: const Color(0x33FFFFFF),
                borderRadius: BorderRadius.circular(32),
              ),
              child: Row(children: [
                Text("${UserInfoTool.nickName() ?? ''}，您好，欢迎回来！",
                    style: TextStyle(
                      color: SaienteColors.blackE5,
                      fontSize: ScreenAdapter.fontSize(16),
                      fontWeight: FontWeight.w500,
                    )),
              ]),
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
        ),
      ),
    );
  }

  //_homePage 中的轮播组件
  Widget _focus() {
    return SizedBox(
        width: ScreenAdapter.getScreenWidth(),
        height: ScreenAdapter.height(150),
        child: Obx(
          () => EasyRefresh(
            //这里Swiper上面的EasyRefresh只是用来包裹，没有实际作用，如果不包一下，上层的EasyRefresh会作用到下层的Swiper上
            child: Swiper(
              itemBuilder: (context, index) {
                return ClipRRect(
                  //圆角
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                  child: LoadImage(
                    controller.swipList[index],
                    fit: BoxFit.fill,
                  ),
                );
              },
              itemCount: controller.swipList.length,
              autoplay: true,
              duration: 300,
              pagination: const SwiperPagination(
                builder: SwiperPagination.rect,
                alignment: Alignment.bottomCenter,
              ),
              onTap: (index) {
                print(index);
              },
            ),
          ),
        ));
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
                bottomLeft: Radius.circular(ScreenAdapter.width(10)), bottomRight: Radius.circular(ScreenAdapter.width(10))),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFFDF9E),
                Color(0xFFFFD074),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )),
        child: Padding(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(14), ScreenAdapter.height(10), 0, 0),
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            BackImageButton(
                text: Text("消息通知",
                    style: TextStyle(color: Colors.white, fontSize: ScreenAdapter.fontSize(12), fontWeight: FontWeight.w500)),
                imagePath: AssetsImages.msgTitleBackPng,
                width: ScreenAdapter.width(64),
                height: ScreenAdapter.height(20),
                onPressed: () {}),
            SizedBox(width: ScreenAdapter.width(5)),
            //需要包裹 Expanded 结合 TextOverflow.ellipsis, 才有效果
            Expanded(
              child: Text("您有143积分将于9月30日过期您有143积分将于9月30日过期",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  style: TextStyle(color: const Color(0xFF925927), fontSize: ScreenAdapter.fontSize(13))),
            ),
            IconButton(onPressed: () {}, icon: const LoadImage(AssetsImages.msgClosePng)),
          ]),
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
                        Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 1});
                      },
                      child: Image.asset(
                        Assets.imagesIcTechnicalClassroom,
                        fit: BoxFit.fill,
                      )),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Toast.show("敬请期待");
                    },
                    child: Image.asset(
                      Assets.imagesIcQuestionAnswer,
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
                    onTap: () {
                      Get.to(RecipeView());
                    },
                    child: Image.asset(
                      Assets.imagesIcFormulaDesign,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.to(MessageView());
                    },
                    child: GetBuilder<TabsController>(
                      builder: (TabsController controller) {
                        return Stack(
                          children: [
                            Image.asset(
                              Assets.imagesIcTaskReminder,
                              fit: BoxFit.fill,
                              width: double.infinity,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 14),
                                child: Badge(
                                  label: Text("${controller.unReadMsgs}"),
                                  //显示到第四个消息 tab 上，同时未读消息为 0 时不显示
                                  isLabelVisible: (controller.unReadMsgs.value != 0) ? true : false,
                                  backgroundColor: Colors.red[500],
                                ),
                              ),
                            )
                          ],
                        );
                      },
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
                    onTap: () {
                      Toast.show("敬请期待");
                    },
                    child: Image.asset(
                      Assets.imagesIcIntelligentMonitoring,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GetBuilder<TabsController>(
                    builder: (TabsController controller) {
                      return GestureDetector(
                        onTap: () {
                          controller.currentIndex.value = 1;
                          controller.pageController.jumpToPage(1);
                        },
                        child: Image.asset(
                          Assets.imagesIcProductionManagement,
                          fit: BoxFit.fill,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Row(children: [
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 1});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadImage(
                          AssetsImages.breedingPng,
                        ),
                        SizedBox(height: ScreenAdapter.height(10)),
                        Text("繁殖技术",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 2});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadImage(
                          AssetsImages.nutritionalPng,
                        ),
                        SizedBox(height: ScreenAdapter.height(10)),
                        Text("营养调控",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 3});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadImage(
                          AssetsImages.calfPng,
                        ),
                        SizedBox(height: ScreenAdapter.height(10)),
                        Text("犊牛护理",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 0, 'type': 4});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadImage(
                          AssetsImages.questionPng,
                        ),
                        SizedBox(height: ScreenAdapter.height(10)),
                        Text("能繁300问",
                            style: TextStyle(
                                fontWeight: FontWeight.w400, fontSize: ScreenAdapter.fontSize(13), color: SaienteColors.blackE5)),
                      ],
                    ),
                  )),
              /*
              Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      print("使用教程");
                      Get.toNamed(Routes.INFORMATION_LIST,
                          arguments: {'category': 0, 'type': 5});
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LoadImage(
                          AssetsImages.handbooksPng,
                        ),
                        SizedBox(height: ScreenAdapter.height(10)),
                        Text("使用教程",
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: ScreenAdapter.fontSize(13),
                                color: SaienteColors.blackE5)),
                      ],
                    ),
                  )),
                  */
            ]),
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
                Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 1, 'type': 0});
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(0),
                ),
                alignment: Alignment.centerRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "查看更多",
                    style: TextStyle(
                        color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(12), fontWeight: FontWeight.w300),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: SaienteColors.black80,
                    size: 12,
                  )
                ],
              ))
        ]),
        SizedBox(
          height: ScreenAdapter.height(208),
          child: EasyRefresh(
            child: ListView.builder(
                itemCount: controller.videoItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Article model = controller.videoItems[index];
                  return InformationItem(
                      image: '${Constant.uploadFileUrl}${model.coverImg}&poster=true',
                      title: model.title ?? '',
                      userIcon: AssetsImages.avatar,
                      userName: model.publisher ?? '',
                      isVideo: true,
                      onPressed: () {
                        String openURL = "${Constant.articleHost}/${model.type}/${model.id}";
                        Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
                      });
                }),
          ),
        )
      ],
    );
  }

  //文章类目
  Widget _articleType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                bottom: -2,
                child: SvgPicture.asset(Assets.imagesIcHomeLabel),
              ),
              Text('热门文章',
                  style:
                      TextStyle(fontSize: ScreenAdapter.fontSize(20), color: SaienteColors.blackE5, fontWeight: FontWeight.w500)),
            ],
          ),
          TextButton(
              onPressed: () {
                Get.toNamed(Routes.INFORMATION_LIST, arguments: {'category': 2, 'type': 0});
              },
              style: ButtonStyle(
                padding: MaterialStateProperty.all(
                  const EdgeInsets.all(0),
                ),
                alignment: Alignment.centerRight,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "查看更多",
                    style: TextStyle(
                        color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(12), fontWeight: FontWeight.w300),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_outlined,
                    color: SaienteColors.black80,
                    size: 12,
                  )
                ],
              ))
        ]),
        SizedBox(
          height: ScreenAdapter.height(208),
          child: EasyRefresh(
            child: ListView.builder(
                itemCount: controller.wordItems.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  Article model = controller.wordItems[index];
                  return InformationItem(
                      image: '${Constant.uploadFileUrl}${model.coverImg}',
                      title: model.title ?? '',
                      userIcon: AssetsImages.avatar,
                      userName: model.publisher ?? '',
                      onPressed: () {
                        String openURL = "${Constant.articleHost}/${model.type}/${model.id}";
                        Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
                      });
                }),
          ),
        )
      ],
    );
  }

  //页面主体
  Widget _homePage() {
    return Obx(() => Positioned(
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
              //
              await controller.requestArticle();
              //先结束刷新状态
              controller.refreshController.finishRefresh();
            },
            child: ListView(padding: EdgeInsets.all(ScreenAdapter.width(10)), children: [
              ConstrainedBox(
                //这里限制固定大小，保证 Stack 的大小固定
                constraints: BoxConstraints(
                  minHeight: ScreenAdapter.height(150), //185
                  maxHeight: ScreenAdapter.height(150), //185
                ),
                child: Stack(children: [
                  //消息通知
                  //_announce(),
                  //轮播图
                  _focus(),
                ]),
              ),
              //分类
              _mainType(),
              SizedBox(height: ScreenAdapter.height(10)),
              //视频类目
              _videoType(),
              //文章类目
              _articleType(),
            ]),
          ),
        ));
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
}
