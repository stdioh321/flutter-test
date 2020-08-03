import 'package:flutter/material.dart';
import 'package:jwtcrud/services/utils.dart';

class ErrorMessage extends StatelessWidget {
  const ErrorMessage(
      {Key key, @required this.msgError, this.align = Alignment.center})
      : super(key: key);

  final String msgError;
  final Alignment align;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: align,
      padding: EdgeInsets.all(
        15,
      ),
      decoration: BoxDecoration(
          color: Utils.instance.colorFromHex("#f8d7da"),
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
            width: 1,
            color: Utils.instance.colorFromHex("#f5c6cb"),
          )),
      child: Text(
        msgError,
        style: TextStyle(
          color: Utils.instance.colorFromHex("#721c24"),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
