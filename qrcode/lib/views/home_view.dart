import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:qrcode/main.dart';
import 'package:qrcode/services/prefs.dart';
import 'package:qrcode/views/read_qr.dart';
import 'package:qrcode/views/write_qr.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  var _keyTabs = GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  _removeFocus() {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: CustomDrawer(),
        appBar: AppBar(
          title: Text("Qr Code"),
          bottom: TabBar(
            onTap: (value) {
              print(value);
              _removeFocus();
            },
            key: _keyTabs,
            // labelColor: Colors.blue,
            tabs: [
              Tab(
                icon: Icon(Icons.camera_alt),
                text: "Read",
              ),
              Tab(
                icon: Icon(Icons.create),
                text: "Write",
              ),
            ],
          ),
        ),
        body: Container(
          child: TabBarView(
            // dragStartBehavior: DragStartBehavior,
            physics: NeverScrollableScrollPhysics(),
            children: [
              ReadQrView(),
              WriteQrView(),
            ],
          ),
        ),
        // bottomNavigationBar: Container(
        //   child: TabBar(
        //     labelColor: Colors.blue,
        //     tabs: [
        //       Tab(
        //         icon: Icon(Icons.code),
        //         text: "Read",
        //       ),
        //       Tab(
        //         icon: Icon(Icons.code),
        //         text: "Write",
        //       ),
        //     ],
        //   ),
        // ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  @override
  Widget build(BuildContext context) {
    bool isDark = Prefs.instance.prefs.getBool("isDark") == true ? true : false;
    Color primaryColor;
    try {
      primaryColor =
          context.findRootAncestorStateOfType<MyAppState>().primaryColor;
    } catch (e) {
      primaryColor = Colors.blue;
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'QR Code',
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.invert_colors,
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Dark mode',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                Switch(
                  value: isDark,
                  activeColor: primaryColor,
                  onChanged: (value) async {
                    await Prefs.instance.prefs.setBool("isDark", value);
                    try {
                      var state =
                          context.findRootAncestorStateOfType<MyAppState>();
                      if (state != null) {
                        state.setState(() {});
                      }
                    } catch (e) {}
                    // setState(() {});
                  },
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Color',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                ClipOval(
                  child: Material(
                    color: primaryColor,
                    child: InkWell(
                      child: SizedBox(
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  // retorna um objeto do tipo Dialog
                  return AlertDialog(
                    title: Text("Pick a color"),
                    content: SingleChildScrollView(
                      child: Container(
                        height: 250,
                        child: MaterialColorPicker(
                          selectedColor: context
                              .findRootAncestorStateOfType<MyAppState>()
                              .primaryColor,
                          circleSize: 50,
                          onlyShadeSelection: true,
                          onColorChange: (value) async {
                            Navigator.of(context).pop();
                            await Prefs.instance.prefs
                                .setInt("primaryColor", value.value);
                            await Prefs.instance.prefs.setBool("isDark", false);
                            var mAS = context
                                .findRootAncestorStateOfType<MyAppState>();
                            if (mAS != null) {
                              mAS.setState(() {});
                            }
                          },
                        ),
                      ),
                    ),
                    actions: <Widget>[
                      // define os botões na base do dialogo
                      FlatButton(
                        child: Text(
                          "Close",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        color: Colors.red,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
              // MaterialColorPicker();
            },
          ),
        ],
      ),
    );
  }
}
