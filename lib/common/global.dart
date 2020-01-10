import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Global {
  static SharedPreferences _prefs;

  static check(context) async {
    _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    if (token != null) {
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  static clear() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }

  static initLocal(data) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString("token", data.token);
    await _prefs.setString("u_id", data.uid);
    await _prefs.setString('user', json.encode(data));
    await _prefs.setString('babies', json.encode(data.babies));
  }
}
