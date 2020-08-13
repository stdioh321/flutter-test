import 'package:flutter/material.dart';

class HttpException implements Exception {
  String message;
  String code;
  String httpCode;
  dynamic error;

  HttpException(
    @required String this.message, {
    this.code,
    this.error,
    this.httpCode,
  });
}
