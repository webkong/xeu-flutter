import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/UIOverlay/slideTopRoute.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/user_state.dart';
import 'package:xeu/pages/baby/detail.dart';

class BabyPage extends StatefulWidget {
  BabyPage({Key key}) : super(key: key);

  @override
  _BabyPageState createState() {
    return _BabyPageState();
  }
}

class _BabyPageState extends State<BabyPage> {
  User _user;

  _init() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    var user = pres.getString('user');
    Map userMap = json.decode(user);
    setState(() {
      _user = User.fromJson(userMap);
    });
  }

  @override
  void initState() {
    super.initState();
    _init();
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
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildCard(),
            ...List.generate(_user?.babies != null ? _user.babies.length : 0,
                (int index) {
              return _buildItem(_user.babies[index]);
            }),
          ],
        ),
      ),
    );
  }

  _pushPage({data}) async {
    var _page = BabyDetailPage();
    if (data != null) {
      _page = BabyDetailPage(
        data: data,
      );
    }
    var isNew = await Navigator.push(context, SlideTopRoute(page: _page));
    print(isNew);
    if (isNew != null) {
      await _init();
    }
  }

  Widget _buildCard() {
    return Container(
      padding: EdgeInsets.all(Adapt.px(30)),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12, offset: Offset(1.0, 1.0), blurRadius: 4.0)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () async {
                _pushPage();
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.add,
                    color: Colors.black54,
                  ),
                  Text(
                    '添加宝宝',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                Toast.show('Comming soon', context);
              },
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.person_add,
                    color: Colors.black54,
                  ),
                  Text(
                    '邀请',
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(baby) {
    Baby _baby = Baby.fromJson(baby);
    return Card(
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        child: ListTile(
          leading: Container(
            decoration: ShapeDecoration(
              shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
            ),
            height: 50,
            width: 50,
            child: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(_baby?.avatar ??
                  'https://blog.webkong.cn/uploads/avatar.jpg'),
            ),
          ),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _baby.nickName,
              ),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: Text(
                  Tools.formatDate(_baby.birthday),
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                  overflow: TextOverflow.clip,
                ),
              ),
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black26,
            size: 14,
          ),
          onTap: () {
            _pushPage(data: _baby);
          },
        ),
      ),
    );
  }
}
