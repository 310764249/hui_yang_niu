import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intellectual_breed/app/services/colors.dart';
import 'package:intellectual_breed/app/services/screenAdapter.dart';

import '../../../models/article.dart';
import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/constant.dart';
import '../../../services/load_image.dart';
import '../controllers/about_us_controller.dart';

class AboutUsView extends GetView<AboutUsController> {
  const AboutUsView({Key? key}) : super(key: key);

  // 相关说明文章列表
  Widget instructionList() {
    return Scrollbar(
      child: ListView.builder(
        itemCount: controller.introsItems.length,
        itemBuilder: (BuildContext context, int index) {
          Article model = controller.introsItems[index];
          return InkWell(
            onTap: () {
              // 相关说明文章列表点击
              String openURL =
                  "${Constant.articleHost}/${model.type}/${model.id}";
              Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
            },
            child: Container(
              height: ScreenAdapter.height(60),
              margin: EdgeInsets.fromLTRB(
                  ScreenAdapter.height(30), 0, ScreenAdapter.height(30), 0),
              child: Column(
                children: [
                  const Spacer(),
                  Row(children: [
                    Text(
                      model.title ?? '关于',
                      style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(16),
                      ),
                    ),
                    const Spacer(),
                    const LoadAssetImage(AssetsImages.rightArrow),
                  ]),
                  const Spacer(),
                  const Divider(height: 1),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('关于软件'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(() => Stack(children: [
            Align(
              alignment: Alignment.center,
              child: Column(children: [
                SizedBox(height: ScreenAdapter.height(50)),
                ClipRRect(
                  borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
                  child: LoadAssetImage(
                    AssetsImages.appLogoPng,
                    fit: BoxFit.contain,
                    width: ScreenAdapter.width(120),
                    height: ScreenAdapter.width(120),
                  ),
                ),
                SizedBox(height: ScreenAdapter.height(10)),
                Text(controller.versionStr.value,
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(18),
                      color: SaienteColors.gray66,
                    )),
                SizedBox(height: ScreenAdapter.height(10)),
                Text(controller.nameStr.value,
                    style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(22),
                      fontWeight: FontWeight.bold,
                    )),
              ]),
            ),
            Positioned(
              top: ScreenAdapter.height(260),
              bottom: ScreenAdapter.height(100),
              left: 0,
              right: 0,
              child: instructionList(),
            ),
            Positioned(
              bottom: ScreenAdapter.height(50),
              left: 0,
              right: 0,
              child: Center(
                child: Text('陕西聚信志行数据科技有限公司',
                    style: TextStyle(fontSize: ScreenAdapter.fontSize(18))),
              ),
            ),
          ])),
    );
  }
}
