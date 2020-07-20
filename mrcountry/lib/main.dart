import 'package:flutter/material.dart';
import 'package:mrcountry/pages/choose_location.dart';
import 'package:mrcountry/pages/home_page.dart';
import 'package:mrcountry/pages/loading_page.dart';
import 'package:mrcountry/pages/location_detail.dart';
import 'package:mrcountry/services/utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splashscreen/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(App(prefs: prefs));
}

class App extends StatefulWidget {
  SharedPreferences prefs;
  App({this.prefs});

  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Color primaryColor;
  Brightness brightness;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    this.primaryColor = Utils.instance.randomColor();
    this.brightness = widget.prefs.getBool("isDark") ?? false
        ? Brightness.dark
        : Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    // Utils.instance.primaryColor = Utils.instance.randomColor();
    return MaterialApp(
        title: "Mr. Country",
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: primaryColor,
          brightness: brightness,
        ),
        home: _splachScreen(context: context)
        // initialRoute: "/",
        // routes: {
        //   // "/loading": (context) => LoadingPage(),
        //   "/": (context) => HomePage(),
        //   "/location-detail": (context) => LocationDetailPage(),
        // },
        );
  }
}

Widget _splachScreen({BuildContext context}) {
  return SplashScreen(
    seconds: 6,
    loadingText: Text(
      "Loading",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    navigateAfterSeconds: HomePage(),
    image: Image.asset(
      "assets/splash.gif",
      fit: BoxFit.fill,
    ),
    photoSize: 160.0,
    backgroundColor: Color.fromARGB(255, 70, 66, 110),
    loaderColor: Colors.white,
    onClick: () {
      print(context);
    },
  );
}

Widget _introScreen() {
  return Stack(
    children: <Widget>[
      SplashScreen(
        backgroundColor: Color.fromARGB(255, 70, 66, 110),
        seconds: 6,
        gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color.fromARGB(255, 70, 66, 110),
              Color.fromARGB(255, 70, 66, 110),
            ]),
        navigateAfterSeconds: HomePage(),
        loaderColor: Colors.transparent,
        onClick: () {},
      ),
      Container(
        color: Color.fromARGB(255, 70, 66, 110),
        child: Center(
          child: Image.asset(
            "assets/splash.gif",
            fit: BoxFit.contain,
          ),
        ),
        // decoration: BoxDecoration(
        //   image: DecorationImage(
        //     image: AssetImage("assets/splash.gif"),
        //     fit: BoxFit.none,
        //   ),
        // ),
      ),
    ],
  );
}
