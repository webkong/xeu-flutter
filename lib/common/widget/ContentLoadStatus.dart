import 'package:flutter/material.dart';
import 'package:xeu/common/utils/adapt.dart';

class ContentLoadStatus extends StatelessWidget {
  ContentLoadStatus({Key key, this.flag = 'loading', this.onUpdate})
      : super(key: key);
  final String flag; // loading noContent noNetwork
  final onUpdate;
  Widget _child = _buildLoading();
  @override
  Widget build(BuildContext context) {
    switch (flag) {
      case 'loading':
        _child = _buildLoading();
        break;
      case 'noContent':
        _child = _buildNoContent();
        break;
      case 'noNetwork':
        _child = _buildNoNetwork();
        break;
    }
    return _child;
  }
}

Widget _buildNoNetwork() {
  return Center(
    child: Container(
      height: Adapt.px(200),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.signal_wifi_off,
            size: 30,
            color: Colors.black38,
          ),
          Text(
            '网络连接有问题，请检查网络',
            style: TextStyle(
              fontSize: 15,
              color: Colors.black38,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildNoContent() {
  return Center(
    child: Container(
      height: Adapt.px(200),
      padding: EdgeInsets.only(top: Adapt.px(40)),
      child: Text('没有记录，快去添加吧..'),
    ),
  );
}

Widget _buildLoading() {
  return Center(
    child: Container(
      child: CircularProgressIndicator(),
      height: Adapt.px(60),
      width: Adapt.px(60),
    ),
  );
}
