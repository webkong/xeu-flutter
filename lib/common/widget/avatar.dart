import 'package:flutter/material.dart';
import 'package:xeu/common/utils/adapt.dart';

class Avatars {
  static final avatar = 'assets/avatar/default.png';
  static final b1 = 'assets/avatar/baby/b1.png';
  static final b2 = 'assets/avatar/baby/b2.png';
  static final b3 = 'assets/avatar/baby/b3.png';
  static final b4 = 'assets/avatar/baby/b4.png';
  static final b5 = 'assets/avatar/baby/b5.png';
  static final b6 = 'assets/avatar/baby/b6.png';
  static final b7 = 'assets/avatar/baby/b7.png';
  static final b8 = 'assets/avatar/baby/b8.png';
  static final b9 = 'assets/avatar/baby/b9.png';
  static final b10 = 'assets/avatar/baby/b10.png';
  static final b11 = 'assets/avatar/baby/b11.png';
  static final b12 = 'assets/avatar/baby/b12.png';
  static final b13 = 'assets/avatar/baby/b13.png';
  static final b14 = 'assets/avatar/baby/b14.png';
  static final b15 = 'assets/avatar/baby/b15.png';
  static final b16 = 'assets/avatar/baby/b16.png';
  static final b17 = 'assets/avatar/baby/b17.png';
  static final b18 = 'assets/avatar/baby/b18.png';
  static final b19 = 'assets/avatar/baby/b19.png';
  static final b20 = 'assets/avatar/baby/b20.png';

  static final a1 = 'assets/avatar/user/a1.png';
  static final a2 = 'assets/avatar/user/a2.png';
  static final a3 = 'assets/avatar/user/a3.png';
  static final a4 = 'assets/avatar/user/a4.png';
  static final a5 = 'assets/avatar/user/a5.png';
  static final a6 = 'assets/avatar/user/a6.png';
  static final a7 = 'assets/avatar/user/a7.png';
  static final a8 = 'assets/avatar/user/a8.png';
  static final a9 = 'assets/avatar/user/a9.png';
  static final a10 = 'assets/avatar/user/a10.png';
  static final a11 = 'assets/avatar/user/a11.png';
  static final a12 = 'assets/avatar/user/a12.png';
  static final a13 = 'assets/avatar/user/a13.png';
  static final a14 = 'assets/avatar/user/a14.png';
  static final a15 = 'assets/avatar/user/a15.png';
  static final a16 = 'assets/avatar/user/a16.png';
  static final a17 = 'assets/avatar/user/a17.png';
  static final a18 = 'assets/avatar/user/a18.png';
  static final a19 = 'assets/avatar/user/a19.png';
  static final a20 = 'assets/avatar/user/a20.png';
  static final a21 = 'assets/avatar/user/a21.png';
  static final a22 = 'assets/avatar/user/a22.png';

  final List avatarBaby = [
    b1,
    b2,
    b3,
    b4,
    b5,
    b6,
    b7,
    b8,
    b9,
    b10,
    b11,
    b12,
    b13,
    b14,
    b15,
    b16,
    b17,
    b18,
    b19,
    b20,
  ];
  final List avatars = [
    a1,
    a2,
    a3,
    a4,
    a5,
    a6,
    a7,
    a8,
    a9,
    a10,
    a11,
    a12,
    a13,
    a14,
    a15,
    a16,
    a17,
    a18,
    a19,
    a20,
    a21,
    a22,
  ];
  showSelection(context, {defaultAvatar = '', type: 'baby'}) async {
    var _selected = defaultAvatar;
    List _avatars;
    if (type == 'user') {
      _avatars = avatars;
    } else {
      _avatars = avatarBaby;
    }
    await showDialog(
        context: context,
        builder: (BuildContext cx) {
          return AlertDialog(
            title: Text(
              '选择头像',
              style: TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: Adapt.px(600),
              height: Adapt.px(640),
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setStateLocal) {
                  return GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                    ),
                    itemCount: 20,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        child: Container(
                          margin: EdgeInsets.all(8),
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: _selected == _avatars[index]
                                    ? Theme.of(context).accentColor
                                    : Colors.black12),
                            shape: BoxShape.circle,
                          ),
                          child: Image(
                            image: AssetImage(_avatars[index]),
                          ),
                        ),
                        onTap: () {
                          setStateLocal(() {
                            _selected = _avatars[index];
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('取消'),
                onPressed: () async {
                  _selected = null;
                  Navigator.of(context).pop();
                },
              ),
              FlatButton(
                child: Text('确定'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
    return _selected;
  }
}
