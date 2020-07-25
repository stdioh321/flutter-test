import 'dart:convert';

import "package:http/http.dart";
import 'package:timezone/models/timezone.dart';

class Api {
  Api._();
  static final Api instance = Api._();

  String host = "http://worldtimeapi.org/";
  String baseUrl = "http://worldtimeapi.org/api/";

  Future<List<String>> getTimezones() async {
    Response resp = await get("${baseUrl}timezone");
    if (resp.statusCode != 200)
      throw Exception("Unable to get the timezones: ${resp.statusCode}");
    var json = (jsonDecode(resp.body) as List);
    List<String> timezones = json.map((e) {
      return e.toString();
    }).toList();
    return timezones;
  }

  Future<Timezone> getTimezone(String location) async {
    Response resp = await get("${baseUrl}timezone/$location");
    if (resp.statusCode != 200)
      throw Exception("Unable to get the timezones: ${resp.statusCode}");
    var json = (jsonDecode(resp.body) as Map<String, dynamic>);
    Timezone timezone = Timezone.fromJson(json);
    return timezone;
  }
}
