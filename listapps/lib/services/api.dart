import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:listapps/models/joke.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  Api._();
  static final Api instance = Api._();

  Future<Joke> getJoke() async {
    Response response = await get("https://sv443.net/jokeapi/v2/joke/Any");
    Joke joke = Joke.fromJson(jsonDecode(response.body));
    return joke;
  }
}
