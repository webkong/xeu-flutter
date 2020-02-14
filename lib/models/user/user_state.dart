import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
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
    return this.babies ?? [];
  }

  setUser(User user, {notify = true}) async {
    print('set user ');
    logger.info(user.avatar);
    this.user = user;
    if (notify) {
      notifyListeners();
    }
  }

  setUserAttr(key, value, {notify = false}) async {
    if (key == 'avatar') {
      this.user.avatar = value;
    }
    if (key == 'nickName') {
      this.user.nickName = value;
    }
    logger.info(this.user.toJson());
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
      return;
    } else {
      int _index;
      User user = getUser();
      if (user.defaultBaby != null) {
        _index = babies.indexWhere((baby) => baby['_id'] == user.defaultBaby);
        this.defaultBaby = Baby.fromJson(babies[_index]);
      }
    }

    print(this.defaultBaby);
    print(notify);
    //将默认baby放到内存
    Memory.insert('b_id', this.defaultBaby.bid);
    if (notify) {
      notifyListeners();
    }
  }

  fetchUserInfo({defaultBaby = false, babies = true}) async {
    String uid = await Memory.get('u_id');
    logger.info(uid);
    var res = await Http().get('/user/info', {"u_id": uid});
    logger.info(res.data['data']);
    if (res.code == 200) {
      User data = User.fromJson(res.data['data']);
      logger.info(data.avatar);
      await this.setUser(data);
      if (babies) {
        this.babies = user.babies;
      }
      if (defaultBaby) {
        // 如果是更新宝宝信息
        await this.setDefaultBaby();
      }
      await Global.initMemory(user: data);
      return true;
    } else {
      showToast('服务器繁忙', duration: Duration(seconds: 10));
      return false;
    }
  }

  logout(context) async {
    await Global.clear();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
