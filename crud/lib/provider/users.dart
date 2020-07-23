import 'dart:math';

import 'package:crud/data/dammy_users.dart';
import 'package:crud/models/user.dart';
import 'package:flutter/material.dart';

class Users with ChangeNotifier {
  final Map<String, User> _items = {...DUMMY_USERS};

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  List<User> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  User byIndex(int i) {
    return _items.values.elementAt(i);
  }

  void put(User user) {
    if (user == null) {
      return;
    }
    if (user.id != null &&
        user.id.trim().isNotEmpty &&
        _items.containsKey(user.id)) {
      _items.update(user.id, (_) => user);
    } else {
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
          id,
          () => User(
              id: id,
              email: user.email,
              name: user.name,
              avatarUrl: user.avatarUrl));
    }

    notifyListeners();
  }

  User remove(User user) {
    if (user == null && user.id == null) return null;
    User us = _items.remove(user.id);
    notifyListeners();
    return us;
    // User user = _items[id];

    // return user;
  }
}
