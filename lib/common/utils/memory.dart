import 'package:shared_preferences/shared_preferences.dart';

class Memory {
  static SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static clear() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
    await _prefs.clear();
  }

  static insert(key, value) async {
    await _prefs.setString(key, value);
  }

  static get(key) {
    return _prefs.getString(key);
  }
}
