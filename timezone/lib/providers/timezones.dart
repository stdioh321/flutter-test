import 'package:flutter/material.dart';
import 'package:timezone/models/timezone.dart';
import 'package:timezone/services/api.dart';

class Timezones with ChangeNotifier {
  List<String> timezones = [];
  bool loading = false;

  Timezones() {
    this.loadTimezones();
  }

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
  }

  loadTimezones() async {
    loading = true;
    try {
      List<String> tmp = await Api.instance.getTimezones();
      timezones = tmp;
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      print(e);
      // timezones = null;
    }
    loading = false;
    notifyListeners();
  }

  Future<Timezone> byLocation(@required String location) async {
    Timezone tmz = await Api.instance.getTimezone(location);
    return tmz;
  }
}
