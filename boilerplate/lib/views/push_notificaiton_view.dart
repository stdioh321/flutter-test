import 'dart:convert';

import 'package:boilerplate/services/push_notification_manager.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class PushNotificationView extends StatefulWidget {
  @override
  _PushNotificationViewState createState() => _PushNotificationViewState();
}

class _PushNotificationViewState extends State<PushNotificationView> {
  String _token;
  String data1 = "Test";
  bool loading = false;
  @override
  void initState() {
    // TODO: implement setState
    super.initState();
    // myList = [...List.generate(20, (index) => "String $index")];
    // print(myList);
    _loadToken();
  }

  _loadToken() async {
    try {
      _token = await PushNotificationsManager().getToken();

      setState(() {});
    } catch (e) {
      _token = null;
      print("Unable to get token");
      print(e);
    }
  }

  _onSendPush() async {
    if (loading == true) return;
    loading = true;
    setState(() {});
    try {
      Map<String, dynamic> json = {
        "notification": {
          "body": "Corpo da notificação",
          "title": "Titulo notificação"
        },
        "priority": "high",
        "data": {
          "click_action": "FLUTTER_NOTIFICATION_CLICK",
          "data1": (data1 != null ? data1 : "")
        },
        "to": "$_token"
      };
      print(json);
      Response resp = await post(
        "https://fcm.googleapis.com/fcm/send",
        headers: {
          "Content-Type": "application/json",
          "Authorization":
              "key=AAAAov0vHOg:APA91bHCPS5lROImy83Mf_xH-zcDDyUdza3Y1qb2YzT_cirGrXMP91_AHJBAJ-rtUuJqKjwBMvSIqVoK6rt_HOJEE5ebgyKp010kqz3olUWGjfzpSup0NduP0K8pi5lr_YcKKfiR3kiE"
        },
        body: jsonEncode(json),
      );
      print(resp.body);
    } catch (e) {
      print(e);
    }
    loading = false;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Push Notificaiton",
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _token == null
                ? []
                : [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Data1",
                      ),
                      onChanged: (value) => data1 = value,
                      initialValue: data1,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    (loading == true
                        ? CircularProgressIndicator()
                        : RaisedButton.icon(
                            onPressed: _onSendPush,
                            icon: Icon(
                              Icons.mobile_screen_share,
                            ),
                            label: Text(
                              "Send Push Notification",
                            ),
                          )),
                    SizedBox(
                      height: 100,
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}
