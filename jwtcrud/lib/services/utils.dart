import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/exception_message.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Utils {
  static Utils _instance;
  SharedPreferences prefs;

  static Utils get instance {
    if (_instance == null) {
      _instance = Utils();
    }
    return _instance;
  }

  Future<bool> displayToast(@required String msg,
      [Color color = Colors.green, double fontSize = 20]) {
    return Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM_RIGHT,
      timeInSecForIosWeb: 3,
      backgroundColor: color,
      textColor: Colors.white,
      webBgColor: "linear-gradient(to right, #F00, #F11)",
      webShowClose: true,
      fontSize: fontSize,
    );
  }

  ExceptionMessage HandleException(Exception e) {
    ExceptionMessage msg = ExceptionMessage();
    if (e.runtimeType == CustomException) {
      var tmp = e as CustomException;
      msg.message = tmp.message;
      msg.code = tmp.code;
      msg.error = tmp.cause;
    } else {
      msg.message = "Unknow error";
      msg.error = e;
    }

    return msg;
  }

  Color colorFromHex(String hexColor) {
    final hexCode = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hexCode', radix: 16));
  }

  bool isSet([List args = null]) {
    try {
      print("isSET");
      return args.every((element) {
        print(element);
        return element != null;
      });
    } catch (e) {
      return false;
    }
  }
}
