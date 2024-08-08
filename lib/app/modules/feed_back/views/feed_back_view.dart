import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../services/colors.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/down_arrow_button.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/page_wrapper.dart';
import '../../../widgets/picker.dart';
import '../controllers/feed_back_controller.dart';

class FeedBackView extends GetView<FeedBackController> {
  const FeedBackView({Key? key}) : super(key: key);

  // 顶部切换类型区域
  Widget _topArea(context) {
    return Obx(() => Container(
          padding: EdgeInsets.fromLTRB(ScreenAdapter.width(10),
              ScreenAdapter.height(5), ScreenAdapter.width(10), ScreenAdapter.height(5)),
          height: ScreenAdapter.height(64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              DownArrowButton(controller.curNameValue.value, () {
                Picker.showSinglePicker(
                  context,
                  controller.fkwtNameList,
                  title: '请选择问题反馈类型',
                  onConfirm: (data, position) {
                    //debugPrint(data);
                    controller.updateFKWT(data, position);
                  },
                );
              }),
            ],
          ),
        ));
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
        title: const Text('问题反馈'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: PageWrapper(
        config: controller.buildConfig(context),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              // 反馈标题
              Container(
                padding: EdgeInsets.only(
                    left: ScreenAdapter.width(10),
                    right: ScreenAdapter.width(2)),
                margin: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(12),
                    ScreenAdapter.height(10),
                    ScreenAdapter.width(12),
                    ScreenAdapter.height(10)),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: TextField(
                    controller: controller.titleController,
                    focusNode: controller.titleNode,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        color: SaienteColors.blackB2),
                    decoration: const InputDecoration(
                      hintText: '请输入反馈标题',
                      // counterText: '', // 禁用默认的计数器文本
                      border: InputBorder.none, //移除边框
                      // contentPadding: const EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
                    )),
              ),
              //筛选类型
              _topArea(context),
              // 反馈内容
              Container(
                padding: EdgeInsets.only(
                    left: ScreenAdapter.width(10),
                    right: ScreenAdapter.width(2)),
                margin: EdgeInsets.fromLTRB(
                    ScreenAdapter.width(12),
                    ScreenAdapter.height(10),
                    ScreenAdapter.width(12),
                    ScreenAdapter.height(10)),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: TextField(
                    controller: controller.inputController,
                    focusNode: controller.inputNode,
                    maxLines: 6,
                    maxLength: 200,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        color: SaienteColors.blackB2),
                    decoration: const InputDecoration(
                      hintText: '请输入反馈内容',
                      // counterText: '', // 禁用默认的计数器文本
                      border: InputBorder.none, //移除边框
                      // contentPadding: const EdgeInsets.all(0), //输入文字偏下的问题，移除默认偏移
                    )),
              ),
              //底部确认按钮
              _commitButton(),
            ]),
      ),
    );
  }
}
