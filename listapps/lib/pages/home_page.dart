import 'dart:convert';
import 'dart:io' as io;
import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:flutter/material.dart';
import 'package:listapps/main.dart';
import 'package:listapps/services/utils.dart';
// import 'package:archive/archive.dart';
import 'package:path_provider/path_provider.dart' as pp;
import 'package:permission_handler/permission_handler.dart';
import 'package:charset_converter/charset_converter.dart';
import 'package:device_apps/device_apps.dart';

class HomePage extends StatefulWidget {
  @required
  ApplicationWithIcon app;
  String isUnity;
  String unityTech;

  HomePage({this.app});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    isUnity();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> isUnity() async {
    // print(widget.app.apkFilePath);
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if (status.isDenied) return;

    var tmpFile = io.File(widget.app.apkFilePath);
    if (!(await tmpFile.exists())) {
      Navigator.pop(context);
      return;
    }
    var bytes = tmpFile.readAsBytesSync();
    var archive = ZipDecoder().decodeBytes(bytes);
    for (ArchiveFile aF in archive) {
      if (aF.name.contains(RegExp(r'mono\.so$', caseSensitive: false)))
        widget.unityTech = "Mono";
      else if (aF.name.contains(RegExp(r'ilcpp\.so$', caseSensitive: false)))
        widget.unityTech = "Ilcpp";
      else if (aF.name.contains(RegExp(r'il2cpp\.so$', caseSensitive: false)))
        widget.unityTech = "Il2cpp";

      if (aF.name.toLowerCase() ==
              "assets/bin/Data/Resources/unity_builtin_extra".toLowerCase() ||
          aF.name.toLowerCase() ==
              "assets/bin/Data/unity default resources".toLowerCase()) {
        // print(aF.name);
        List content = aF.content;
        setState(() {
          widget.isUnity = utf8.decode(content.sublist(20, 32));
        });
      }
    }
    setState(() {
      widget.unityTech = widget.unityTech;
    });
  }

  Future<void> getDir() async {
    print(DateTime.now());
    try {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        await Permission.storage.request();
      }
      if (status.isDenied) return;

      var tmpFile = io.File(widget.app.apkFilePath);
      if (!(await tmpFile.exists())) {
        Navigator.pop(context);
        return;
      }
      var bytes = tmpFile.readAsBytesSync();
      var archive = ZipDecoder().decodeBytes(bytes);
      for (ArchiveFile aF in archive) {
        print(aF.name);
      }
    } catch (e) {
      print(e);
    }
    print(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: Container(
          height: 53,
          // child: Text("Anything"),
        ),
        appBar: AppBar(
          title: Text(
            "${widget.app.appName}",
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.play_circle_filled,
              ),
              onPressed: () async {
                bool canPlay = false;
                try {
                  canPlay = await DeviceApps.openApp(widget.app.packageName);
                } catch (e) {}
                if (canPlay == false) {
                  Utils.instance.displayDialog(
                      ctx: context,
                      content: "😭 Unable to open the APP",
                      title: "");
                }
              },
            ),
            // IconButton(
            //   icon: Icon(
            //     Icons.color_lens,
            //   ),
            //   onPressed: () {
            //     try {
            //       context.findAncestorStateOfType<MyAppState>().setState(() {
            //         context.findAncestorStateOfType<MyAppState>().primaryColor =
            //             Utils.instance.randomColor();
            //         print("HERE");
            //       });
            //     } catch (e) {
            //       print(e);
            //     }
            //   },
            // ),
          ],
          // backgroundColor: Theme.of(context).primaryColor,
          // centerTitle: false,
        ),
        body: Container(
          child: ListView(
            children: [
              Container(
                margin: EdgeInsets.only(top: 15),
                padding: EdgeInsets.only(left: 15),
                // color: Colors.red,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.memory(
                      widget.app.icon,
                      width: 120,
                      fit: BoxFit.fill,
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Text(
                  "Name",
                ),
                subtitle: Text(
                  widget.app.appName,
                ),
              ),
              ListTile(
                title: Text(
                  "Package",
                ),
                subtitle: Text(
                  widget.app.packageName,
                ),
              ),
              ListTile(
                title: Text(
                  "Size",
                ),
                subtitle: Text(
                  (() {
                    String result = "Unknow";
                    try {
                      var f = File(widget.app.apkFilePath);
                      // throw Exception('ss');
                      result =
                          (f.lengthSync() / 1024 / 1024).toStringAsFixed(2) +
                              "MB";
                    } catch (e) {}
                    return result;
                  })(),
                ),
              ),
              ListTile(
                title: Text(
                  "Data Directory",
                ),
                subtitle: Text(
                  widget.app.dataDir,
                ),
              ),
              ListTile(
                title: Text(
                  "Version",
                ),
                subtitle: Text(
                  widget.app.versionName,
                ),
              ),
              ListTile(
                title: Text(
                  "Unity",
                ),
                subtitle: Text(
                  widget.isUnity == null ? "Not an Unity app" : widget.isUnity,
                ),
              ),
              widget.isUnity == null || widget.unityTech == null
                  ? Container()
                  : ListTile(
                      title: Text(
                        "Unity Technology",
                      ),
                      subtitle: Text(widget.unityTech),
                    ),
            ],
          ),
        ));
  }
}
