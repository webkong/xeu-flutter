import 'package:intl/intl.dart';

class Tools {
  static String formatDate(num timestamp, {String format = 'yyyy-MM-dd'}) {
    var formatExp = new DateFormat(format);
    return formatExp.format(new DateTime.fromMillisecondsSinceEpoch(timestamp));
  }
}
