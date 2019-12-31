import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xeu/common/global.dart';
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
    Global(context).check();
  }

  List<CardData> cardMap = [
    new CardData('assets/images/01.png', '成长记录', '/group'),
    new CardData('assets/images/02.png', '益智游戏', '/game'),
    new CardData('assets/images/01.png', '成长记录', '/group'),
    new CardData('assets/images/01.png', '成长记录', '/group'),
  ];

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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              _createCard(context, cardMap[0]),
              _createCard(context, cardMap[1]),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _createCard(BuildContext context, CardData data) {
  return Container(
//    elevation: 10.0,
    margin: EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
    child: GestureDetector(
      onTap: () => Navigator.pushNamed(context, data.route),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
//          Stack(
//            alignment: FractionalOffset(0.5, 0.5),
//            children: <Widget>[
//              Container(
//                height: Adapt.px(300),
//                width: Adapt.px(660),
//                child: Opacity(
//                  opacity: 0.8,
//                  child: Image.asset(
//                    data.image,
//                    fit: BoxFit.cover,
//                  ),
//                ),
//              ),
//              Text(
//                data.text,
//                style: TextStyle(
//                  fontSize: 28.0,
//                  color: Theme.of(context).accentColor,
//                  fontWeight: FontWeight.bold,
//                ),
//              ),
//            ],
//          ),
          Container(
            height: Adapt.px(300),
            width: Adapt.px(660),
            child: Center(
              child: Text(
                data.text,
                style: TextStyle(
                  fontSize: 30.0,
                  color: Theme.of(context).accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
//              color: const Color(0xff7c94b6),
              image: DecorationImage(
                  fit: BoxFit.cover,
                  colorFilter: new ColorFilter.mode(
                      Colors.black38.withOpacity(0.3), BlendMode.srcOver),
                  image: ExactAssetImage(data.image)),
            ),
          ),
        ],
      ),
    ),
  );
}

class CardData {
  final String image;
  final String text;
  final String route;

  CardData(this.image, this.text, this.route);
}
