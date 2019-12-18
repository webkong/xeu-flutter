import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:groovin_material_icons/groovin_material_icons.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({this.type = 'register'}) : super();
  final String type;
  @override
  _RegisterPageState createState() => _RegisterPageState(type: type);
}

class _RegisterPageState extends State<RegisterPage> {
  _RegisterPageState({this.type}) : super();
  final String type;
  final _formKey = GlobalKey<FormState>();
  String _userName, _password, _code;
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
    }
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
            SizedBox(height: 70.0),
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
          onPressed: () {
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              print(_formKey);
              _formKey.currentState.save();
              //TODO 执行注册方法
              print('email:$_userName , assword:$_password, code: $_code');
            }
          },
          shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).accentColor)),
        ),
      ),
    );
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
          child: RaisedButton(
            onPressed: () {
              //TODO 调用获取验证码
            },
            color: Theme.of(context).accentColor,
            child: Text(
              '获取验证码',
              style: TextStyle(fontSize: 10, color: Colors.white),
            ),
            shape: StadiumBorder(
              side: BorderSide(color: Theme.of(context).accentColor),
            ),
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
      onSaved: (String value) => _userName = value,
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
        var codeReg = RegExp(r"[0-9]{4,4}");
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
