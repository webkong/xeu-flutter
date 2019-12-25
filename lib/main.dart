import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:xeu/models/group/memorabilia_state.dart';
import 'package:xeu/pages/group/new_memorabilia.dart';
import './UIOverlay/index.dart';
import './signup.dart';
import './home.dart';
import 'pages/group/index.dart';
import 'pages/login/index.dart';
import 'pages/login/register.dart';
import 'pages/user/index.dart';

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
              '/signup': (BuildContext context) => SignUpPage(),
            },
          );
        },
      ),
    );
  }
}
