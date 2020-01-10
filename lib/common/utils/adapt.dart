import 'package:flutter/material.dart';

class Adapt {
  static MediaQueryData mediaQuery;
  static double _width;
  static double _height;
  static double _statusBarHeight;
  static double _bottomBarHeight;
  static double _textScaleFactor;
  static double _pixelRatio;
  static double _ratio;

  static init(BuildContext context, {uiWidth = 750}) {
    mediaQuery = MediaQuery.of(context);
    _width = mediaQuery.size.width;
    _height = mediaQuery.size.height;
    _statusBarHeight = mediaQuery.padding.top;
    _bottomBarHeight = mediaQuery.padding.bottom;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _textScaleFactor = mediaQuery.textScaleFactor;
    _ratio = double.parse((_width / uiWidth).toStringAsFixed(2));
  }

  static px(number) {
    return number * _ratio;
  }

  static onePX() {
    return 1 / _pixelRatio;
  }

  static get screenW {
    return _width;
  }

  static get screenH {
    return _height;
  }

  static get statusBarHeight {
    return _statusBarHeight;
  }

  static get bottomBarHeight {
    return _bottomBarHeight;
  }

  static get textScaleFactor {
    return _textScaleFactor;
  }
}
