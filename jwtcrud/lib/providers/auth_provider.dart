import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:jwtcrud/services/utils.dart';

class AuthProvider with ChangeNotifier {
  User _user;
  List _items = [];
  AuthProvider() {
    print("AuthProvider CONTRUCTOR");
  }
  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    // print("AuthProvider notifyListeners");
  }

  log({String txt = "Nothing"}) {
    print(txt);
  }

  User getUser() {
    try {
      var user =
          User.fromJson(jsonDecode(Utils.instance.prefs.getString("user")));
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setUser(User u) {
    if (u == null) return Utils.instance.prefs.remove('user');
    var user = jsonEncode(u.toJson());
    return Utils.instance.prefs.setString('user', user);
  }

  Future<List<Item>> loadItems() async {
    Response resp =
        await Api.getInstance().itemsGet("123sadas" + this.getUser().token);
    if (resp.statusCode == 200) {
      var tmp =
          (jsonDecode(resp.body) as List).map((e) => Item.fromJson(e)).toList();
      this._items = tmp;
      return _items;
    } else {
      throw CustomException("Server Error.", "${resp.statusCode}");
    }
  }
}
