import 'package:flutter/material.dart';
import 'package:xeu/UIOverlay/slideTopRoute.dart';
import 'package:xeu/pages/baby/detail.dart';

class BabyPage extends StatefulWidget {
  BabyPage({Key key}) : super(key: key);

  @override
  _BabyPageState createState() {
    return _BabyPageState();
  }
}

class _BabyPageState extends State<BabyPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('我的宝宝'),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.add,
              size: 30.0,
            ),
            onPressed: () async {
              var page = BabyDetailPage();
              await Navigator.push(context, SlideTopRoute(page: page));
            },
          )
        ],
      ),
      body: Container(
        child: Text('baby list'),
      ),
    );
  }
}
