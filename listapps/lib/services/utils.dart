import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  Utils._();
  static final Utils instance = Utils._();

  List<MaterialColor> colorsList = [
    Colors.red,
    Colors.pink,
    Colors.purple,
    Colors.deepPurple,
    Colors.indigo,
    Colors.blue,
    Colors.lightBlue,
    Colors.cyan,
    Colors.teal,
    Colors.green,
    Colors.lightGreen,
    Colors.lime,
    Colors.yellow,
    Colors.amber,
    Colors.orange,
    Colors.deepOrange,
    Colors.brown,
    Colors.blueGrey
  ];

  SharedPreferences _prefs;

  SharedPreferences get prefs {
    return this._prefs;
  }

  set prefs(SharedPreferences prefs) {
    this._prefs = prefs;
  }

  MaterialColor randomColor() {
    return colorsList[
        Random(DateTime.now().millisecond).nextInt(colorsList.length)];
  }
}
