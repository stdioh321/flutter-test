import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  List<String> _myList = [];
  SharedPreferences prefs;
  String token;
  AuthProvider({this.prefs}) {
    print(prefs.getString("login"));
    print("Constructor AuthProvider");
  }
  loadPrefs() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs);
  }

  // SharedPreferences get prefs {
  //   return _prefs;
  // }
  List<String> get myList {
    return _myList;
  }

  void addToList({String txt = 'something'}) {
    txt = txt == null ? "something" : "$txt";
    _myList.add(txt);
    notifyListeners();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    print("notifyListeners");
  }

  doSomething() async {
    await Future.delayed(Duration(seconds: 1));
    notifyListeners();
  }
}
