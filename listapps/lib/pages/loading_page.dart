import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:listapps/models/post.dart';
import 'package:listapps/models/time.dart';
import 'package:listapps/services/api.dart';
import 'package:listapps/services/world_time.dart';

class LoadingPage extends StatefulWidget {
  List<Post> _postList = [];
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();
    // _getPosts();
    _getTime();
  }

  void _getTime() async {
    try {
      WorldTime wt = await WorldTime.getWT("Europe/London");
      print(wt.time);
    } catch (e) {
      print(e);
    }
  }

  void _getPosts() async {
    Response data1 = await get('https://jsonplaceholder.typicode.com/posts/1');
    Map<String, dynamic> d1 = jsonDecode(data1.body);
    print((d1['title']));
    Response data = await get('https://jsonplaceholder.typicode.com/posts');
    var d = jsonDecode(data.body);
    Navigator.of(context).pushReplacementNamed(
      "/home",
      arguments: d,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Timer(Duration(seconds: 5), () {

    // });
    return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Image.asset(
            "assets/images/loading_bg_black.gif",
            fit: BoxFit.contain,
          ),
        ));
  }
}
