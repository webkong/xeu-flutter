import 'package:flutter/material.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    int _index=0;
    var page ;
    Baby _baby;

  _new() async{
    if(_index == 0){
       page = NewMemorabilia();
    }else{
      page = NewRecord(); //身体参数
    }
     await Navigator.push(context, SlideTopRoute(page: page));
  }

  _init() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    // Todo: 设置默认的宝宝。显示宝宝的头像在这个地方
  }


  TabController _tabController;
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
        leading: Image(image: AssetImage(Avatars.b1),),
        title: Text('成长记录'),
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
          onTap: (index){
            _index = index;
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: new TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), //TODO:禁止左右滑动
        children: choices.map((Choice choice) {
          return new Padding(
              padding: const EdgeInsets.all(8.0), child: choicePage(choice));
        },
        ).toList(),
      ),
    );
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
