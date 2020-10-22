import 'package:http/http.dart' as http;

class Api {
  String urlBase = "https://db.ygoprodeck.com/api/v7/cardinfo.php";
  // String urlBase = "https://db.ygoprodeck.com/api/v7/cardinfo.php?name=Dark%20Magician";

  static Api _instance = null;

  Api() {
    print("Api Constructor");
  }
  static Api getInstance() {
    if (_instance == null) _instance = new Api();
    return _instance;
  }

  Future<http.Response> getCards({String lang: ""}) {
    String tmpUrl = urlBase;

    if (lang != null && lang.isNotEmpty == true && lang != "en") {
      tmpUrl += "?language=" + lang;
    }
    return http.get(tmpUrl);
  }
}
