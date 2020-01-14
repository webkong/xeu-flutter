import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/baby.dart';

class UserModel with ChangeNotifier {
  bool _hasNew = false;
  User user = User();
  List babies = [];
  bool get() => _hasNew;

  void addBaby(item) {
    _hasNew = true;
    notifyListeners();
  }

  void init() {
    _hasNew = false;
  }

  getUser() {
    return this.user;
  }

  getBabies() {
    return this.user?.babies ?? [];
  }
  setUser(User user) async {
    this.user = user;
    notifyListeners();
  }
  getDefaultBaby() {
    List babies = this.getBabies();
    if (babies.length == 0) {
      return Baby();
    }
    int _index = 0;
    User user = this.user;
    if (user.defaultBaby != null) {
      _index = babies.indexWhere((baby) => baby['_id'] == user.defaultBaby);
    }
    return Baby.fromJson(babies[_index]);
  }

  fetchUserInfo(context) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var res = await Http().get(context, '/user/info', {"u_id": uid});
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      this.setUser(data);
      await Global.flashData(data);
      return true;
    } else {
      Toast.show('服务器繁忙', context, duration: 10000);
    }
  }

  logout(context) async {
    await Global.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
