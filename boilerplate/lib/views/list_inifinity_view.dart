import 'dart:async';
import 'dart:convert';

import 'package:boilerplate/services/utils.dart';
import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class ListInfinityView extends StatefulWidget {
  @override
  _LisInfinitysViewState createState() => _LisInfinitysViewState();
}

class _LisInfinitysViewState extends State<ListInfinityView> {
  // List<String> _myList = [];
  List myList = [];
  bool loading = false;
  bool isComplete = false;
  ScrollController _scrollCtrl = ScrollController();
  var _keyScaf = GlobalKey<ScaffoldState>();
  // int total;
  int totalPages;
  int perPage;
  int page = 1;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _myList = List.generate(30, (index) => "String $index");
    // myList = [..._myList];
    _configLoadCtrl();

    _loadRest(page);
  }

  _configLoadCtrl() {
    _scrollCtrl.addListener(() async {
      if (_scrollCtrl.position.pixels == _scrollCtrl.position.maxScrollExtent) {
        if (loading == true || isComplete == true) return;

        setState(() {
          loading = true;
        });

        // await Future.delayed(Duration(seconds: 3));
        // myList.addAll(List.generate(
        //   5,
        //   (index) => "String " + Utils.instance.randomInt().toString(),
        // ));
        await _loadRest(page);
        loading = false;

        setState(() {});
      }
    });
  }

  Future _loadRest([int page = 1]) async {
    print("$page - $totalPages");
    if (totalPages != null && page == totalPages + 1) {
      isComplete = true;
      return;
    }

    Response resp = await get("https://reqres.in/api/users?page=$page");
    var tmp = jsonDecode(resp.body) as Map<String, dynamic>;
    if (totalPages == null) totalPages = tmp['total_pages'];
    if (perPage == null) perPage = tmp['per_page'];

    this.page += 1;

    var data = tmp['data'] as List;
    myList.addAll(data.map((e) => e));

    setState(() {});
    if (myList.length < 13) {
      _loadRest(this.page);
    }
    // Future.delayed(Duration(seconds: 2), () {

    // });
    return true;
  }

  List<Widget> _buildList() {
    List<Widget> tmpList = [];
    tmpList.addAll(
      myList.map(
        (e) => Container(
          // height: 90,
          margin: EdgeInsets.only(bottom: 15),
          child: ListTile(
            // dense: false,
            leading: Container(
              child: CircleAvatar(
                backgroundImage: NetworkImage(e['avatar']),
              ),
            ),
            title: Text(e['first_name']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(e['last_name']),
                Text(e['email']),
              ],
            ),
            trailing: Icon(Icons.arrow_forward),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // retorna um objeto do tipo Dialog
                  return AlertDialog(
                    title: Column(
                      children: [
                        Text(e['first_name'] + " " + e['last_name']),
                        Text(
                          e['email'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        )
                      ],
                    ),
                    content: Container(
                      child: Image.network(
                        e['avatar'],
                        fit: BoxFit.contain,
                      ),
                    ),
                    actions: <Widget>[
                      // define os botões na base do dialogo
                      FlatButton(
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
    // myList.forEach((e) {
    //   tmpList.add(ListTile(
    //     title: Text(e),
    //   ));
    // });
    if (isComplete == true) {
      tmpList.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: Text("Complete"),
      ));
    } else if (loading == true) {
      tmpList.add(Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(15),
        child: CircularProgressIndicator(),
      ));
    } else {
      tmpList.add(SizedBox(
        height: 80,
      ));
    }
    return tmpList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _keyScaf,
      appBar: AppBar(
        title: Text(
          "List Infinity",
        ),
      ),
      body: Container(
        child: ListView(
          controller: _scrollCtrl,
          children: _buildList(),
        ),
      ),
    );
  }
}
