import 'package:flutter/material.dart';
import 'package:flutter_app/group/new_record.dart';
import './signup.dart';
import './home.dart';
import './group/index.dart';
void main() => runApp(MyApp());

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
        '/': (BuildContext context) => HomePage(),
        '/group': (BuildContext context) => GroupPage(),
        '/group/new': (BuildContext context) => NewRecord(),
        '/signup': (BuildContext context) => SignUpPage(),
      },
    );
  }
}

