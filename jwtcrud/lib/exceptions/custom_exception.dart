import 'package:http/http.dart';

class CustomException implements Exception {
  String cause;
  String code;
  String message;

  CustomException(String message, String code, {String cause}) {
    if (message.length == 0) message = "Unknow error";
    this.message = message;
    this.code = code;
    if (cause == null)
      this.cause = message;
    else
      this.cause = cause;
  }

  @override
  String toString() {
    // TODO: implement toString
    // return super.toString();
    return "$code: $message - $cause";
  }
}

class HttpException implements Exception {
  String cause;
  String code;
  String message;
  HttpException(Response resp) {
    this.code = resp.statusCode.toString();
  }
}
