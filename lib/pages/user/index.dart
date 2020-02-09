import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/common/widget/avatar.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/main.dart';
import 'package:xeu/models/user/user.dart';
import 'package:xeu/models/user/user_state.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() {
    return _UserPageState();
  }
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin {
  User _user;
  String _nickName = '';
  String uid;
  String _avatar = Avatars.a1;
  TextEditingController _nickNameController = TextEditingController();

  _init(UserModel userModel) {
    print('触发 user index 刷新');
    _avatar = _user?.avatar ?? _avatar;
    _user = userModel.getUser();
    logger.info(_user.toJson());
    _nickName = _user?.nickName ?? '宝妈or宝爸';
    _nickNameController.text = _user?.nickName ?? _nickName;
    uid = _user.uid;
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;

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
    super.build(context);
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
                  Consumer<UserModel>(
                      builder: (BuildContext context, UserModel userModel, _) {
                    _init(userModel);
                    return _buildUserBar(context);
                  }),
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
          Icons.face,
          color: Theme.of(context).accentColor,
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
                  backgroundImage: AssetImage(_avatar),
                ),
              ),
              onTap: () async {
                String sA = await Avatars().showSelection(context,
                    defaultAvatar: _avatar, type: 'user');
                if (sA != null) {
                  setState(() {
                    _avatar = sA;
                  });
                  await Http().post(context, '/user/update',
                      {"u_id": uid, "avatar": _avatar});
                  await Provider.of<UserModel>(context, listen: false)
                      .fetchUserInfo(context);
                }
              },
            ),
          ),
          GestureDetector(
            child: Row(
              children: <Widget>[
                Text(
                  _nickName,
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
                            await Http().post(context, '/user/update',
                                {"u_id": uid, "nick_name": _nickName});
                            await Provider.of<UserModel>(context, listen: false)
                                .fetchUserInfo(context);
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
            Provider.of<UserModel>(context, listen: false).logout(context);
          },
        ),
      ),
    );
  }
}
