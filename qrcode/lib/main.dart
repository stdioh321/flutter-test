import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:qrcode/services/prefs.dart';
import 'package:qrcode/services/utils.dart';
import 'package:qrcode/views/home_view.dart';
import 'package:qrcode/views/read_qr.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Prefs.instance.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode themeMode = ThemeMode.light;
  MaterialColor primaryColor = Colors.blue;

  _loadPrefs() {
    try {
      themeMode = Prefs.instance.prefs.getBool('isDark') == true
          ? ThemeMode.dark
          : ThemeMode.light;
      if (Prefs.instance.prefs.getInt('primaryColor') != null) {
        var tmp = Prefs.instance.prefs.getInt('primaryColor');
        primaryColor = MaterialColor(tmp, Utils.instance.color);
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    _loadPrefs();
    return MaterialApp(
      title: 'Qr Code',
      debugShowCheckedModeBanner: false,
      darkTheme: ThemeData(
        // primarySwatch: primaryColor,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: themeMode,
      theme: ThemeData(
        primarySwatch: primaryColor,
        brightness: Brightness.light,
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: primaryColor,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeView(),
    );
  }
}

class TmpView extends StatefulWidget {
  @override
  _TmpViewState createState() => _TmpViewState();
}

class _TmpViewState extends State<TmpView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TMP"),
      ),
      body: Container(
        child: Container(
          child: MaterialColorPicker(
            onColorChange: (Color color) {
              // Handle color changes
            },
            // sezlectedColor: Colors.red,
          ),
        ),
      ),
    );
  }
}
