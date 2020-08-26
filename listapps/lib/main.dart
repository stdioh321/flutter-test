import 'package:animated_splash/animated_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:listapps/pages/list_apps.dart';
import 'package:listapps/provider/admob.dart';
import 'package:listapps/services/NotificationHelper.dart';
import 'package:listapps/services/utils.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  Provider.debugCheckInvalidValueType = null;
  Utils.instance.prefs = await SharedPreferences.getInstance();
  await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  // await BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
  LocalNotificationHandler.instance.init((String payload) {
    print("Payload:::: ${payload}");
  });
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
  MaterialColor primaryColor = Colors.orange;
  Brightness brightness;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    brightness = Brightness.light;
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return AdMobProvider();
      },
      child: MaterialApp(
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
        home: AnimatedSplash(
          home: ListApps(),
          imagePath: "assets/images/splash.gif",
          duration: 2,
        ),
        // initialRoute: "/",
        // routes: {
        //   // "/": (context) => ListApps(),
        //   "/home": (context) => HomePage(),
        // },
      ),
    );
  }
}
