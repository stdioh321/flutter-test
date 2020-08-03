import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:jwtcrud/providers/auth_provider.dart';
import 'package:jwtcrud/services/app_config.dart';
import 'package:provider/provider.dart';

class Api {
  static Api _instance;

  Api() {
    print("API Constructor");
  }

  static Api getInstance() {
    if (_instance == null) _instance = Api();
    return _instance;
  }

  Future postLogin({String username, String password}) async {
    Map body = {"username": username, "password": password};

    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rLogin'];
    Response resp = await post(url, body: body);
    // await Future.delayed(Duration(seconds: 2));
    return resp;
  }

  Future getMe({String token}) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rMe'];
    return get(url);
  }

  Future<Response> itemsGet(String token) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rItems'];
    return get(url, headers: {"Authorization": "Bearer $token"});
  }
}
