import 'package:flutter/material.dart';
import 'package:listapps/pages/choose_location.dart';
import 'package:listapps/pages/home_page.dart';
import 'package:listapps/pages/loading_page.dart';
import 'package:listapps/pages/location_detail.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  Color primaryColor = Colors.green[800];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      // home: HomePage(),
      initialRoute: "/",
      routes: {
        // "/loading": (context) => LoadingPage(),
        "/": (context) => HomePage(),
        "/location-detail": (context) => LocationDetailPage(),
      },
    );
  }
}
