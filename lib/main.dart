import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/group/new_record.dart';
import './UIOverlay/index.dart';
import './signup.dart';
import './home.dart';
import './group/index.dart';
import './login/index.dart';
import './login/register.dart';

void main(){
  runApp(MyApp());
  SystemChrome.setSystemUIOverlayStyle(CustomSystemUiOverlayStyle.dark);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Code Sample for Navigator',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // MaterialApp contains our top-level Navigator
      initialRoute: '/',
      routes: {
        '/register': (BuildContext context) => RegisterPage(),
        '/forget': (BuildContext context) => RegisterPage(type: 'forget',),
        '/': (BuildContext context) => LoginPage(),
        '/home': (BuildContext context) => HomePage(),
        '/group': (BuildContext context) => GroupPage(),
        '/group/new': (BuildContext context) => NewRecord(),
        '/signup': (BuildContext context) => SignUpPage(),
      },
    );
  }
}

