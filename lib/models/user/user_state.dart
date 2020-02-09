import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/baby.dart';

class UserModel with ChangeNotifier {
  static User user = User();
  Baby defaultBaby = Baby();
  static List babies = [];

  getUser() {
    return user;
  }

  getBabies() {
    return user?.babies ?? [];
  }

  setUser(User user, {notify = true}) async {
    print('set user ');
    user = user;
    if (notify) {
      notifyListeners();
    }
  }

  getDefaultBaby() {
    return this.defaultBaby;
  }

  setDefaultBaby({notify = true}) {
    print('setDefaultBaby ');
    List babies = this.getBabies();
    if (babies.length == 0) {
      print('baby defaul 0000');
      this.defaultBaby = Baby();
    } else {
      int _index = 0;
      User user = getUser();
      if (user.defaultBaby != null) {
        _index = babies.indexWhere((baby) => baby['_id'] == user.defaultBaby);
      }
      this.defaultBaby = Baby.fromJson(babies[_index]);
    }

    print(this.defaultBaby);
    print(notify);
    if (notify) {
      notifyListeners();
    }
  }

  fetchUserInfo(context, {hasBaby = false}) async {
    String uid = Memory.get('u_id');
    var res = await Http().get(context, '/user/info', {"u_id": uid});
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      this.setUser(data);
      if (hasBaby) {
        // 如果是更新宝宝信息
        this.setDefaultBaby();
      }
      await Global.initMemory(user: data);
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
