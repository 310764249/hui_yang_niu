import 'package:logger/logger.dart';

/// Log 格式化工具类
class Log {
  static var logger = Logger();

  static t(String message) {
    logger.t(message);
  }

  static d(String message) {
    logger.d(message);
  }

  static i(String message) {
    logger.i(message);
  }

  static w(String message) {
    logger.w(message);
  }

  static e(String message) {
    logger.e(message);
  }

  static f(String message) {
    logger.f(message);
  }
}
