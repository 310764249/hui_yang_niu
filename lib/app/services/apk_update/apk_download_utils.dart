import 'package:flutter/material.dart';
import 'package:flutter_app_update/azhon_app_update.dart';
import 'package:flutter_app_update/result_model.dart' as result_model;
import 'package:flutter_app_update/result_model.dart';
import 'package:flutter_app_update/update_model.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../../network/httpsClient.dart';

class APKDownloadDialog extends StatefulWidget {
  final String content;
  final bool isForceUpdate;
  final String url;
  final String versionName;
  final int versionCode;

  const APKDownloadDialog({
    super.key,
    required this.content,
    required this.isForceUpdate,
    required this.url,
    required this.versionName,
    required this.versionCode,
  });

  static show({
    required String content,
    required bool isForceUpdate,
    required String url,
    required String versionName,
    required int versionCode,
  }) {
    SmartDialog.show(
      tag: 'APKDownloadDialog',
      backDismiss: false,
      clickMaskDismiss: false,
      builder: (context) {
        return APKDownloadDialog(
          content: content,
          isForceUpdate: isForceUpdate,
          url: url,
          versionName: versionName,
          versionCode: versionCode,
        );
      },
    );
  }

  static void hide() {
    SmartDialog.dismiss(tag: 'APKDownloadDialog');
  }

  @override
  _APKDownloadDialogState createState() => _APKDownloadDialogState();
}

class _APKDownloadDialogState extends State<APKDownloadDialog> {
  ValueNotifier<double> progress = ValueNotifier(0.0);

  // 0: 等待下载 1: 下载中 2: 下载完成
  int resultType = 0;

  void downloadAPK() {
    UpdateModel model = UpdateModel(HttpsClient.domain + widget.url, "看比赛.apk", 'ic_launcher', '', showNotification: false);
    AzhonAppUpdate.update(model).then((value) {
      debugPrint('$value');
    });
  }

  @override
  void initState() {
    super.initState();
    AzhonAppUpdate.listener((ResultModel model) {
      if (model.type == result_model.ResultType.downloading && resultType != 1) {
        setState(() => resultType = 1);
      }
      if (model.type == result_model.ResultType.done && resultType != 2) {
        setState(() => resultType = 2);
      }

      if (model.max != null && model.progress != null) {
        progress.value = model.progress! / model.max!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    const Text(
                      '发现新版本  ',
                      style: TextStyle(
                        color: Color(0xff333333),
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'V${widget.versionName}',
                      style: const TextStyle(
                        color: Color(0xff333333),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18).copyWith(bottom: 22),
            child: Text(
              widget.content,
              style: const TextStyle(
                color: Color(0xff181829),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ValueListenableBuilder(
              valueListenable: progress,
              builder: (context, value, child) {
                if (value == 0) {
                  return const SizedBox();
                }
                return Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xff999999),
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: value,
                          child: Container(
                            height: 5,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xffE44554), Color(0xff6040FF)],
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Text(
                      '${(value * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(color: Color(0xff181829), fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ],
                );
              },
            ),
          ),
          SizedBox(
            height: 1,
            width: double.infinity,
            child: Divider(color: Colors.black.withOpacity(0.05)),
          ),
          if (resultType == 0)
            Row(
              children: [
                if (!widget.isForceUpdate)
                  Expanded(
                      child: GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      APKDownloadDialog.hide();
                    },
                    child: Container(
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12),
                        ),
                      ),
                      child: const Center(
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: Color(0xff181829),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  )),
                if (!widget.isForceUpdate)
                  SizedBox(
                    width: 1,
                    height: 18,
                    child: VerticalDivider(
                      color: Colors.black.withOpacity(0.05),
                    ),
                  ),
                Expanded(
                    child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: downloadAPK,
                  child: Container(
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: ShaderMask(
                        shaderCallback: (Rect bounds) {
                          return const LinearGradient(colors: [Color(0xffE44554), Color(0xff6040FF)]).createShader(bounds);
                        },
                        child: const Text(
                          '立即体验',
                          style: TextStyle(
                            color: Color(0xff333333),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
              ],
            )
        ],
      ),
    );
  }
}
