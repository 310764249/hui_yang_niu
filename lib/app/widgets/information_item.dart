import 'package:flutter/material.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

class InformationItem extends StatelessWidget {
  ///文章标题
  final String title;

  ///图片
  final String image;

  ///用户头像
  final String userIcon;

  ///用户昵称
  final String userName;

  ///是否是视频类型，多添加一个播放按钮
  final bool? isVideo;

  ///点击事件
  final VoidCallback? onPressed;

  const InformationItem(
      {super.key,
      required this.image,
      required this.title,
      required this.userIcon,
      required this.userName,
      this.isVideo = false,
      required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.fromLTRB(0, 0, ScreenAdapter.width(10), ScreenAdapter.width(10)),
        child: InkWell(
          onTap: onPressed,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(ScreenAdapter.width(10)),
            child: Container(
              width: ScreenAdapter.width(147),
              decoration: const BoxDecoration(
                color: Colors.white, //
                boxShadow: [
                  BoxShadow(
                    color: Color(0x0D000000),
                    spreadRadius: 0,
                    blurRadius: 5,
                    offset: Offset(0, 2), // 阴影偏移量
                  ),
                ],
              ),
              child: Column(children: [
                Stack(
                  children: [
                    LoadImage(
                      image,
                      holderImg: AssetsImages.placeholderCattle,
                      fit: BoxFit.cover,
                      // width: ScreenAdapter.width(147),
                      height: ScreenAdapter.height(111),
                    ),
                    isVideo!
                        ? Positioned(
                            left: (ScreenAdapter.width(147) - ScreenAdapter.width(40)) / 2, // 计算水平居中位置
                            top: (ScreenAdapter.height(111) - ScreenAdapter.width(40)) / 2, // 计算垂直居中位置
                            child: Icon(
                              Icons.play_circle,
                              color: Colors.white,
                              size: ScreenAdapter.width(40),
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
                Expanded(
                    flex: 1,
                    child: Padding(
                      padding: EdgeInsets.all(ScreenAdapter.width(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: ScreenAdapter.fontSize(15),
                                fontWeight: FontWeight.w500,
                                color: SaienteColors.blackE5,
                              )),
                          const Spacer(),
                          Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(ScreenAdapter.width(20)),
                              child: LoadImage(
                                userIcon,
                                width: ScreenAdapter.width(20),
                                height: ScreenAdapter.width(20),
                              ),
                            ),
                            SizedBox(width: ScreenAdapter.width(5)),
                            Expanded(
                              child: Text(userName,
                                  maxLines: 1,
                                  style: TextStyle(
                                      overflow: TextOverflow.clip,
                                      fontSize: ScreenAdapter.fontSize(12),
                                      color: SaienteColors.black80,
                                      fontWeight: FontWeight.w300)),
                            )
                          ])
                        ],
                      ),
                    )),
              ]),
            ),
          ),
        ));
  }
}
