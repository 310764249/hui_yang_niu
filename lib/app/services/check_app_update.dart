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
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      if (appUpdate.buildNumber > double.parse(packageInfo.buildNumber)) {
        APKDownloadDialog.show(
            content: appUpdate.releaseNotes ?? '发现新版本',
            isForceUpdate: true,
            url: appUpdate.downloadUrl,
            versionName: appUpdate.versionName,
            versionCode: appUpdate.buildNumber);
      }
    } catch (e) {
      print(e);
    }
  }
}
