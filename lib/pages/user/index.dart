import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
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
    return Scaffold(
        appBar: AppBar(
          title: Text('个人中心'),
        ),
        body: Center(
          child: Column(children: <Widget>[
            Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[
                  buildUserBar(context),
                  buildItemBar(context),
                ],
              ),
            ),
            Expanded(
              child: buildLoginButton(context),
            )
          ]),
        ));
  }
}


buildItemBar(BuildContext context) {
  return Card(
    child: ListTile(
      leading: FlutterLogo(),
      title: Text('One-line with both widgets'),
      trailing: Icon(Icons.arrow_forward),
    ),
  );
}

buildUserBar(BuildContext context) {
  return Card(
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
            decoration: ShapeDecoration(
              shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
            ),
            height: 80,
            width: 80,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://blog.webkong.cn/uploads/avatar.jpg',
              ),
            ),
          ),
        ),
        GestureDetector(
          child: Row(
            children: <Widget>[
              Text(
                'Denny',
                style: TextStyle(fontSize: 24, color: Colors.black87),
              ),
              Icon(
                Icons.edit,
                size: 14,
                color: Colors.black38,
              )
            ],
          ),
          onTap: () {
            print(1111);
          },
        )
      ],
    ),
  );
}

Align buildLoginButton(BuildContext context) {
  return Align(
    child: SizedBox(
      height: 40,
      width: 200.0,
      child: RaisedButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '退出登录',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ],
        ),
        color: Colors.redAccent,
        onPressed: () async {
          SharedPreferences pres = await SharedPreferences.getInstance();
          await pres.setString("token", null);
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', (Route<dynamic> route) => false);
        },
      ),
    ),
  );
}
