import 'dart:convert';

import 'package:boilerplate/components/custom_drawer.dart';
import 'package:boilerplate/routes/routes.dart';
import 'package:boilerplate/services/prefs.dart';
import 'package:boilerplate/services/push_notification_manager.dart';
import 'package:boilerplate/services/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:http/http.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement setState
    super.initState();
  }

  pickColor() async {
    var currColor = Theme.of(context).primaryColor;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text("Pick Color"),
          content: CircleColorPicker(
            initialColor: currColor,
            onChanged: (color) async {
              // print(color);
              Utils.instance.updateStateApp(context, () async {
                await Prefs.instance.prefs
                    .setInt(PrefsItem.primarySwatch, color.value);
                await Prefs.instance.prefs.setBool(PrefsItem.isDark, false);
              });
            },
            size: const Size(240, 240),
            strokeWidth: 8,
            thumbSize: 34,
          ),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton.icon(
              icon: Icon(Icons.exit_to_app),
              color: Colors.red,
              label: Text(
                "Close",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var img = NetworkImage("https://source.unsplash.com/random/300x200");

    // print("Drawer build");
    return Scaffold(
      drawer: CustomDrawer(img: img),
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Text("Center"),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
      floatingActionButton: Container(
        margin: EdgeInsets.only(left: 30),
        alignment: Alignment.bottomLeft,
        // color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FloatingActionButton(
              heroTag: "bt1",
              mini: true,
              onPressed: () async {
                Utils.instance.updateStateApp(context, () async {
                  bool isDark =
                      Prefs.instance.prefs.getBool(PrefsItem.isDark) == true
                          ? true
                          : false;
                  await Prefs.instance.prefs.setBool(PrefsItem.isDark, !isDark);
                  // await Future.delayed(Duration(seconds: 3));
                });
              },
              child: Icon(
                Icons.lightbulb_outline,
              ),
            ),
            FloatingActionButton(
              heroTag: "bt2",
              mini: true,
              onPressed: () async {
                pickColor();

                // Utils.instance.updateStateApp(context, () async {
                //   var mC = Utils.instance
                //       .colorToMaterial(Utils.instance.randomColor());
                //   await Prefs.instance.prefs
                //       .setInt(PrefsItem.primarySwatch, mC.value);
                //   await Prefs.instance.prefs.setBool(PrefsItem.isDark, false);
                // });
              },
              child: Icon(
                Icons.color_lens,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
