import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/models/item.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/services/api.dart';
import 'package:provider/provider.dart';

class ItemsProvider with ChangeNotifier {
  List<Item> items = [];

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  loadItems(dynamic json) {
    print("loadItems");
    var items = jsonDecode(json) as List;
    this.items = items.map((element) {
      return Item.fromJson(element);
    }).toList();
    // notifyListeners();
    // var tmp = (jsonDecode(json) as List).map((e) => Item.fromJson(e)).toList();
    // this.items = tmp;
    // notifyListeners();
  }
}
