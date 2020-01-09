import 'package:flutter/material.dart';
import 'package:xeu/common/utils/adapt.dart';

class Avatars {
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

  final List avatars = [
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
  showSelection(context, {defaultAvatar = ''}) async {
    var _selected = defaultAvatar;
    await showDialog(
      context: context,
      child: AlertDialog(
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
                  crossAxisCount: 4,
                ),
                itemCount: 20,
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    child: Container(
                      margin: EdgeInsets.all(8),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _selected == avatars[index]
                                ? Theme.of(context).accentColor
                                : Colors.black12),
                        shape: BoxShape.circle,
                      ),
                      child: Image(
                        image: AssetImage(avatars[index]),
                      ),
                    ),
                    onTap: () {
                      setStateLocal(() {
                        _selected = avatars[index];
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
              _selected = defaultAvatar;
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
      ),
    );
    return _selected;
  }
}
