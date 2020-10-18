import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmp/controllers/Controller.dart';
import 'package:tmp/pages/Contact.dart';
import 'package:tmp/pages/Home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (BuildContext context) async {
        await Future.delayed(Duration(seconds: 3));
        return Controller();
      },
      child: MaterialApp(
        title: 'Tmp',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
          buttonColor: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: "/",
        routes: {
          "/": (_) => Home(),
          "/contact": (_) => ContactPage(),
        },
      ),
    );

    return MaterialApp(
      title: 'Tmp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        buttonColor: Colors.amber,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: "/",
      routes: {
        "/": (_) => Home(),
        "/contact": (_) => ContactPage(),
      },
    );
  }
}

class MyModel {
  //                                               <--- MyModel
  String someValue = 'Hello';
  void doSomething() {
    someValue = 'Goodbye';
    print(someValue);
  }

  void editValue([String newVal = "nothing"]) {
    this.someValue = newVal;
  }
}
