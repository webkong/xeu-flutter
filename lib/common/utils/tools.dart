import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
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
  static generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var md5 = crypto.md5;
    var digest = md5.convert(content);
    return hex.encode(digest.bytes);
  }
}
