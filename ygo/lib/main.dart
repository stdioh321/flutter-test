import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ygo/routes/routes.dart';
import 'package:ygo/services/prefs.dart';
import 'package:ygo/views/card_details.dart';
import 'package:ygo/views/cards_lists.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadBeforeApp();
  runApp(MyApp());
}

_loadBeforeApp() async {
  Prefs.instance.prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ygo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        // primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // home: MyHomePage(title: 'Flutter Demo Home Page'),
      initialRoute: RoutesList.CARDS_LIST,
      routes: {
        RoutesList.CARDS_LIST: (context) => CardsList(),
        RoutesList.CARD_DETAIL: (context) => CardDetails(),
      },
    );
  }
}
