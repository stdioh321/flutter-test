import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:misc/providers/auth.dart';
import 'package:misc/routes/app_routes.dart';
import 'package:misc/views/home.dart';
import 'package:misc/views/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  var prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  SharedPreferences prefs;
  MyApp({SharedPreferences this.prefs}) {
    // print(prefs.getString("login"));
  }

  @override
  build(BuildContext context) {
    // return CupertinoApp(
    //   debugShowCheckedModeBanner: false,
    //   theme: CupertinoThemeData(
    //     // primaryColor: Colors.z',
    //     // primaryContrastingColor: Colors.z',
    //     brightness: Brightness.light,
    //   ),
    //   home: CupertinoHome(),
    // );
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        // var prefs = await SharedPreferences.getInstance();
        print("Create AuthProvider");
        return AuthProvider(
          prefs: prefs,
        );
      },
      child: MaterialApp(
        title: 'Misc',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // brightness: Brightness.dark,
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: AppRoutes.LOGIN,
        routes: {
          AppRoutes.HOME: (_) => HomeView(),
          AppRoutes.LOGIN: (_) => LoginView(),
        },
        // home: HomeView(),
      ),
    );
  }
}

class CupertinoHome extends StatefulWidget {
  @override
  _CupertinoHomeState createState() => _CupertinoHomeState();
}

class _CupertinoHomeState extends State<CupertinoHome> {
  List<String> myList = List.generate(100, (index) => index.toString());
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: Icon(Icons.adb),
        middle: Text("Title"),
      ),
      child: SafeArea(
        child: Container(),
      ),
    );
  }
}
