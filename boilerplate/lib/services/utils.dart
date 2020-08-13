import 'dart:math';

import 'package:boilerplate/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static Utils _instance;
  Map<int, Color> color = {
    50: Color.fromRGBO(136, 14, 79, .1),
    100: Color.fromRGBO(136, 14, 79, .2),
    200: Color.fromRGBO(136, 14, 79, .3),
    300: Color.fromRGBO(136, 14, 79, .4),
    400: Color.fromRGBO(136, 14, 79, .5),
    500: Color.fromRGBO(136, 14, 79, .6),
    600: Color.fromRGBO(136, 14, 79, .7),
    700: Color.fromRGBO(136, 14, 79, .8),
    800: Color.fromRGBO(136, 14, 79, .9),
    900: Color.fromRGBO(136, 14, 79, 1),
  };
  bool isUpdating = false;
  static Utils get instance {
    if (_instance == null) _instance = Utils();
    return _instance;
  }

  MaterialColor colorToMaterial(@required Color c) {
    return MaterialColor(c.value, color);
  }

  int randomInt([int max = 100000]) {
    return Random().nextInt(max);
  }

  Color randomColor([int alpha = 255]) {
    int r = randomInt(255);
    int g = randomInt(255);
    int b = randomInt(255);
    // print("$r,$g,$b");
    return Color.fromARGB(alpha, r, g, b);
  }

  removeFocus(BuildContext context) {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      print(e);
    }
  }

  updateStateApp(@required BuildContext context, Function callback) async {
    try {
      if (isUpdating == true) {
        print("isUpdating...");
        return;
      }
      isUpdating = true;
      var appState = context.findRootAncestorStateOfType<MyAppState>();
      if (appState != null) {
        await callback();
        appState.setState(() {});
        isUpdating = false;
        return true;
      }
      isUpdating = false;
      return false;
    } catch (e) {
      isUpdating = false;
      return false;
    }
  }

  defaultToast(
    @required String msg, {
    Color bg: Colors.grey,
    color: Colors.white,
  }) {
    Fluttertoast.showToast(
      msg: msg,
      textColor: color,
      backgroundColor: bg,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      toastLength: Toast.LENGTH_LONG,
      webShowClose: true,
    );
  }
}
