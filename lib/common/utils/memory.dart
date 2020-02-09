import 'package:shared_preferences/shared_preferences.dart';
import 'package:xeu/main.dart';

class Memory {
  static SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  static clear() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return await _prefs.clear();
  }

  static insert(key, value) async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return await _prefs.setString(key, value);
  }

  static get(key) async{
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    return _prefs.getString(key);
  }
}
