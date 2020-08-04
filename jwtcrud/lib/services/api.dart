import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http_interceptor.dart';
import 'package:jwtcrud/exceptions/custom_exception.dart';
import 'package:jwtcrud/interceptors/common_interceptor.dart';
import 'package:jwtcrud/routes/app_routes.dart';
import 'package:jwtcrud/services/app_config.dart';
import 'package:jwtcrud/services/auth_service.dart';
import 'package:toast/toast.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

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

  Future getMe() {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rMe'];
    return getWithAuth(url);
  }

  Future<Response> getItems([String id = null]) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rItems'];
    if (id != null) {
      url = url + "/$id";
    }
    return getWithAuth(url);
  }

  Future<Response> postItem(Map<String, dynamic> data) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rItems'];
    return postWithAuth(url, data);
  }

  Future<Response> putItem(String id, Map<String, dynamic> data) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rItems'] +
        "/$id";
    return putWithAuth(url, data);
  }

  Future<Response> getBrands([String id = null]) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rBrands'];
    if (id != null) {
      url = url + "/$id";
    }
    return getWithAuth(url);
  }

  Future<Response> getModels([String id = null]) {
    String url = AppConfig.getInstance().config['urlApi'] +
        AppConfig.getInstance().config['rModels'];
    if (id != null) {
      url = url + "/$id";
    }
    return getWithAuth(url);
  }

  getWithAuth(String url) {
    String token = AuthService.instance.getToken();
    return get(url, headers: {"Authorization": "Bearer $token"})
        .then(_intercept401);
  }

  postWithAuth(String url, Map<String, dynamic> data) {
    String token = AuthService.instance.getToken();
    return post(url, body: data, headers: {"Authorization": "Bearer $token"})
        .then((_intercept401));
  }

  putWithAuth(String url, Map<String, dynamic> data) {
    String token = AuthService.instance.getToken();
    return put(url, body: data, headers: {"Authorization": "Bearer $token"})
        .then((_intercept401));
  }

  Response _intercept401(Response r) {
    if (r.statusCode == 401) {
      AuthService.instance.setUser(null).then((r) {
        Modular.to
            .pushNamedAndRemoveUntil(AppRoutes.LOGIN, ModalRoute.withName("/"));
      });
      showToast(
        "Unauthorized",
        position: StyledToastPosition.bottom,
        backgroundColor: Colors.red,
      );

      throw CustomException("Unauthorized", "401");
    }
    return r;
  }
}
