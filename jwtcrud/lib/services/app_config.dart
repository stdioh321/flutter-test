import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppConfig {
  static AppConfig _instance;

  Map<String, dynamic> config;

  static Future loadConfig() async {
    String tmp = await rootBundle.loadString('assets/config/dev.json');

    getInstance().config = jsonDecode(tmp);
    // print(getInstance().config['host']);
  }

  static AppConfig getInstance() {
    if (_instance == null) _instance = AppConfig();
    return _instance;
  }

  String getHost() {
    return config['isTest'] == true ? config['hostTest'] : config['host'];
  }

  String getUrlApi() {
    return config['isTest'] == true ? config['urlApiTest'] : config['urlApi'];
  }

  String getConfigKey(@required String key) {
    try {
      return config[key];
    } catch (e) {
      return null;
    }
  }
}
