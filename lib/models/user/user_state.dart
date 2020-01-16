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
  Baby defaultBaby = Baby();
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
    return this.defaultBaby;
  }

  setDefaultBaby() {
    List babies = this.getBabies();
    if (babies.length == 0) {
      print('default 00000');
      return Baby();
    }
    int _index = 0;
    User user = getUser();
    if (user.defaultBaby != null) {
      _index = babies.indexWhere((baby) => baby['_id'] == user.defaultBaby);
    }
    this.defaultBaby = Baby.fromJson(babies[_index]);
    print(this.defaultBaby);
    notifyListeners();
  }

  fetchUserInfo(context, {hasBaby = false}) async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString("u_id");
    var res = await Http().get(context, '/user/info', {"u_id": uid});
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      this.setUser(data);
      if (hasBaby) {
        this.setDefaultBaby();
      }
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
