/// YApi QuickType插件生成，具体参考文档:https://plugins.jetbrains.com/plugin/18847-yapi-quicktype/documentation

import 'dart:convert';

AppUpdate appUpdateFromJson(String str) => AppUpdate.fromJson(json.decode(str));

String appUpdateToJson(AppUpdate data) => json.encode(data.toJson());

class AppUpdate {
  AppUpdate({
    required this.releaseNotes,
    required this.downloadUrl,
    required this.versionName,
    required this.buildNumber,
  });

  String? releaseNotes;
  String downloadUrl;
  String versionName;
  int buildNumber;

  factory AppUpdate.fromJson(Map<dynamic, dynamic> json) => AppUpdate(
        releaseNotes: json["releaseNotes"],
        downloadUrl: json["downloadUrl"],
        versionName: json["versionName"],
        buildNumber: json["buildNumber"],
      );

  Map<dynamic, dynamic> toJson() => {
        "releaseNotes": releaseNotes,
        "downloadUrl": downloadUrl,
        "versionName": versionName,
        "buildNumber": buildNumber,
      };
}
