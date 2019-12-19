import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomSystemUiOverlayStyle {
  static const SystemUiOverlayStyle light = SystemUiOverlayStyle(
//    systemNavigationBarColor: Color(0xFF000000),
//    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent,
//    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static const SystemUiOverlayStyle dark = SystemUiOverlayStyle(
//    systemNavigationBarColor: Color(0xFF000000),
//    systemNavigationBarDividerColor: null,
    statusBarColor: Colors.transparent, // 状态栏背景颜色透明
//    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.dark,
    statusBarBrightness: Brightness.light,
  );
}
