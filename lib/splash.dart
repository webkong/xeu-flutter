import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/utils/memory.dart';
import 'package:xeu/main.dart';
import 'common/global.dart';
import 'common/utils/sqflite.dart';
import 'models/user/user.dart';
import 'models/user/user_state.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  _init() async {
    await Memory().init();
    bool enable = await Global().check(); //查看登录信息是否过期
    if (enable) {
      logger.info('拉取用户信息');
      await Provider.of<UserModel>(context, listen: false)
          .fetchUserInfo(context);
      await Future.delayed(Duration(seconds: 3));
      await Navigator.pushReplacementNamed(context, '/home');
    } else {
      await Navigator.pushNamed(context, '/login');
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
