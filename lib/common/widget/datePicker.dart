import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xeu/common/utils/tools.dart';

class DatePickerCustom {
  static Future show(context) async {
    Locale myLocale = Localizations.localeOf(context);
    var picker = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: myLocale,
    );
    print('picker ： $picker');
    if (picker != null) {
      return picker.toString();
    } else {
      return Tools.nowFormat();
    }
  }
}
