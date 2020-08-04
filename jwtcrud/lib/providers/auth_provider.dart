import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/utils.dart';

class AuthProvider with ChangeNotifier {
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    // print("AuthProvider notifyListeners");
  }
}
