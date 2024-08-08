import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../../models/article.dart';
import '../../../models/page_info.dart';
import '../../../network/apiException.dart';
import '../../../network/httpsClient.dart';
import '../../../services/Log.dart';
import '../../../services/common_service.dart';
import '../../../services/constant.dart';
import '../../../services/user_info_tool.dart';

class AboutUsController extends GetxController {
  HttpsClient httpsClient = HttpsClient();

  RxString versionStr = ''.obs;
  RxString nameStr = ''.obs;

  //列表
  RxList<Article> introsItems = <Article>[].obs;

  @override
  void onInit() async {
    super.onInit();

    //获取说明文档
    requestArticle();

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    print("appName: $appName");
    print("packageName: $packageName");
    print("version: $version");
    print("buildNumber: $buildNumber");

    String beta = "测试版本";
    if (Constant.inProduction) {
      beta = "";
    }

    versionStr.value = "${beta}v${version}";
    // versionStr.value = "${beta}v${version} build:${buildNumber}";
    nameStr.value = appName;
    update();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  //请求视频和文章数据
  Future<void> requestArticle() async {
    //接口参数
    Map<String, dynamic> para1 = {
      'Classify': 'syzn', //业务分类 1: 专题合集[zthj]；99:使用指南[syzn]
      'PageIndex': 1,
      'PageSize': 999,
    };
    try {
      var response =
          await httpsClient.get("/api/article", queryParameters: para1);
      //缓存登录信息
      PageInfo model = PageInfo.fromJson(response);
      //print(model.itemsCount);
      List mapList = model.list;
      List<Article> modelList = [];
      for (var item in mapList) {
        Article model = Article.fromJson(item);
        modelList.add(model);
      }
      introsItems.value = modelList;
      update();
    } catch (error) {
      // Toast.dismiss();
      if (error is ApiException) {
        // 处理 API 请求异常情况 code不为 0 的场景
        Log.d('API Exception: ${error.toString()}');
      } else {
        // HTTP 请求异常情况
        Log.d('Other Exception: $error');
      }
    }
  }
}
