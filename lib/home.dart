import 'package:flutter/material.dart';
import './common/global.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Global(context).check();
    return Scaffold(
      appBar: AppBar(
        title: Text('学源'),
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
