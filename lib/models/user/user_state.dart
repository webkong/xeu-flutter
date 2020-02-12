import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/baby.dart';

class UserModel with ChangeNotifier {
  User user = User();
  Baby defaultBaby = Baby();
  List babies = [];

  getUser() {
    return this.user;
  }

  getBabies() {
    return this.user?.babies ?? [];
  }

  setUser(User user, {notify = true}) async {
    print('set user ');
    logger.info(user.toJson());
    this.user = user;
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
    //将默认baby放到内存
    Memory.insert('b_id', this.defaultBaby.bid);
    if (notify) {
      notifyListeners();
    }
  }

  fetchUserInfo({hasBaby = false}) async {
//    String uid = await Memory.get('u_id');
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String uid = _prefs.getString('u_id');
    logger.info(uid);

    var res = await Http().get('/user/info', {"u_id": uid});

    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      await this.setUser(data);
      if (hasBaby) {
        // 如果是更新宝宝信息
        this.setDefaultBaby();
      }
      await Global.initMemory(user: data);
      return true;
    } else {
      showToast('服务器繁忙', duration: Duration(seconds: 10));
    }
  }

  logout(context) async {
    await Global.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
