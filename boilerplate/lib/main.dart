import 'dart:convert';

import 'package:boilerplate/routes/app_module.dart';
import 'package:boilerplate/routes/routes.dart';
import 'package:boilerplate/services/firebase_notification_handler.dart';
import 'package:boilerplate/services/prefs.dart';
import 'package:boilerplate/services/push_notification_manager.dart';
import 'package:boilerplate/services/utils.dart';
import 'package:boilerplate/views/list_items_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:flutter/material.dart' hide Router;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterDownloader.initialize(
      debug: true // optional: set false to disable printing logs to console
      );
  await _loadBeforeApp();
  runApp(ModularApp(
    module: AppModule(),
  ));
}

_loadBeforeApp() async {
  Prefs.instance.prefs = await SharedPreferences.getInstance();
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  MaterialColor primarySwatch = Colors.blue;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  @override
  initState() {
    // 9f5ee67d-f3f9-48b4-bf4e-04e1a9ec4511
    _loadFirebasePush();
    _loadOneSignal();
  }

  _loadFirebasePush() {
    PushNotificationsManager().init();
    // _firebaseMessaging.configure(
    //   onMessage: (Map<String, dynamic> message) async {
    //     // setState(() {
    //     //   _messageText = "Push Messaging message: $message";
    //     // });
    //     print("onMessage: $message");
    //   },
    //   onLaunch: (Map<String, dynamic> message) async {
    //     // setState(() {
    //     //   _messageText = "Push Messaging message: $message";
    //     // });
    //     print("onLaunch: $message");
    //   },
    //   onResume: (Map<String, dynamic> message) async {
    //     // setState(() {
    //     //   _messageText = "Push Messaging message: $message";
    //     // });
    //     print("onResume: $message");
    //   },
    // );
    // _firebaseMessaging.requestNotificationPermissions();
    // _firebaseMessaging.requestNotificationPermissions(
    //     const IosNotificationSettings(sound: true, badge: true, alert: true));
    // _firebaseMessaging.onIosSettingsRegistered
    //     .listen((IosNotificationSettings settings) {
    //   print("Settings registered: $settings");
    // });
    // _firebaseMessaging.getToken().then((String token) {
    //   assert(token != null);
    //   print("token");
    //   print(token);
    //   // setState(() {
    //   //   _homeScreenText = "Push Messaging token: $token";
    //   // });
    //   // print(_homeScreenText);
    // });
  }

  _loadOneSignal() {
    OneSignal.shared.init('9f5ee67d-f3f9-48b4-bf4e-04e1a9ec4511');
    OneSignal.shared.setInFocusDisplayType(OSNotificationDisplayType.none);
    OneSignal.shared
        .setNotificationReceivedHandler((OSNotification notification) {
      try {
        print("----------------------------------");
        print(notification.payload.rawPayload['custom']);
        // var json = jsonDecode(notification.jsonRepresentation())
        //     as Map<String, dynamic>;
        // print("----------------------------------");
        // print(json);
        // if (json['custom'] != null) {
        //   print(json['custom']['data']);
        // }
      } catch (e) {}
    });
  }

  _loadConfigs() {
    try {
      if (Prefs.instance.prefs.getBool(PrefsItem.isDark) != null) {
        themeMode = Prefs.instance.prefs.getBool(PrefsItem.isDark) == true
            ? ThemeMode.dark
            : ThemeMode.light;
      }
      if (Prefs.instance.prefs.getInt(PrefsItem.primarySwatch) != null) {
        var tmp = Prefs.instance.prefs.getInt(PrefsItem.primarySwatch);
        primarySwatch = MaterialColor(tmp, Utils.instance.color);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _loadConfigs();
    return MaterialApp(
      title: 'Boilerplate',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ThemeData(
        primarySwatch: primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primarySwatch,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: primarySwatch,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // initialRoute: "/list",
      // home: ListItemsView(),
      initialRoute: Routes.HOME,
      navigatorKey: Modular.navigatorKey,
      onGenerateRoute: Modular.generateRoute,
    );
  }
}
