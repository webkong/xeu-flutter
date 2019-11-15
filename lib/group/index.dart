import 'package:flutter/material.dart';
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
          IconButton(icon: Icon(Icons.add, size: 30.0,), onPressed: () => this._save()),
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
            padding: const EdgeInsets.all(16.0),
            child: new ChoiceCard(choice: choice),
          );
        }).toList(),
      ),
    );
  }
}


class Choice {
  const Choice({this.title, this.icon});
  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: '记录', icon: Icons.event_note),
  const Choice(title: '身高曲线', icon: Icons.straighten),
  const Choice(title: '体重曲线', icon: Icons.trending_up),
  const Choice(title: '头围曲线', icon: Icons.face),
];

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({Key key, this.choice}) : super(key: key);

  final Choice choice;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme.of(context).textTheme.display1;
    return new Card(
      color: Colors.white,
      child: new Center(
        child: new Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Icon(choice.icon, size: 128.0, color: textStyle.color),
            new Text(choice.title, style: textStyle),
          ],
        ),
      ),
    );
  }
}
