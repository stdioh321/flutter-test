import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PushNotificationsManager {
  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance =
      PushNotificationsManager._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.autoInitEnabled();
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.setAutoInitEnabled(true);
      _firebaseMessaging.subscribeToTopic("all").then((value) {
        print("subscribeToTopic ALL OK");
      }).catchError((err) {
        print("subscribeToTopic ALL ERROR ");
        print(err);
      });
      // _firebaseMessaging.
      _firebaseMessaging.configure(
        onMessage: (message) {
          print("onMessage");
          if (message['data'] != null && message['data']['data1'] != null) {
            Fluttertoast.showToast(
              msg: "Push Notification: " + message['data']['data1'],
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.blue,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          }
          return null;
        },
        onLaunch: (launch) {
          print("onLaunch");
          print(launch);
          return null;
        },
        onResume: (resume) {
          print("onResume");
          print(resume);
          return null;
        },
      );

      // For testing purposes print the Firebase Messaging token
      getToken();
      _initialized = true;
    }
  }

  Future<String> getToken() async {
    String token = await _firebaseMessaging.getToken();
    print("FirebaseMessaging token: $token");
    return token;
  }
}
