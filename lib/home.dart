import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:xeu/pages/group/index.dart';
import 'package:xeu/pages/group/new_memorabilia.dart';
import 'package:xeu/pages/group/new_record.dart';
import 'package:xeu/pages/user/index.dart';
import 'UIOverlay/slideTopRoute.dart';
import 'common/utils/adapt.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  PersistentBottomSheetController _bottomSheetController;
  IconData _icon = Icons.add;
  int _selectedIndex = 0;
  var page;
  static List<Widget> _pages = [
    GroupPage(),
    UserPage(),
  ];
  // 跳转到相应的新建页面
  _new(index) async {
    _bottomSheetController.close();
    _setSheetCloseStatus();
    if (index == 0) {
      page = NewMemorabilia();
    } else {
      page = NewRecord(); //身体参数
    }
    await Navigator.push(context, SlideTopRoute(page: page));
  }
  // sheet close

  _setSheetCloseStatus() {
    _bottomSheetController = null;
    setState(() {
      _icon = Icons.add;
    });
  }

  // 按钮动画效果
//  AnimationController _controller;
//  Animation _animation;
//  Animation _curve;
//  _initAnimation() {
//    _controller = AnimationController(
//      duration: Duration(milliseconds: 2000),
//      vsync: this,
//    );
//    _curve = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
//    _animation =
//        Tween(begin: Icons.add, end: Icons.arrow_downward).animate(_curve)
//          ..addListener(() {
//            setState(() {});
//          })
//          ..addStatusListener((state) {
//            print('$state');
//          });
//  }

  @override
  void initState() {
    super.initState();
//    _initAnimation();
  }

  @override
  void dispose() {
    super.dispose();
//    _controller?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Adapt.init(context);
    return Scaffold(
      body: Center(
//        child: _pages.elementAt(_selectedIndex),
        child: IndexedStack(
          index: _selectedIndex,
          children: _pages,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).accentColor,
        selectedIconTheme: IconThemeData(color: Colors.white),
        unselectedIconTheme: IconThemeData(color: Colors.black87),
        iconSize: 26,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.face,
            ),
            title: Text('宝宝'),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.account_circle,
            ),
            title: Text('我的'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      floatingActionButton: Builder(
        builder: (BuildContext context) {
          return FloatingActionButton(
            onPressed: () async {
              if (_bottomSheetController != null) {
                _bottomSheetController.close();
                _setSheetCloseStatus();
              } else {
                setState(() {
                  _icon = Icons.arrow_downward;
                });
                _bottomSheetController = Scaffold.of(context)
                    .showBottomSheet((BuildContext context) {
                  return _buildBottomSheet();
                });
                // 监听滑动关闭sheet
                _bottomSheetController.closed.whenComplete(() {
                  _setSheetCloseStatus();
                });
              }
            },
            tooltip: 'Add',
            child: Container(
              child: new Icon(
                _icon,
                color: Colors.white,
                size: 30,
              ),
            ),
            elevation: 4.0,
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  _buildBottomSheet() {
    return Container(
      height: 120,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        border: Border.all(
          color: Theme.of(context).accentColor,
          width: 1,
        ),
        color: Color(0xFFFFC107), //ffc107 255, 193, 7, 0.2
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: GestureDetector(
              onTap: () {
                _new(0);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.camera_alt,
                    size: 36,
                    color: Colors.black87,
                  ),
                  Text('添加大事记'),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                _new(1);
              },
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.assessment,
                    size: 36,
                    color: Colors.black87,
                  ),
                  Text('添加记录'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
