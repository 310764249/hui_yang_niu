import 'package:flutter/material.dart';
import 'package:image_pickers/image_pickers.dart';

import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

class CellImageDetail extends StatelessWidget {
  // 是否必填, 来控制是否显示红点
  final bool isRequired;
  // 标题
  final String title;
  // 可选标题, 可自定义标题Widget
  final Widget? colorTitle;
  // 内容
  final String? content;
  // 提示
  final String? hint;
  // 背景色, 默认透明
  final Color background;
  // 传入的图片列表
  final List<String> showImgs;

  const CellImageDetail({
    super.key,
    required this.isRequired,
    required this.title,
    this.colorTitle,
    this.content,
    this.hint,
    this.background = Colors.transparent,
    required this.showImgs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        height: ScreenAdapter.height(52),
        color: background,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(width: ScreenAdapter.width(12)),
            Text("*",
                style: TextStyle(
                    fontSize: ScreenAdapter.fontSize(14),
                    fontWeight: FontWeight.w700,
                    color:
                        isRequired ? Colors.red : Colors.transparent)),
            colorTitle ??
                Text(title,
                    style: TextStyle(
                        fontSize: ScreenAdapter.fontSize(14),
                        fontWeight: FontWeight.w500,
                        color: SaienteColors.black80)),
            // 内容文字, 如果content不为空, 则显示, 否则显示hint提示文字
            content != null && content!.isNotEmpty
                ? Expanded(
                    child: Text(content!,
                        style: TextStyle(
                          color: SaienteColors.blackE5,
                          fontSize: ScreenAdapter.fontSize(13),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis))
                : Expanded(
                    child: Text(hint ?? '',
                        style: TextStyle(
                          color: SaienteColors.blackE5,
                          fontSize: ScreenAdapter.fontSize(13),
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis),
                  ),

            SizedBox(width: ScreenAdapter.width(12)),
          ],
        ),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(
            ScreenAdapter.width(10), 0, ScreenAdapter.width(20), 0),
        child: GridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 1 / 1,
            crossAxisSpacing: 0,
            mainAxisSpacing: 0,
          ),
          physics: const NeverScrollableScrollPhysics(),
          itemCount: showImgs.length,
          itemBuilder: (BuildContext context, int index) {
            //
            String? imgPath = showImgs[index];
            return Stack(children: [
              Positioned(
                  top: ScreenAdapter.width(5),
                  left: ScreenAdapter.width(5),
                  right: ScreenAdapter.width(5),
                  bottom: ScreenAdapter.width(5),
                  child: InkWell(
                    onTap: () {
                      //预览图片
                      ImagePickers.previewImages(showImgs, index);
                    },
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(ScreenAdapter.width(6)),
                      child: LoadImage(
                        imgPath,
                      ),
                    ),
                  )),
            ]);
          },
        ),
      ),
    ]);
  }
}
