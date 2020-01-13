import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/pages/group/new_memorabilia.dart';
import 'package:xeu/pages/group/new_record.dart';
import 'package:xeu/pages/group/sub_memorabilia.dart';
import 'package:xeu/pages/group/sub_record.dart';
import 'package:xeu/UIOverlay/slideTopRoute.dart';

class GroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GroupPage();
  }
}

class _GroupPage extends State<GroupPage> with SingleTickerProviderStateMixin {
  int _index = 0;
  var page;
  Baby _baby = Baby();
  var _user;
  String _babyAvatar = Avatars.avatar;
  _new() async {
    if (_index == 0) {
      page = NewMemorabilia();
    } else {
      page = NewRecord(); //身体参数
    }
    await Navigator.push(context, SlideTopRoute(page: page));
  }

  _init() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    var _user = User.fromJson(json.decode(pres.getString('user')));
    if (_user.babies.length == 0) {
      _showTip();
    } else {
      _baby = User().getBaby(_user.babies, babyId: _user?.defaultBaby);
    }
    print(_baby.toJson());
    _babyAvatar = _baby?.avatar ?? _babyAvatar;
  }

  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
    _init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(
          padding: EdgeInsets.only(top: 10, left: 10, bottom: 10),
//          width: Adapt.px(80),
//          height: Adapt.px(80),
          child: GestureDetector(
            child: Image(
              image: AssetImage(_babyAvatar),
            ),
          ),
        ),
        title: Text('宝宝记录'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30.0,
              ),
              onPressed: () => this._new()),
        ],
        bottom: new TabBar(
          controller: _tabController,
          tabs: choices.map((Choice choice) {
            return new Tab(
              text: choice.title,
//              icon: new Icon(choice.icon),
            );
          }).toList(),
          onTap: (index) {
            _index = index;
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: new TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), //TODO:禁止左右滑动
        children: choices.map(
          (Choice choice) {
            return new Padding(
                padding: const EdgeInsets.all(8.0), child: choicePage(choice));
          },
        ).toList(),
      ),
    );
  }

  // 提示没有baby，添加baby
  _showTip() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('还没有宝宝信息..'),
            actions: <Widget>[
              FlatButton(
                child: Text('去添加'),
                onPressed: () async {
                  Navigator.pushNamed(context, '/baby/detail');
                },
              ),
            ],
          );
        });
  }
}

class Choice {
  const Choice({this.title, this.icon, this.view});
  final String title;
  final IconData icon;
  final String view;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '大事记', icon: Icons.straighten, view: 'memorabilia'),
  const Choice(title: '生长记录', icon: Icons.event_note, view: 'recordList'),
];

choicePage(Choice choice) {
  switch (choice.view) {
    case 'recordList':
      return SubRecordList();
      break;
    case 'memorabilia':
      return SubMemorabilia();
      break;
  }
}
