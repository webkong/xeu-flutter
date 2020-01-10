import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:xeu/common/global.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/models/device/deviceInfo.dart';
import 'package:xeu/models/user/user.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _phone, _password;
  bool _isObscure = true;
  Color _eyeColor;
  List _loginMethod = [
    {
      "title": "wechat",
      "icon": GroovinMaterialIcons.wechat,
    }
  ];

  _getInfo() async {
    var k = await DeviceInfo.get();
    print('Running on ${k.model}');
    print(k);
  }

  @override
  void initState() {
    _getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle(),
            buildTitleLine(),
            SizedBox(height: 60.0),
            buildPhoneTextField(),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            buildForgetPasswordText(context),
            SizedBox(height: 40.0),
            buildLoginButton(context),
            SizedBox(height: 20.0),
            buildOtherLoginText(),
            buildOtherMethod(context),
            buildRegisterText(context),
          ],
        ),
      ),
    );
  }

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Theme.of(context).accentColor),
              ),
              onTap: () {
                //:TODO 跳转到注册页面
                Navigator.pushNamed(context, '/register');
              },
            ),
          ],
        ),
      ),
    );
  }

  ButtonBar buildOtherMethod(BuildContext context) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: _loginMethod
          .map((item) => Builder(
                builder: (context) {
                  return IconButton(
                      icon: Icon(item['icon'],
                          color: Theme.of(context).iconTheme.color),
                      onPressed: () {
                        //TODO : 第三方登录方法
                        Scaffold.of(context).showSnackBar(new SnackBar(
                          content: new Text("${item['title']}登录"),
                          action: new SnackBarAction(
                            label: "取消",
                            onPressed: () {},
                          ),
                        ));
                      });
                },
              ))
          .toList(),
    );
  }

  Align buildOtherLoginText() {
    return Align(
        alignment: Alignment.center,
        child: Text(
          '其他账号登录',
          style: TextStyle(color: Colors.grey, fontSize: 14.0),
        ));
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 200.0,
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '登录',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Container(
                child:
                    Icon(GroovinMaterialIcons.arrow_right, color: Colors.white),
                margin: EdgeInsets.only(left: 4),
              ),
            ],
          ),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
              var res = await Http.post(
                  '/login', {"phone": _phone, "password": _password});
              if (res.code == 200) {
                User data = User.fromJson(res.data['data']);
                Global.initLocal(data);
                Navigator.pushReplacementNamed(context, '/home');
              }
              print(res);
            }
          },
          shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).accentColor)),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '忘记密码？',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/forget');
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      keyboardType: TextInputType.visiblePassword,
      initialValue: '123456',
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
          labelText: '密码',
          icon: Icon(Icons.lock),
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildPhoneTextField() {
    return TextFormField(
//      autofocus: true,
      keyboardType: TextInputType.phone,
      initialValue: '18610714908', //:TODO
      decoration: InputDecoration(
        labelText: '手机号',
        icon: Icon(Icons.person),
      ),
      validator: (String value) {
        var phoneReg = RegExp(r"[0-9]{11,11}");
        if (!phoneReg.hasMatch(value)) {
          return '请输入正确手机号';
        } else {
          return null;
        }
      },
      onSaved: (String value) => _phone = value,
    );
  }

  Padding buildTitleLine() {
    return Padding(
      padding: EdgeInsets.only(left: 12.0, top: 4.0),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Container(
          color: Colors.black,
          width: 40.0,
          height: 2.0,
        ),
      ),
    );
  }

  Padding buildTitle() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '登陆',
        style: TextStyle(fontSize: 42.0),
      ),
    );
  }
}
