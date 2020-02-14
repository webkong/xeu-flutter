import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';
import 'package:xeu/UIOverlay/slideTopRoute.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/user/baby.dart';
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
  List _babies = [];
  String _defaultBabyId;

  _init() {
    Baby _baby =
        Provider.of<UserModel>(context, listen: false).getDefaultBaby();
    logger.info('刷新 baby 列表');
    setState(() {
      _defaultBabyId = _baby.bid;
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
    _babies = Provider.of<UserModel>(context, listen: true).getBabies();
    return Scaffold(
      appBar: AppBar(
        title: Text('我的宝宝'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            _buildCard(),
            ...List.generate(_babies != null ? _babies.length : 0, (int index) {
              return _buildItem(_babies[index], index);
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
    await Navigator.push(context, SlideTopRoute(page: _page));
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
                showToast('Comming soon');
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

  Widget _buildItem(baby, index) {
    Baby _baby = Baby.fromJson(baby);
    return Card(
      margin: EdgeInsets.only(top: 8),
      child: Container(
        child: ListTile(
          selected: _defaultBabyId == _baby.bid,
          contentPadding:
              EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
          leading: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              shape: BoxShape.circle,
            ),
            child: Image(
              width: 60,
              height: 60,
              image: AssetImage(_baby?.avatar ?? Avatars.b1),
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
          onLongPress: () async {
            await showDialog(
              context: context,
              builder: (BuildContext context) {
                return SimpleDialog(
                  children: <Widget>[
                    ListTile(
                      title: Text('设为默认'),
                      onTap: () {
                        Navigator.pop(context);
                        _setDefaultBaby(_baby);
                      },
                    ),
                    Container(
                      height: Adapt.px(1),
                      color: Colors.grey,
                    ),
                    ListTile(
                      title: Text('删除宝宝'),
                      onTap: () {
                        Navigator.pop(context);
                        _deleteBaby(context, _baby, index);
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  _setDefaultBaby(Baby baby) async {
    await Http()
        .post('/user/update', {"u_id": baby.uid, "default_baby": baby.bid});
    await Provider.of<UserModel>(context, listen: false)
        .setUserAttr('defaultBaby', baby.bid);
    setState(() {
      _defaultBabyId = baby.bid;
    });
    Navigator.of(context).popUntil(ModalRoute.withName('/baby'));
  }

  _deleteBaby(BuildContext context, Baby _baby, index) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        var _alert;
        if (_babies.length > 1 && _defaultBabyId == _baby.bid) {
          _alert = AlertDialog(
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  '知道了',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            title: Text(
              '默认宝宝不能被删除',
              style: TextStyle(fontSize: 16),
            ),
          );
        } else {
          _alert = AlertDialog(
            title: Text(
              '是否删除宝宝:' + _baby.nickName + '?',
              style: TextStyle(fontSize: 16),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () async {
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () async {
                  print(_baby);
                  await Http().post(
                      '/baby/del', {"u_id": _baby.uid, "b_id": _baby.bid});
                  await Provider.of<UserModel>(context, listen: false)
                      .setUserAttr('delBaby', index, notify: true);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
        return _alert;
      },
    );
  }
}
