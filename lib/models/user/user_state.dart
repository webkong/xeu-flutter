import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user.dart';

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

  getUserInfo() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var res = await Http.get('/user/info', {"u_id": uid});
    print(res);
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      await pres.setString('user', json.encode(data));
      await pres.setString('babies', json.encode(data.babies));
    }
  }
}
