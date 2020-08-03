import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';

class AppConfig {
  static AppConfig _instance;

  Map<String, dynamic> config;

  static Future loadConfig() async {
    String tmp = await rootBundle.loadString('assets/config/dev.json');

    getInstance().config = jsonDecode(tmp);
    // print(getInstance().config['host']);
  }

  static getInstance() {
    if (_instance == null) _instance = AppConfig();
    return _instance;
  }
  // AppConfig({this.config}) {}
  // static AppConfig instance() {
  //   if (_instance == null) {
  //     var tmp = Map<String, dynamic>();
  //     tmp['abc'] = Random(DateTime.now().millisecondsSinceEpoch).nextInt(1000);
  //     _instance = AppConfig(config: tmp);
  //   }
  //   return _instance;
  // }
}
