import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import './common/global.dart';
import './pages/user/index.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    Global(context).check();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('学源'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 26,
              ),
              onPressed: () {
//            Navigator.pushNamed(context, '/user');
                Navigator.push(context,
                    CupertinoPageRoute(builder: (context) => UserPage()));
              })
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(top: 30.0),
        height: 400.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: <Widget>[
                new Item(
                  ui: {'bg': 'assets/images/01.png', 'text': '成长记录'},
                  route: '/group',
                ),
                new Item(
                  ui: {'bg': 'assets/images/02.png', 'text': '益智游戏'},
                  route: '/game',
                ),
              ],
            ),
            Row(
              children: <Widget>[
                new Item(
                  ui: {'bg': 'assets/images/01.png', 'text': '成长记录'},
                  route: '/signup',
                ),
                new Item(
                  ui: {'bg': 'assets/images/02.png', 'text': '益智游戏'},
                  route: '/signup',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class Item extends StatelessWidget {
  Item({Key key, this.ui = const {'bg': '', 'text': ''}, this.route})
      : super(key: key);
  final Map ui;
  final String route;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(context, this.route),
        child: Column(
          children: <Widget>[
            Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  image:
                      DecorationImage(image: ExactAssetImage(this.ui['bg']))),
            ),
            Text(this.ui['text']),
          ],
        ),
      ),
    );
  }
}
