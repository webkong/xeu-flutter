import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/constant/avatar.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/common/widget/datePicker.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/baby.dart';
import 'package:xeu/models/user/user_state.dart';

class BabyDetailPage extends StatefulWidget {
  BabyDetailPage({this.data});
  final Baby data;
  @override
  State<StatefulWidget> createState() {
    return _BabyDetailPage(baby: data);
  }
}

enum Genders { boy, girl }

class _BabyDetailPage extends State<BabyDetailPage> {
  _BabyDetailPage({this.baby});
  Baby baby;
  final nickNameEditingController = TextEditingController();
  String _defaultNickNameValue = '宝宝小名';
  bool _isEdit = false;
  String _genderName = '选择性别'; // 0 男孩 1 女孩
  int _gender = -1;
  String _defaultBirthday =
      DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  int _birthday = Tools.formatToUtt(Tools.nowFormat());

  String _bloodName = '选择血型';
  String _blood = '';

  String _buttonText = '保存';

  _init() {
    print(baby.toJson().toString());
    if (baby?.bid != null) {
      setState(() {
        _isEdit = true;
        _defaultNickNameValue = baby?.nickName;
        nickNameEditingController.text = baby?.nickName;
        _genderName = baby?.gender == 0 ? '男孩' : '女孩';
        _defaultBirthday = Tools.formatDate(baby?.birthday);
        _bloodName = baby?.blood;
        _gender = baby?.gender;
        _blood = baby?.blood;
        _birthday = baby?.birthday;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/babyBanner.jpg'),
          fit: BoxFit.scaleDown,
          alignment: Alignment.topCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          child: AppBar(
            leading: CloseButton(),
            centerTitle: true,
            title: Text('添加宝宝'),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 0.07),
        ),
        body: Column(
          children: <Widget>[
            _buildBabyBar(),
            Expanded(
              child: _buildBabyInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBabyInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: <Widget>[
          _buildNickName(),
          _buildGender(),
          Card(
            child: ListTile(
              leading: Text(
                '生日',
                style: TextStyle(fontSize: 18),
              ),
              title: Text(
                _defaultBirthday,
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 14,
              ),
              onTap: () async {
                String _time = await DatePickerCustom.show(context);
                String _date = _time.split(' ')[0];
                setState(() {
                  _defaultBirthday = _date;
                  _birthday = DateTime.parse(_time).millisecondsSinceEpoch;
                });
              },
            ),
          ),
          _buildBlood(),
          Container(
            margin: EdgeInsets.only(top: Adapt.px(40)),
            child: _buildLoginButton(context),
          ),
        ],
      ),
    );
  }

  _save() async {
    SharedPreferences pres = await SharedPreferences.getInstance();
    String uid = pres.getString('u_id');
    Map<String, dynamic> params = {
      "u_id": uid,
      "nick_name": _defaultNickNameValue,
      'gender': _gender,
      'blood': _blood,
      'birthday': _birthday
    };
    String path = '/baby/new';
    if (_isEdit) {
      path = '/baby/update';
      params['b_id'] = baby?.bid;
    }
    var res = await Http.post(path, params);
    if (res.code == 200) {
      await Provider.of<UserModel>(context, listen: false).getUserInfo();
      Navigator.of(context).pop(true);
      Toast.show('保存成功', context);
    } else {
      Toast.show('保存失败', context);
    }
  }

  Widget _buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 40,
        width: 200.0,
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _buttonText,
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ],
          ),
          color: Theme.of(context).accentColor,
          onPressed: () {
            _save();
          },
        ),
      ),
    );
  }

  _bloodHandler(setStateLocal, value) {
    setStateLocal(() {
      _blood = value;
    });
    setState(() {
      _bloodName = value;
    });
    print(value);
  }

  Widget _buildBlood() {
    return Card(
      child: ListTile(
        leading: Text(
          '血型',
          style: TextStyle(fontSize: 18),
        ),
        title: Text(
          _bloodName,
          textAlign: TextAlign.right,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black26,
          size: 14,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('选择血型'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateLocal) {
                    return Container(
                      height: Adapt.px(500),
                      child: Column(
                        children: <Widget>[
                          RadioListTile(
                            title: Text('A 型'),
                            value: 'A',
                            groupValue: _blood,
                            onChanged: (value) {
                              _bloodHandler(setStateLocal, value);
                            },
                          ),
                          RadioListTile(
                            title: Text('B 型'),
                            value: 'B',
                            groupValue: _blood,
                            onChanged: (value) {
                              _bloodHandler(setStateLocal, value);
                            },
                          ),
                          RadioListTile(
                            title: Text('AB 型'),
                            value: 'AB',
                            groupValue: _blood,
                            onChanged: (value) {
                              _bloodHandler(setStateLocal, value);
                            },
                          ),
                          RadioListTile(
                            title: Text('O 型'),
                            value: 'O',
                            groupValue: _blood,
                            onChanged: (value) {
                              _bloodHandler(setStateLocal, value);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  _genderHandler(setStateLocal, value) {
    setStateLocal(() {
      _gender = value;
    });
    print(value);
    setState(() {
      _genderName = value == 0 ? '男孩' : '女孩';
    });
    print(value);
  }

  Widget _buildGender() {
    return Card(
      child: ListTile(
        leading: Text(
          '性别',
          style: TextStyle(fontSize: 18),
        ),
        title: Text(
          _genderName,
          textAlign: TextAlign.right,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black26,
          size: 14,
        ),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text('选择性别'),
                content: StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStateLocal) {
                    return Container(
                      height: Adapt.px(240),
                      child: Column(
                        children: <Widget>[
                          RadioListTile(
                            title: Text('男孩'),
                            value: 0,
                            groupValue: _gender,
                            onChanged: (value) {
                              _genderHandler(setStateLocal, value);
                            },
                          ),
                          RadioListTile(
                            title: Text('女孩'),
                            value: 1,
                            groupValue: _gender,
                            onChanged: (value) {
                              _genderHandler(setStateLocal, value);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildBabyBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(40, 20, 40, 20),
            decoration: ShapeDecoration(
              shape: StadiumBorder(side: BorderSide(color: Colors.black12)),
            ),
            height: 60,
            width: 60,
            child: CircleAvatar(
              child: Image.asset(Avatars.b1),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNickName() {
    return Card(
      child: ListTile(
        leading: Text(
          '小名',
          style: TextStyle(fontSize: 18),
        ),
        title: Text(
          _defaultNickNameValue,
          textAlign: TextAlign.right,
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          color: Colors.black26,
          size: 14,
        ),
        onTap: () {
          showDialog(
            context: context,
            barrierDismissible: _isEdit, // 如果是修改可以直接消失
            builder: (_) {
              return AlertDialog(
                title: Text('设置小名'),
                content: TextFormField(
                  controller: nickNameEditingController,
                  decoration: InputDecoration(
                    hintText: _defaultNickNameValue,
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
                      print(nickNameEditingController);
                      String _nickName = nickNameEditingController.text;
                      if (_nickName.length > 0) {
                        setState(() {
                          _defaultNickNameValue = _nickName;
                        });
                        Navigator.of(context).pop();
                      } else {
                        Toast.show('小名不能为空', context);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
