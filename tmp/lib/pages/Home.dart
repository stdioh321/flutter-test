import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';
import 'package:tmp/controllers/Controller.dart';
import 'package:tmp/main.dart';
import 'package:tmp/providers/Counter.dart';

final counter = Counter();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // final ctrl = Controller();

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ctrl = Controller();
    return Scaffold(
      appBar: AppBar(
        title: Text("Tmp"),
        actions: [
          IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/contact");
              })
        ],
      ),
      body: Observer(
        builder: (_) {
          return Container(
            child: Center(child: Text("Value: ${ctrl?.numClicks}")),
          );
        },
      ),
      floatingActionButton:
          FloatingActionButton(onPressed: doGetTest, child: Icon(Icons.add)),
    );
  }

  doGetTest() async {
    String msg = "Unknow error";
    try {
      Response resp = await get("http://192.168.1.5:9999");
      print("Response:");
      print(resp.statusCode);
      print(resp.headers);
      msg = "Success";
    } on SocketException catch (e) {
      msg = "${e?.osError?.message}: ${e?.osError?.errorCode}";
    } catch (e) {
      // msg = "Unknow error";
    }
    print(msg);
  }
}
