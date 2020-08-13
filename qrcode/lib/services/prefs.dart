import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Prefs _instance;
  SharedPreferences prefs;

  static Prefs get instance {
    if (_instance == null) _instance = Prefs();
    return _instance;
  }
}
