import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/constant.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';
import 'package:keyboard_actions/keyboard_actions.dart';

import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/main_text_field.dart';
import '../../../widgets/user_agreement.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);

  //顶部渐变色背景
  Widget _backImg() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: SizedBox(
        height: ScreenAdapter.height(290),
        width: ScreenAdapter.width(375),
        child: const LoadAssetImage(
          AssetsImages.loginBackPng,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  //页面导航
  Widget _appBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            print("Close login page");
            Get.back();
          },
          icon: LoadImage(AssetsImages.loginClosePng,
              width: ScreenAdapter.width(32), height: ScreenAdapter.width(32)),
          color: Colors.white,
        ),
      ),
    );
  }

  //账号密码
  Widget _input() {
    return Column(children: [
      MainTextField(
        prefixIcon: const LoadImage(
          AssetsImages.userInputPng,
        ),
        hintText: '请输入手机号',
        maxLength: 11,
        keyboardType: TextInputType.number,
        focusNode: controller.telNode,
        controller: controller.telController,
        onChanged: (value) {
          //print('请输入手机号:$value');
        },
      ),
      SizedBox(height: ScreenAdapter.height(10)),
      MainTextField(
        prefixIcon: const LoadImage(
          AssetsImages.passLockPng,
        ),
        hintText: '请输入密码',
        isPassword: true,
        keyboardType: TextInputType.visiblePassword,
        focusNode: controller.passNode,
        controller: controller.passController,
        onChanged: (value) {
          //print('请输入密码:$value');
        },
      ),
    ]);
  }

  //忘记密码
  Widget _forget() {
    return Container(
      alignment: Alignment.centerRight,
      child: TextButton(
          onPressed: () {
            print('忘记密码');
          },
          child: Text(
            '忘记密码?',
            style: TextStyle(
                color: SaienteColors.black4D,
                fontSize: ScreenAdapter.fontSize(14)),
          )),
    );
  }

  //页面主体
  Widget _bodyPage(context) {
    return Positioned(
      top: ScreenAdapter.getNavBarHeight(),
      // top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(10), 0, ScreenAdapter.width(10), 0),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics()),
          children: [
            //logo
            SizedBox(
              // width: ScreenAdapter.height(146),
              height: ScreenAdapter.height(146),
              child: const LoadImage(
                AssetsImages.appLogoClearPng,
                fit: BoxFit.fitHeight,
              ),
            ),
            //账号密码
            _input(),
            //忘记密码
            _forget(),
            //用户协议
            UserAgreement(
              initialValue: false, // 可以根据需要设置初始状态
              onChanged: (isChecked) {
                // 在这里处理复选框状态的变化
                print('复选框状态：$isChecked');
                controller.isAgree.value = isChecked;
              },
              agreeAction: () {
                print('同意用户协议');
              },
              privacyAction: () {
                print('同意隐私政策');
              },
            ),
            SizedBox(height: ScreenAdapter.height(20)),
            MainButton(
                text: "登录",
                onPressed: () async {
                  if (Constant.inProduction) {
                    if (!GetUtils.isPhoneNumber(
                            controller.telController.text) &&
                        controller.telController.text.length != 11) {
                      Toast.failure(msg: "请输入正确的手机号");
                      return;
                    }
                  }

                  if (controller.passController.text.length < 6) {
                    Toast.failure(msg: "密码长度不能小于6");
                    return;
                  }
                  if (controller.isAgree.value == false) {
                    Toast.failure(msg: "请同意用户协议");
                    return;
                  }
                  // Toast.show("登录成功");
                  Toast.showLoading(msg: "登录中");
                  await controller.requestLogin().then((value) async {
                    Toast.dismiss();
                    Toast.success(msg: "登录成功");
                    await Future.delayed(const Duration(seconds: 1));
                    Get.back();
                  }).catchError((err) {
                    Toast.dismiss();
                    Toast.failure(msg: err.toString());
                  });
                  // await Future.delayed(const Duration(seconds: 2));
                  // Toast.dismiss();
                  /*
                  Alert.showConfirm(
                    "二级或正文内容长文字",
                    title: '标题文字',
                    onCancel: () {
                      print("点击取消");
                    },
                    onConfirm: () {
                      print("点击确定");
                    },
                  );
                  */
                }),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // 在这里返回 false 表示禁止物理返回键事件
        return false;
      },
      child: Scaffold(
        body: KeyboardActions(
          config: controller.buildConfig(context),
          child: Container(
            width: ScreenAdapter.getScreenWidth(),
            height: ScreenAdapter.getScreenHeight(),
            color: Colors.white,
            child: Stack(
              children: [
                //顶部渐变背景
                _backImg(),
                //主体
                _bodyPage(context),
                //导航栏
                //_appBar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
