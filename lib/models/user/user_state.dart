import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/baby.dart';

class UserModel with ChangeNotifier {
  bool _hasNew = false;
  bool get() => _hasNew;

  void addBaby(item) {
    _hasNew = true;
    notifyListeners();
  }

  void init() {
    _hasNew = false;
  }

  getUser() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    User user = User.fromJson(json.decode(pres.getString('user')));
    return user;
  }

  getBabies() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    List babies = json.decode(pres.getString('babies')) ?? [];
    return babies;
  }

  getDefaultBaby() async {
    List babies = await this.getBabies();
    if (babies.length == 0) {
      return Baby();
    }
    int _index = 0;
    User user = await this.getUser();

    if (user.defaultBaby != null) {
      _index = babies.indexWhere((baby) => baby['_id'] == user.defaultBaby);
    }
    return Baby.fromJson(babies[_index]);
  }

  fetchUserInfo(context) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var res = await Http().get(context, '/user/info', {"u_id": uid});
    print(res);
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      await Global.flashData(data);
      notifyListeners();
    }
  }

  logout(context) async {
    await Global.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
