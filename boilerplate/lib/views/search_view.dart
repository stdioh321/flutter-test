import 'dart:convert';

import 'package:boilerplate/exceptions/http_exception.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchView extends StatefulWidget {
  @override
  _SearchViewState createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  Future<List<dynamic>> _onSearch(String txt) async {
    if (txt == null || txt.isEmpty == true) return [];
    return await _getComments();
  }

  Future<List<dynamic>> _getComments() async {
    Response resp = await get("https://jsonplaceholder.typicode.com/comments");
    if (resp.statusCode == 500) throw HttpException("Server error");
    if (resp.statusCode != 200) throw HttpException("Unable to get data");
    var tmp = jsonDecode(resp.body) as List;
    return tmp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Container(
        padding: EdgeInsets.all(
          15,
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              child: Text("Search"),
            ),
            DropdownSearch(
              mode: Mode.DIALOG,
              // items: myList,

              showClearButton: true,
              label: "Search",
              hint: "Hint",
              onChanged: (v) {
                print("onChanged");
                print(v);
              },
              searchBoxDecoration: InputDecoration(
                labelText: "Search",
              ),
              showSearchBox: true,
              isFilteredOnline: true,
              onFind: _onSearch,
              // validator: (value) {
              //   print("Validator:");
              //   print(value);
              //   if (value == null || value['email'].length > 3)
              //     return "Validation";
              //   return null;
              // },
              errorBuilder: (context, exception) {
                String msg = "Unknow error";
                if (exception.runtimeType == HttpException)
                  msg = (exception as HttpException).message;
                return Center(
                  child: Text(msg, style: TextStyle(color: Colors.red)),
                );
              },
              emptyBuilder: (context) {
                return Center(
                  child: Text(
                    "Empty",
                  ),
                );
              },
              itemAsString: (item) {
                if (item == null) return null;
                var m = item as Map<String, dynamic>;
                return m['email'];
              },
            ),
          ],
        ),
      ),
    );
  }
}
