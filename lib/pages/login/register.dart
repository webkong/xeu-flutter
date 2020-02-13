import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';
import 'package:xeu/common/utils/tools.dart';
import 'package:xeu/main.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({this.type = 'register'}) : super();
  final String type;
  @override
  _RegisterPageState createState() => _RegisterPageState(type: type);
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState({this.type}) : super();
  final String type;
  String _apiPath = '/register';
  final _formKeyRegister = GlobalKey<FormState>();
  String _phone, _password, _code;
  String _title, _buttonText;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (type == 'register') {
      _title = '注册';
      _buttonText = _title;
    } else {
      _title = '找回密码';
      _buttonText = _title;
      _apiPath = '/forget';
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    logger.info('build register');
    return Scaffold(
      appBar: AppBar(
        title: Text(_buttonText),
      ),
      body: Form(
        key: _formKeyRegister,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildPhoneTextField(),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            SizedBox(height: 30.0),
            buildCodeTextField(context),
            SizedBox(height: 70.0),
            buildRegisterButton(context),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Align buildRegisterButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 200.0,
        child: RaisedButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _title,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
              Container(
                child: Icon(
                  GroovinMaterialIcons.arrow_right,
                  color: Colors.white,
                ),
                margin: EdgeInsets.only(left: 4),
              ),
            ],
          ),
          color: Theme.of(context).accentColor,
          onPressed: () async {
            if (_formKeyRegister.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              print(_formKeyRegister);
              _formKeyRegister.currentState.save();
              //TODO 执行注册/登陆方法
              var res = await Http().post(_apiPath,
                  {"phone": _phone.trim(), "password": Tools.generateMd5(_phone), "code": _code});
              if (res.data['code'] == 200) {
                Navigator.pop(context);
              }
              print('email:$_phone , assword:$_password, code: $_code');
            }
          },
          shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).accentColor)),
        ),
      ),
    );
  }

  _codeButtonPress() async {
    //TODO 调用获取验证码
    _formKeyRegister.currentState.save();
    print('get code');
    print(_phone);
    // 正则验证手机号
    // 仅国内
    bool pass = RegExp(r'1[345789]\d{9}').hasMatch(_phone);
    print(pass);
    if (pass) {
      var res = await Http().get('/sms/get', {'phone': _phone});
      if (res?.code == 200) {
        logger.info(res);
        print(res.data);
        if (res.data['biz_code'] == 11000) {
          showToast('用户存在，请找回密码');
        } else if (res.data['biz_code'] == 11001) {
          showToast('用户不存在，请先注册');
        } else {
          showToast('验证码已发送');
          return true;
        }
      }
    } else {
      showToast('请输入正确手机号');
    }
    return false;
  }

  //手机号
  TextFormField buildPhoneTextField() {
    return TextFormField(
//      autofocus: true,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: '手机号',
        icon: Icon(Icons.person),
        suffix: SizedBox(
          width: 90,
          height: 30,
          child: CodeButton(
            onPressed: _codeButtonPress,
            onFinish: (bool value) {
              showToast('验证码过期');
            },
          ),
        ),
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

// 密码框
  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      keyboardType: TextInputType.visiblePassword,
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
            }),
      ),
    );
  }

// 验证码
  TextFormField buildCodeTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _code = value,
      keyboardType: TextInputType.number,
      validator: (String value) {
        var codeReg = RegExp(r"[0-9]{6,6}");
        print('code: $codeReg');
        if (!codeReg.hasMatch(value)) {
          return '请输入正确验证码';
        } else {
          return null;
        }
      },
      decoration: InputDecoration(
        labelText: '验证码',
        icon: Icon(Icons.smartphone),
      ),
    );
  }

  Center buildTitle() {
    return Center(
      child: Container(
        child: Text(
          _title,
          style: TextStyle(fontSize: 32.0),
        ),
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
              style: BorderStyle.solid, width: 2, color: Colors.black),
        )),
      ),
    );
  }
}

class CodeButton extends StatefulWidget {
  CodeButton({Key key, @required this.onPressed, @required this.onFinish})
      : super(key: key);
  final Function onPressed;
  final Function onFinish;
  @override
  _CodeButtonState createState() => _CodeButtonState();
}

class _CodeButtonState extends State<CodeButton> {
  Timer _timer;
  int _count = 300;
  String _codeText = '验证码';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _clearTimer();
  }

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: _timer == null ? _pressAction : null,
      color: Theme.of(context).accentColor,
      child: Text(
        _timer == null ? _codeText : '$_count s',
        style: TextStyle(fontSize: 12, color: Colors.white),
      ),
      disabledColor: Colors.black26,
      shape: StadiumBorder(
        side: BorderSide(color: Theme.of(context).accentColor),
      ),
    );
  }

  _pressAction() async {
    bool isSend = await widget.onPressed();
    if (isSend) {
      _startTimer();
    }
  }

  // 倒计时

  void _startTimer() {
    _timer = Timer.periodic(
      Duration(seconds: 1),
      (timer) {
        setState(() {
          _count--;
        });
        if (_count <= 1) {
          _clearTimer();
          widget.onFinish(true);
          return;
        }
      },
    );
  }

  _clearTimer() {
    _timer?.cancel();
    setState(() {
      _timer = null;
      _count = 300;
    });
  }
}
