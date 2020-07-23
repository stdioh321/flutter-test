import 'package:flutter/material.dart';
import 'package:listapps/pages/home_page.dart';
import 'package:listapps/pages/list_apps.dart';
import 'package:listapps/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Utils.instance.prefs = await SharedPreferences.getInstance();

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.

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
