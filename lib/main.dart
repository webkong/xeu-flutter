import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/pages/group/sub_memorabilia_detail.dart';
import 'package:xeu/UIOverlay/index.dart';
import 'package:xeu/signup.dart';
import 'package:xeu/home.dart';
import 'package:xeu/pages/group/index.dart';
import 'package:xeu/pages/login/index.dart';
import 'package:xeu/pages/login/register.dart';
import 'package:xeu/pages/user/index.dart';

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
      ],
      child: Consumer(
        builder: (BuildContext context, MemorabiliaModel memorabiliaUploadList, _) {
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
            initialRoute: '/home',
            routes: {
              '/register': (BuildContext context) => RegisterPage(),
              '/forget': (BuildContext context) => RegisterPage(
                    type: 'forget',
                  ),
              '/login': (BuildContext context) => LoginPage(),
              '/user': (BuildContext context) => UserPage(),
              '/home': (BuildContext context) => HomePage(),
              '/group': (BuildContext context) => GroupPage(),
              '/memorabiliaDetail': (BuildContext context) => MemorabiliaDetail(),
              '/signup': (BuildContext context) => SignUpPage(),
            },
          );
        },
      ),
    );
  }
}
