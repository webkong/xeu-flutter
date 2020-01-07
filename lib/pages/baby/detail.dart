import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/common/constant/avatar.dart';
import 'package:xeu/models/group/record_state.dart';
import 'package:xeu/common/utils/adapt.dart';
import 'package:xeu/common/widget/toast.dart';
import 'package:xeu/common/utils/http.dart';
import 'package:xeu/models/user/baby.dart';

class BabyDetailPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BabyDetailPage();
  }
}

class _BabyDetailPage extends State<BabyDetailPage> {
  Baby _baby = new Baby();
  final nickNameEditingController = TextEditingController();
  String _defaultNickNameValue = '宝宝小名';
  @override
  void initState() {
    super.initState();
    nickNameEditingController.text = _defaultNickNameValue;
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
              child: _buildBabyInfo(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBabyInfo() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: ListView(
        children: <Widget>[
          Card(
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
                  barrierDismissible: false,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('设置小名'),
                      content: TextFormField(
                        controller: nickNameEditingController,
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
                            }else{
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
          ),
          Card(
            child: ListTile(
              leading: Text(
                '性别',
                style: TextStyle(fontSize: 18),
              ),
              title: Text(
                '男孩',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 14,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/baby');
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Text(
                '生日',
                style: TextStyle(fontSize: 18),
              ),
              title: Text(
                '2018-04-09',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 14,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/baby');
              },
            ),
          ),
          Card(
            child: ListTile(
              leading: Text(
                '血型',
                style: TextStyle(fontSize: 18),
              ),
              title: Text(
                'AB',
                textAlign: TextAlign.right,
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                color: Colors.black26,
                size: 14,
              ),
              onTap: () {
                Navigator.pushNamed(context, '/baby');
              },
            ),
          ),
        ],
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
}
