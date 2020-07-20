import 'dart:convert';

import 'package:http/http.dart';
import 'package:listapps/models/country.dart';
import 'package:listapps/models/time.dart';
import 'package:listapps/services/world_time.dart';

class Api {
  String _host = "http://worldtimeapi.org/";
  String _baseUrl = "http://worldtimeapi.org/api/timezone/";

  String _baseUrlCountry = "https://restcountries.eu/rest/v2/";
  String _hostCountry = "https://restcountries.eu/";

  Api._();
  static final Api instance = Api._();

  Future<Time> getTime(String location) async {
    Response response = await get("$_baseUrl$location");
    if (response.statusCode != 200)
      throw Exception([
        "Unable to get the Time",
      ]);
    Time t = Time.fromJson(jsonDecode(response.body));
    return t;
  }

  Future<List<String>> getTimezones() async {
    Response resp = await get("$_baseUrl");
    if (resp.statusCode != 200)
      throw Exception(['Unable to get the Timezones']);
    List<String> tZones = (jsonDecode(resp.body) as List<dynamic>)
        .map((e) => e.toString())
        .toList();
    return tZones;
  }

  Future<List<Country>> getCountries() async {
    Response resp = await get("${_baseUrlCountry}all");
    if (resp.statusCode != 200)
      throw Exception(['Error getting the countries.']);
    // var json = jsonDecode(resp.body)[1];
    // Country c = Country.fromJson(json);
    // print(c.name);
    List<Country> tmpCountries = (jsonDecode(resp.body) as List<dynamic>)
        .map((e) => Country.fromJson(e))
        .toList();
    // print(tmpCountries);
    return tmpCountries;
  }
}
