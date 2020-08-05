import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:jwtcrud/components/custom_drawer.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text("Home"),
        ),
        body: Center(
          child: Text("Center"),
        ));
  }
}
