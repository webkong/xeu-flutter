import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/models/user/user.dart';

class Global {
  static SharedPreferences _prefs;
  check(context) async {
    _prefs = await SharedPreferences.getInstance();
    var token = _prefs.getString('token');
    if (token != null) {
      print('token $token');
    } else {
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  static clear() async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.clear();
  }

  unAuth(context) {
    Navigator.pop(context);
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/login',
      (Route<dynamic> route) => false,
    );
  }

  static initLocal(data) async {
    _prefs = await SharedPreferences.getInstance();
    if (data['token'] != null) {
      await _prefs.setString("token", data['token']);
    }
    await _prefs.setString("u_id", data['_id']);
  }

  static flashData(User data) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString('user', json.encode(data));
    await _prefs.setString('babies', json.encode(data.babies));
  }
}
