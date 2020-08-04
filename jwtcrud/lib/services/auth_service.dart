import 'dart:convert';

import 'package:jwtcrud/models/user.dart';
import 'package:jwtcrud/services/utils.dart';

class AuthService {
  static AuthService _instance;
  User user;
  static AuthService get instance {
    if (_instance == null) _instance = AuthService();
    return _instance;
  }

  Future loadUser(dynamic json) async {
    try {
      var tmp = jsonDecode(json);
      var mapUser = tmp['user'];
      mapUser['token'] = tmp['token'];
      user = User.fromJson(mapUser);
      return await Utils.instance.prefs
          .setString('user', jsonEncode(user.toJson()));
    } catch (e) {
      return false;
    }
  }

  bool isAuthenticate() {
    try {
      if (getUser() != null && getToken() != null) return true;
      return false;
    } catch (e) {
      return false;
    }
  }

  String getToken() {
    try {
      var token =
          User.fromJson(jsonDecode(Utils.instance.prefs.getString('user')))
              .token;
      return token;
    } catch (e) {
      return null;
    }
  }

  User getUser() {
    try {
      var user =
          User.fromJson(jsonDecode(Utils.instance.prefs.getString('user')));
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> setUser(User u) async {
    try {
      if (u == null) return Utils.instance.prefs.remove('user');
      var user = jsonEncode(u.toJson());
      return Utils.instance.prefs.setString('user', user);
    } catch (e) {
      return false;
    }
  }
}
