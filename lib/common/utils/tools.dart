import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:intl/intl.dart';

class Tools {
  static String formatDate(num timestamp, {String format = 'yyyy-MM-dd'}) {
    var formatExp = new DateFormat(format);
    return formatExp.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static int formatToUtt(String str) {
    return DateTime.parse(str).millisecondsSinceEpoch;
  }

  static String nowFormat({String format = 'yyyy-MM-dd'}) {
    var formatExp = new DateFormat(format);
    return formatExp.format(new DateTime.now());
  }

  static double getMouth(num startTimestamp, num timestamp) {
    var d = DateTime.fromMillisecondsSinceEpoch(timestamp)
        .difference(new DateTime.fromMillisecondsSinceEpoch(startTimestamp))
        .inDays;

    return d / 30;
  }

  ///Generate MD5 hash
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
  // 判断 response.statusCode == 200 || response.statusCode == 201 的简写

  static bool g(List list, dynamic value) {
    return list.indexOf(value) > -1;
  }

  /// 200 201
  static bool g2(dynamic value) {
    return [200, 201].indexOf(value) > -1;
  }

  /// 400 404
  static bool g4(dynamic value) {
    return [400, 404].indexOf(value) > -1;
  }
}
