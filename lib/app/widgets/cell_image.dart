import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:intellectual_breed/app/widgets/divider_line.dart';

import '../services/AssetsImages.dart';
import '../services/colors.dart';
import '../services/load_image.dart';
import '../services/screenAdapter.dart';

class CellImage extends StatefulWidget {
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
  // 选择数量
  final int selectCount;
  // 传入的图片列表
  List<String>? showImgs;

  // 编辑事件
  final ValueChanged<List<String>>? onChanged;

  CellImage(
      {super.key,
      required this.isRequired,
      required this.title,
      this.colorTitle,
      this.hint,
      required this.selectCount,
      this.onChanged,
      this.background = Colors.transparent,
      this.content,
      this.showImgs});

  @override
  State<CellImage> createState() => _CellImageState();
}

class _CellImageState extends State<CellImage> {
  //用户已选择的图片
  late List<String?> selImgList;

  @override
  void initState() {
    super.initState();
    selImgList = [AssetsImages.imageEditPng];
  }

  @override
  Widget build(BuildContext context) {
    //用户选择的图片数组
    if (widget.showImgs != null && widget.showImgs!.isNotEmpty) {
      selImgList = widget.showImgs!;
      if (selImgList.length < widget.selectCount) {
        //不包含“新增图标”就添加到末尾
        if (!selImgList.contains(AssetsImages.imageEditPng)) {
          selImgList.add(AssetsImages.imageEditPng);
        }
      } else {
        selImgList = selImgList.sublist(0, widget.selectCount);
      }
      widget.showImgs = [];
    }

    return Column(
      children: [
        Container(
          height: ScreenAdapter.height(52),
          color: widget.background,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: ScreenAdapter.width(12)),
              Text("*",
                  style: TextStyle(
                      fontSize: ScreenAdapter.fontSize(14),
                      fontWeight: FontWeight.w700,
                      color:
                          widget.isRequired ? Colors.red : Colors.transparent)),
              widget.colorTitle ??
                  Text(widget.title,
                      style: TextStyle(
                          fontSize: ScreenAdapter.fontSize(14),
                          fontWeight: FontWeight.w500,
                          color: SaienteColors.blackE5)),
              // 内容文字, 如果content不为空, 则显示, 否则显示hint提示文字
              widget.content != null && widget.content!.isNotEmpty
                  ? Expanded(
                      child: Text(widget.content!,
                          style: TextStyle(
                            color: SaienteColors.blackE5,
                            fontSize: ScreenAdapter.fontSize(13),
                            fontWeight: FontWeight.w400,
                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis))
                  : Expanded(
                      child: Text(widget.hint ?? '',
                          style: TextStyle(
                            color: SaienteColors.black4D,
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
            itemCount: selImgList.length,
            itemBuilder: (BuildContext context, int index) {
              //
              String? imgPath = selImgList[index];
              return Stack(children: [
                Positioned(
                    top: ScreenAdapter.width(5),
                    left: ScreenAdapter.width(5),
                    right: ScreenAdapter.width(5),
                    bottom: ScreenAdapter.width(5),
                    child: InkWell(
                      onTap: () {
                        debugPrint("点击了图片按钮");
                        if (imgPath == AssetsImages.imageEditPng) {
                          ImagePickers.pickerPaths(
                                  galleryMode: GalleryMode.image,
                                  selectCount: 1,
                                  showGif: false,
                                  showCamera: true,
                                  compressSize: 500,
                                  uiConfig: UIConfig(
                                      uiThemeColor: SaienteColors.search_color),
                                  cropConfig: CropConfig(
                                      enableCrop: true, width: 1, height: 1))
                              .then((List<Media> medias) {
                            /// medias 照片路径信息 Photo path information
                            setState(() {
                              for (Media element in medias) {
                                selImgList.insert(0, element.path);
                              }
                              if (selImgList.length > widget.selectCount) {
                                selImgList.removeLast();
                              }
                              //触发回调
                              if (widget.onChanged != null) {
                                List<String> temp = List.from(selImgList);
                                if (temp.contains(AssetsImages.imageEditPng)) {
                                  temp.remove(
                                      AssetsImages.imageEditPng); //删除最后一个“新增图标”
                                }
                                widget.onChanged!(temp);
                              }
                            });
                          });
                        } else {
                          //print("点击了图片->$imgPath");
                          //预览图片
                          ImagePickers.previewImages(selImgList, index);
                          // ImagePickers.previewImage(imgPath);
                        }
                      },
                      child: ClipRRect(
                        borderRadius:
                            BorderRadius.circular(ScreenAdapter.width(6)),
                        child: LoadImage(
                          imgPath ?? AssetsImages.imageEditPng,
                        ),
                      ),
                    )),
                //
                imgPath == AssetsImages.imageEditPng
                    ? const SizedBox()
                    : Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: () {
                            debugPrint("点击了删除按钮");
                            setState(() {
                              selImgList.removeAt(index);
                              if (selImgList.length <= widget.selectCount &&
                                  !selImgList
                                      .contains(AssetsImages.imageEditPng)) {
                                selImgList.add(AssetsImages.imageEditPng);
                              }
                              //触发回调
                              if (widget.onChanged != null) {
                                List<String> temp = List.from(selImgList);
                                if (temp.contains(AssetsImages.imageEditPng)) {
                                  temp.remove(
                                      AssetsImages.imageEditPng); //删除最后一个“新增图标”
                                }
                                widget.onChanged!(temp);
                              }
                            });
                          },
                          child: const LoadAssetImage(
                            AssetsImages.imageClosePng,
                          ),
                        ),
                      )
              ]);
            },
          ),
        ),
      ],
    );
  }
}
