import 'dart:math';

import 'package:flutter/material.dart';
import 'package:listapps/pages/home_page.dart';
import 'package:listapps/pages/list_apps.dart';
import 'package:listapps/pages/test.dart';
import 'package:listapps/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:background_fetch/background_fetch.dart';

// /// This "Headless Task" is run when app is terminated.
// void backgroundFetchHeadlessTask(String taskId) async {
//   print('[BackgroundFetch] Headless event received.');

//   var prefs = await SharedPreferences.getInstance();
//   if (prefs.containsKey("list_bg") == false) {
//     await prefs.setStringList("list_bg", List());
//   }
//   List<String> listBg = prefs.getStringList("list_bg");
//   listBg.add(Random(DateTime.now().millisecondsSinceEpoch).toString());
//   await prefs.setStringList("list_bg", listBg);
//   BackgroundFetch.finish(taskId);
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.instance.prefs = await SharedPreferences.getInstance();

  // await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  List<String> arg;
  MyApp({this.arg});
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  MaterialColor primaryColor = Utils.instance.randomColor();
  Brightness brightness;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brightness = Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'List Apps',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        brightness: brightness,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: HomePage(),
      initialRoute: "/",
      routes: {
        "/": (context) => ListApps(),
        "/home": (context) => HomePage(),
      },
    );
  }
}
