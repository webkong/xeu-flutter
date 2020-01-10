import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/pages/group/index.dart';
import 'package:xeu/pages/user/index.dart';
import 'common/utils/adapt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Global.check(context);
  }

  int _selectedIndex = 0;

  static  List<Widget>_pages = [
    GroupPage(),
    UserPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Adapt.init(context);
    print(_pages);
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).accentColor,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.face),
            title: Text('Baby'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            title: Text('Me'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

}
