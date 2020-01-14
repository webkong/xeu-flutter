import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user_state.dart';
import 'package:xeu/pages/baby/detail.dart';
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
  String _babyAvatar = Avatars.avatar;
  Baby _baby;
  TabController _tabController;

  _init(UserModel userModel) async {
    List babies = await userModel.getBabies();
    if (babies.length == 0) {
      _showTip();
    } else {
      _baby = await userModel.getDefaultBaby();
    }
      _babyAvatar = _baby?.avatar ?? _babyAvatar;
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: choices.length);
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
          child: GestureDetector(
            child: CircleAvatar(
              child: Consumer<UserModel>(
                builder: (BuildContext context, UserModel userModel, _) {
                  print('group/index');
                  _init(userModel);
                  return Image(image: AssetImage(_babyAvatar));
                },
              ),
            ),
            onTap: () async {
//              await _pushToBabyPage();
              await _pushToBabyListPage();
            },
          ),
        ),
        title: Text('宝宝记录'),
        bottom: new TabBar(
          controller: _tabController,
          tabs: choices.map((Choice choice) {
            return new Tab(
              text: choice.title,
//              icon: new Icon(choice.icon),
            );
          }).toList(),
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

  // 跳转到默认baby信息

  _pushToBabyPage() async {
    var isNew = await Navigator.push(
      context,
      SlideTopRoute(
        page: BabyDetailPage(
          data: _baby,
        ),
      ),
    );
  }

  _pushToBabyListPage() async {
    await Navigator.pushNamed(context, '/baby');
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
