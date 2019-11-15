import 'package:flutter/material.dart';
import 'package:flutter_app/group/sub_head_chart.dart';
import 'package:flutter_app/group/sub_record_list.dart';
import 'package:flutter_app/group/sub_weight_chart.dart';
import '../utils/toast.dart';

class GroupPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GroupPage();
  }
}

class _GroupPage extends State<GroupPage> with SingleTickerProviderStateMixin {
  _save() {
    Toast.show('保存成功', context);
    Navigator.pushNamed(context, '/group/new');
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
        title: Text('成长记录'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.add,
                size: 30.0,
              ),
              onPressed: () => this._save()),
        ],
        bottom: new TabBar(
          controller: _tabController,
          tabs: choices.map((Choice choice) {
            return new Tab(
              text: choice.title,
              icon: new Icon(choice.icon),
            );
          }).toList(),
        ),
      ),
      body: new TabBarView(
        controller: _tabController,
        children: choices.map((Choice choice) {
          return new Padding(
              padding: const EdgeInsets.all(8.0), child: choicePage(choice));
        }).toList(),
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
  const Choice(title: '记录', icon: Icons.event_note, view: 'recordList'),
  const Choice(title: '身高曲线', icon: Icons.straighten, view: 'height'),
  const Choice(title: '体重曲线', icon: Icons.trending_up, view: 'weight'),
  const Choice(title: '头围曲线', icon: Icons.face, view: 'head'),
];

choicePage(Choice choice) {
  switch (choice.view) {
    case 'recordList':
      return SubRecordList();
      break;
    case 'height':
      return SubHeadChart();
      break;
    case 'weight':
      return SubWeightChart();
      break;
    case 'head':
      return SubHeadChart();
      break;
  }
}
