import 'package:flutter/foundation.dart';
import 'dart:async';

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:shared_preferences/shared_preferences.dart';

class Debouncer {
  final int milliseconds;
  VoidCallback action;
  Timer _timer;

  Debouncer({this.milliseconds});

  run(VoidCallback action) {
    if (_timer != null) {
      _timer.cancel();
    }

    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

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

  // SharedPreferences _prefs;

  // SharedPreferences get prefs {
  //   return this._prefs;
  // }

  // set prefs(SharedPreferences prefs) {
  //   this._prefs = prefs;
  // }

  MaterialColor randomColor() {
    return colorsList[
        Random(DateTime.now().millisecond).nextInt(colorsList.length)];
  }

  removeFocus(BuildContext context) {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScopeNode currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
      // FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      print(e);
    }
  }

  void displayDialog({BuildContext ctx, String title, String content}) {
    showDialog(
      context: ctx,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            FlatButton(
              child: Text("OK"),
              color: Colors.red,
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}
