import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mrcountry/main.dart';
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
  Color _primaryColor;

  Color get primaryColor {
    return _primaryColor;
  }

  set primaryColor(Color primaryColor) {
    this._primaryColor = primaryColor;
  }

  MaterialColor randomColor() {
    return colorsList[
        Random(DateTime.now().millisecond).nextInt(colorsList.length)];
  }

  void changeBrightness(BuildContext context) async {
    AppState apS = context.findRootAncestorStateOfType<AppState>();
    if (apS != null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool isDark = prefs.getBool("isDark") ?? false;
      prefs.setBool("isDark", !isDark);
      apS.setState(() {
        apS.brightness = isDark ?? false ? Brightness.light : Brightness.dark;
      });
    }
  }
}
