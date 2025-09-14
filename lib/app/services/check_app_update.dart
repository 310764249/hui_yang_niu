import 'package:flutter/material.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/apk_update/apk_download_utils.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../models/app_update.dart';

class CheckAppUpdate {
  static Future checkUpdate() async {
    HttpsClient httpsClient = HttpsClient();
    try {
      var res = await httpsClient.get("/api/appfile/check");
      AppUpdate appUpdate = AppUpdate.fromJson(res);
      showUpdateDialog(appUpdate);
    } catch (e) {
      print(e);
    }
  }

  static Future<AppUpdate?> checkUpdateDate() async {
    HttpsClient httpsClient = HttpsClient();
    try {
      var res = await httpsClient.get("/api/appfile/check");
      AppUpdate appUpdate = AppUpdate.fromJson(res);
      return appUpdate;
    } catch (_) {}
    return null;
  }

  static Future showUpdateDialog(AppUpdate appUpdate) async {
    String? cosUrl;
    if (appUpdate.hasCosUrl) {
      cosUrl = await CheckAppUpdate.getCosUrl();
    }
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (appUpdate.buildNumber > double.parse(packageInfo.buildNumber)) {
      APKDownloadDialog.show(
        content: appUpdate.releaseNotes ?? '发现新版本',
        isForceUpdate: false,
        url: cosUrl ?? (HttpsClient.domain + appUpdate.downloadUrl),
        versionName: appUpdate.versionName,
        versionCode: appUpdate.buildNumber,
      );
    }
  }

  static Future<bool> isHasNewVersion(AppUpdate appUpdate) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    if (appUpdate.buildNumber > double.parse(packageInfo.buildNumber)) {
      return true;
    }
    return false;
  }

  static Future<String?> getCosUrl() async {
    HttpsClient httpsClient = HttpsClient();
    try {
      var res = await httpsClient.get("/api/appfile/cosdownloadurl");
      debugPrint('res: $res');
      return res;
    } catch (e) {
      debugPrint('erroe$e');
    }
    return null;
  }
}
