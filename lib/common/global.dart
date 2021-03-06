import 'dart:convert';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/common/utils/sqflite.dart';

class Global {
  // 每次登录检查登录状态
  check() async {
    bool enable = false;
    String token = await Memory.get('token') ?? await DB().query('token');
    String uid = await Memory.get('u_id') ?? await DB().query('u_id');

    if (token != null && uid != null) {
      await Http.setAuthorization(token);
      await Global.initMemory(login: {'token': token, 'u_id': uid});
      enable = true;
    }
    logger.info(token);
    logger.info(uid);
    return enable;
  }

  static clear() async {
    await Memory.clear();
    await DB().clear();
  }

  // 设置内存
  static initMemory({Map login, User user}) async {
    if (login != null) {
      var res = await Memory.insert('token', login['token']);
      logger.info(res);
      var res2 = await Memory.insert('u_id', login['u_id']);
      logger.info(res2);
    }
    if (user != null) {
      await Memory.insert('user', json.encode(user));
      await Memory.insert('babies', json.encode(user.babies));
    }
  }

  // 设置数据库数据
  static initLocalDB({Map login, User user}) async {
    if (login != null) {
      await DB().update('token', login['token']);
      await DB().update('u_id', login['_id']);
    }
//    if (user != null) {
//      await DB().update('user', json.encode(user));
//      await DB().update('babies', json.encode(user.babies));
//    }
  }

  // 存储登陆信息
  static flashLoginData({Map login}) async {
    print('flash data : ');
    print(login.toString());
    await initMemory(login: login);
    await initLocalDB(login: login);
  }
}
