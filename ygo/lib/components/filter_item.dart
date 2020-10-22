import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ygo/models/card_filter.dart';
import 'package:ygo/services/filters_service.dart';

class FilterItem extends StatefulWidget {
  bool itemValue = false;
  String title = "";
  Function callback;
  double widthFactor = 0.5;
  FilterItem(
      {@required this.itemValue,
      @required this.title,
      @required this.callback,
      this.widthFactor = 0.5});
  @override
  _FilterItemState createState() => _FilterItemState();
}

class _FilterItemState extends State<FilterItem> {
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widget.widthFactor,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Checkbox(
              onChanged: (bool value) {
                setState(() {
                  widget.itemValue = value;
                });
                widget.callback(value);
              },
              value: widget.itemValue,
            ),
            SizedBox(
              width: 5,
            ),
            Flexible(
              child: Text(
                widget.title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
