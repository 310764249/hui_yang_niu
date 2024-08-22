import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intellectual_breed/app/services/Log.dart';
import 'package:intellectual_breed/app/widgets/toast.dart';

import '../../../models/notice.dart';
import '../../../routes/app_pages.dart';
import '../../../services/AssetsImages.dart';
import '../../../services/colors.dart';
import '../../../services/constant.dart';
import '../../../services/ex_string.dart';
import '../../../services/load_image.dart';
import '../../../services/screenAdapter.dart';
import '../../../widgets/dict_list.dart';
import '../../../widgets/divider_line.dart';
import '../../../widgets/empty_view.dart';
import '../../../widgets/refresh_header_footer.dart';
import '../controllers/message_controller.dart';

class MessageView extends GetView<MessageController> {
  //手动绑定 MineController 注意移除 binding 中的懒加载
  @override
  final MessageController controller = Get.put(MessageController());

  MessageView({Key? key}) : super(key: key);

  // 个体管理
  Widget _taskMessageEntryPoint() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        // 按钮图片
        Row(children: [
          // 生产任务
          Expanded(
              child: InkWell(
            onTap: () {
              Get.toNamed(Routes.ACTION_MESSAGE_LIST, arguments: 400);
            },
            child: const LoadAssetImage(
              AssetsImages.productionTask,
              fit: BoxFit.fitWidth,
            ),
          )),
          SizedBox(width: ScreenAdapter.width(6)),
          // 预警提醒
          Expanded(
              child: InkWell(
            onTap: () {
              // Get.toNamed(Routes.ACTION_MESSAGE_LIST, arguments: 200);
              Get.toNamed(Routes.Production_Guide, arguments: 200);
            },
            child: const LoadAssetImage(
              AssetsImages.alertTask,
              fit: BoxFit.fitWidth,
            ),
          )),
        ])
      ],
    );
  }

  // 消息展示的item
  Widget _messageItem(dynamic iconUrl, String title, String content, String time, Function() onTapEvent) {
    return InkWell(
      onTap: onTapEvent,
      child: Column(
        children: [
          SizedBox(
            height: ScreenAdapter.height(76),
            child: Row(children: [
              SizedBox(width: ScreenAdapter.width(12)),
              LoadAssetImage(
                iconUrl,
                fit: BoxFit.cover,
              ),
              SizedBox(width: ScreenAdapter.width(12)),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Text(
                        title,
                        style: TextStyle(
                            color: SaienteColors.blackE5, fontSize: ScreenAdapter.fontSize(16), fontWeight: FontWeight.w700),
                      ),
                      const Spacer(),
                      Text(
                        time.replaceFirst('T', ' '),
                        style: TextStyle(
                            color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(13), fontWeight: FontWeight.w400),
                      ),
                      SizedBox(width: ScreenAdapter.width(10)),
                    ]),
                    SizedBox(height: ScreenAdapter.height(4)),
                    Text(
                      content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: SaienteColors.black80, fontSize: ScreenAdapter.fontSize(13), fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
            ]),
          ),
          const DividerLine(),
        ],
      ),
    );
  }

  // Category 含义:
  // 101：业务通知；102：系统通知；
  // 201：未发情；202：发情未配；203：未孕检；204：未产犊；205：未淘汰；
  // 401：待查情；402：待配种；403：待孕检；404：待产犊；405：待断奶；406：待淘汰；407：待销售；408：待防疫；409：待保健；
  // 901：环境异常；902：设备故障；903：行为异常
  Widget displayNoticeItemsByCategory(Notice notice) {
    switch (notice.category) {
      case 200 || 400:
        if (notice.type == 210) {
          Log.d(notice.toJson().toString());
          return _messageItem(
              AssetsImages.alert, Notice.getEventNameByCode(notice.type ?? -1), notice.content ?? '', notice.created.orEmpty(),
              () {
            //查看指南
            String openURL = "${Constant.articleHost}/${notice.type}/${notice.articleld ?? ''}";
            Get.toNamed(Routes.INFORMATION_DETAIL, arguments: openURL);
          });
        }
        return _messageItem(
          AssetsImages.task,
          Notice.getEventNameByCode(notice.type ?? -1),
          '牛只${Notice.getItemTitle(notice)}(${AppDictList.findLabelByCode(controller.gmList, notice.gender.toString())}); 栋舍: ${notice.cowHouseName}; 事件: ${Notice.getEventNameByCode(notice.type ?? -1)};',
          notice.created.orEmpty(),
          () {
            print('*****' + notice.type.toString());
            if (notice.type == 412) {
              //待换料
              controller.goToChangeCattle(notice);
              return;
            }
            controller.getCattleDataAndGoToEventDetail(notice.type ?? -1, notice.cowId);
          },
        );
      case 300 || 500:
        return _messageItem(
          AssetsImages.alert,
          '提醒消息',
          notice.content ?? Constant.placeholder,
          notice.created.orEmpty(),
          () {
            Get.toNamed(Routes.MESSAGE_DETAIL, arguments: {
              'title': '提醒消息',
              'content': notice.content ?? Constant.placeholder,
              'time': notice.created.orEmpty()
            });
          },
        );
      default:
        return _messageItem(AssetsImages.notify, '系统通知', notice.content ?? Constant.placeholder, notice.created.orEmpty(), () {
          Get.toNamed(Routes.MESSAGE_DETAIL,
              arguments: {'title': '业务通知', 'content': notice.content ?? Constant.placeholder, 'time': notice.created.orEmpty()});
        });
    }
  }

  // 普通消息列表
  Widget _messageList() {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: EasyRefresh(
          controller: controller.refreshController,
          // 指定刷新时的头部组件
          header: CustomRefresh.refreshHeader(),
          // 指定加载时的底部组件
          footer: CustomRefresh.refreshFooter(),
          onRefresh: () async {
            //
            await controller.getMessageList();
            controller.refreshController.finishRefresh();
            controller.refreshController.resetFooter();
          },
          onLoad: () async {
            // 如果没有更多直接返回
            if (!controller.hasMore) {
              controller.refreshController.finishLoad(IndicatorResult.noMore);
              return;
            }
            // 上拉加载更多数据请求
            await controller.getMessageList(isRefresh: false);
            // 设置状态
            controller.refreshController.finishLoad(controller.hasMore ? IndicatorResult.success : IndicatorResult.noMore);
          },
          child: controller.items.isEmpty
              ? const EmptyView()
              : ListView.builder(
                  itemCount: controller.items.length,
                  itemBuilder: (BuildContext context, int index) {
                    // 更加不同的分类显示不同的item样式
                    return displayNoticeItemsByCategory(controller.items[index]);
                  },
                ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '消息',
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: GetBuilder<MessageController>(
          //obx的第三种写法,为了initState方法
          init: controller,
          initState: (state) {
            debugPrint("initState 每次进入页面时触发");
            controller.initCacheList();
            //实时获取数据
            controller.getMessageList();
          },
          builder: (controller) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                  ScreenAdapter.width(10), ScreenAdapter.height(10), ScreenAdapter.width(10), ScreenAdapter.height(0)),
              child: Column(
                  // physics: const AlwaysScrollableScrollPhysics(
                  //     parent: BouncingScrollPhysics()),
                  children: [
                    // 任务消息入口
                    _taskMessageEntryPoint(),
                    SizedBox(height: ScreenAdapter.height(6)),
                    // 普通消息列表
                    _messageList(),
                  ]),
            );
          }),
    );
  }
}
