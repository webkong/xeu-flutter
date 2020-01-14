import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/models/user/user_state.dart';
import 'package:xeu/pages/baby/detail.dart';
import 'package:xeu/pages/baby/index.dart';
import 'package:xeu/pages/group/sub_memorabilia_detail.dart';
import 'package:xeu/UIOverlay/index.dart';
import 'package:xeu/home.dart';
import 'package:xeu/pages/group/index.dart';
import 'package:xeu/pages/login/index.dart';
import 'package:xeu/pages/login/register.dart';
import 'package:xeu/pages/user/index.dart';
import 'package:xeu/signup.dart';

void main() {
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(CustomSystemUiOverlayStyle.dark);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MemorabiliaModel()),
        ChangeNotifierProvider(create: (_) => RecordModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: Consumer3(
        builder: (BuildContext context, MemorabiliaModel memorabiliaModel, RecordModel recordModel, UserModel userModel, _) {
          return MaterialApp(
            title: 'xeu',
            theme: ThemeData(
              primarySwatch: Colors.amber,
              appBarTheme: AppBarTheme(),
              pageTransitionsTheme: PageTransitionsTheme(
                  builders: <TargetPlatform, PageTransitionsBuilder>{
                    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                    TargetPlatform.iOS: CupertinoPageTransitionsBuilder()
                  }),
            ),
            // MaterialApp contains our top-level Navigator
            initialRoute: '/login',
            routes: {
              '/register': (BuildContext context) => RegisterPage(),
              '/forget': (BuildContext context) => RegisterPage(
                    type: 'forget',
                  ),
              '/login': (BuildContext context) => LoginPage(),
              //用户页面
              '/user': (BuildContext context) => UserPage(),
               //宝宝
              '/baby':(BuildContext context) => BabyPage(),
              '/babyDetail':(BuildContext context) => BabyDetailPage(),
              //首页
              '/home': (BuildContext context) => HomePage(),
              //成长记录
              '/group': (BuildContext context) => GroupPage(),
              '/memorabiliaDetail': (BuildContext context) => MemorabiliaDetail(),
              '/test': (BuildContext context) => SignUpPage(),
            },
          );
        },
      ),
    );
  }
}
