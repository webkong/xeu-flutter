import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  Global(context) {
    this.context = context;
  }
  BuildContext context;
  static SharedPreferences _prefs;

  check() async {
    _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    if (token != null) {

    }else{
      Navigator.pushReplacementNamed(context, '/login');
    }
  }
}
