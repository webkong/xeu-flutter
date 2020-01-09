import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/user_state.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage> {
  User _user;
  String _nickName = '用户837abd';
  String uid;
  String _avatar = Avatars.a1;
  TextEditingController _nickNameController = TextEditingController();

  _init() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    var user = pres.getString('user');
    uid = pres.getString('u_id');

    Map userMap = json.decode(user);
    setState(() {
      _user = User.fromJson(userMap);
      _nickName = _user?.nickName;
      _nickNameController.text = _user?.nickName ?? _nickName;
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
                  _buildUserBar(context),
                  _buildItemBar(context),
                ],
              ),
            ),
            Expanded(
              child: _buildLoginButton(context),
            )
          ]),
        ));
  }

  _buildItemBar(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(
          Icons.tag_faces,
          color: Colors.grey,
        ),
        title: Text('我的宝宝'),
        trailing: Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.pushNamed(context, '/baby');
        },
      ),
    );
  }

  _buildUserBar(BuildContext context) {
    return Card(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(
            child: GestureDetector(
              child: Container(
                margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
                decoration: ShapeDecoration(
                  shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
                ),
                height: 80,
                width: 80,
                child: CircleAvatar(
                  backgroundImage: AssetImage(_user?.avatar ?? _avatar),
                ),
              ),
              onTap: () async {
                String sA = await Avatars().showSelection(context,
                    defaultAvatar: _avatar, type: 'user');
                setState(() {
                  _avatar = sA;
                });
                await Http.post(
                    '/user/update', {"u_id": uid, "avatar": _avatar});
                await Provider.of<UserModel>(context, listen: false)
                    .getUserInfo();
                _init();
              },
            ),
          ),
          GestureDetector(
            child: Row(
              children: <Widget>[
                Text(
                  _user?.nickName ?? _nickName,
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
              showDialog(
                context: context,
                builder: (_) {
                  return AlertDialog(
                    title: Text('设置昵称'),
                    content: TextFormField(
                      controller: _nickNameController,
                      decoration: InputDecoration(
                        hintText: _nickName,
                      ),
                      validator: (value) {
                        if (value != null) {
                          return null;
                        } else {
                          return '不能为空';
                        }
                      },
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('取消'),
                        onPressed: () async {
                          Navigator.of(context).pop();
                        },
                      ),
                      FlatButton(
                        child: Text('确定'),
                        onPressed: () async {
                          String _name = _nickNameController.text;
                          if (_name.length > 0 && _name != _user.nickName) {
                            setState(() {
                              _nickName = _name;
                            });
                            await Http.post('/user/update',
                                {"u_id": uid, "nick_name": _nickName});
                            await Provider.of<UserModel>(context, listen: false)
                                .getUserInfo();
                            _init();
                            Navigator.of(context).pop();
                          } else {
                            Toast.show('昵称不符合，或未有改动', context);
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          )
        ],
      ),
    );
  }

  Align _buildLoginButton(BuildContext context) {
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
            await pres.setString("user", null);
            await pres.setString("u_id", null);
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (Route<dynamic> route) => false);
          },
        ),
      ),
    );
  }
}
