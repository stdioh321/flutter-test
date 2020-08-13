import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseNotifications {
  FirebaseMessaging _firebaseMessaging;

  final void Function(String) callback;

  FirebaseNotifications(this.callback);

  void setUpFirebase() {
    _firebaseMessaging = FirebaseMessaging();
    firebaseCloudMessaging_Listeners();
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("token: $token");
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("on message $message");

        for (var keys in message.keys) {
          if (keys == "data") {
            print('$keys was written by ${message[keys]}');
            String valueData = message[keys].toString();
            if (valueData.indexOf("ricardo") > 0) {
              callback("ricardo");
            } else if (valueData.indexOf("livia") > 0) {
              callback("livia");
            } else if (valueData.indexOf("unknown") > 0) {
              callback("forasteiro");
            } else if (valueData.indexOf("jana") > 0) {
              callback("jana");
            }
          }
        }
      },
      onResume: (Map<String, dynamic> message) async {},
      onLaunch: (Map<String, dynamic> message) async {},
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
