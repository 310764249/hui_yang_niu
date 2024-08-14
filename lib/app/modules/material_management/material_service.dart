import 'package:intellectual_breed/app/network/httpsClient.dart';
import 'package:intellectual_breed/app/services/Log.dart';

class MaterialService {
  MaterialService._();

  static Future getDic(String code) async {
    HttpsClient httpsClient = HttpsClient();
    return await httpsClient.get('/api/dic/$code');
  }
}
