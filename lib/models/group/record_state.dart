import 'package:flutter/material.dart';

class RecordModel with ChangeNotifier {
  bool _hasNew = false;
  bool get()=> _hasNew;
  void add(item) {
    _hasNew = true;
    notifyListeners();
  }
  void init(){
    _hasNew = false;
  }
}
