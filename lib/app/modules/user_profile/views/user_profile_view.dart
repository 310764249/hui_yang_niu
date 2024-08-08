import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:intellectual_breed/app/services/AssetsImages.dart';
import 'package:intellectual_breed/app/services/load_image.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/cell_button.dart';
import '../../../widgets/cell_text_area.dart';
import '../../../widgets/cell_text_field.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/my_card.dart';
import '../../../widgets/page_wrapper.dart';
import '../controllers/user_profile_controller.dart';

class UserProfileView extends GetView<UserProfileController> {
  const UserProfileView({Key? key}) : super(key: key);

  //头像
  Widget _headerInfo() {
    return Center(
        child: InkWell(
      onTap: () async {
        List<Media> _listImagePaths = await ImagePickers.pickerPaths(
            galleryMode: GalleryMode.image,
            selectCount: 1,
            showGif: false,
            showCamera: true,
            compressSize: 1000,
            uiConfig: UIConfig(uiThemeColor: SaienteColors.search_color),
            cropConfig: CropConfig(enableCrop: true, width: 1, height: 1));

        if (_listImagePaths.isNotEmpty) {
          controller.updateHeader(_listImagePaths.first.path);
        }
      },
      child: Hero(
        tag: "avatar",
        child: Container(
          width: ScreenAdapter.width(120),
          height: ScreenAdapter.width(120),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white, width: 5), // 白色边
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenAdapter.width(60)),
            child: LoadImage(
              controller.iconUrl.value,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ));
  }

  //操作信息
  Widget _operationInfo(context) {
    return MyCard(children: [
      const CardTitle(title: "编辑信息"),
      CellButton(
        isRequired: true,
        title: "手机号",
        showArrow: false,
        hint: controller.phoneString.value,
      ),
      CellTextField(
        isRequired: true,
        title: '昵称',
        hint: '请输入',
        controller: controller.nameController,
        focusNode: controller.nameNode,
        onChanged: (value) {
          debugPrint(value);
        },
      ),
      CellTextArea(
        isRequired: false,
        title: "备注信息",
        hint: "请输入",
        showBottomLine: false,
        controller: controller.remarkController,
        focusNode: controller.remarkNode,
      ),
    ]);
  }

  //提交按钮
  Widget _commitButton() {
    return Padding(
      padding: EdgeInsets.all(ScreenAdapter.width(20)),
      child: MainButton(
          text: "提交",
          onPressed: () {
            controller.requestCommit();
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('用户信息'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Obx(() => PageWrapper(
            config: controller.buildConfig(context),
            child: ListView(children: [
              SizedBox(height: ScreenAdapter.height(25)),
              _headerInfo(),
              SizedBox(height: ScreenAdapter.height(10)),
              //操作信息
              _operationInfo(context),
              //提交按钮
              _commitButton(),
            ]),
          )),
    );
  }
}
