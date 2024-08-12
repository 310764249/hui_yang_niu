import 'package:intellectual_breed/app/models/cow_assess_model.dart';
import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';

class CowAssess {
  CowAssess._();

  static Future<CowAssessModel?> get({required String id}) async {
    HttpsClient httpsClient = HttpsClient();
    try {
      var response = await httpsClient.get(
        "/api/cow/assess/$id",
      );
      return CowAssessModel.fromJson(response);
    } catch (e) {
      Log.e(e.toString());
      return null;
    }
  }
}
