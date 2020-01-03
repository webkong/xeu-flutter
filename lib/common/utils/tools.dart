import 'package:intl/intl.dart';

class Tools {
  static String formatDate(num timestamp, {String format = 'yyyy-MM-dd'}) {
    var formatExp = new DateFormat(format);
    return formatExp.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  static double getMouth(num startTimestamp, num timestamp){
    var t = DateTime(startTimestamp).difference(new DateTime.fromMillisecondsSinceEpoch(timestamp));
    print(t);
    return 10;
  }
}
