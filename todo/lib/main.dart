import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:todo/models/item.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Todo App",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  List<Item> items = List<Item>();
  bool loading = true;
  HomePage() {
    items = [];
    final int tot = 3;

    // for (int i = 0; i < tot; i++) {
    //   items.add(Item(
    //       title: "Item " + (i + 1).toString(),
    //       done: i % 2 == 0 ? true : false));
    // }
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var newTaskCtrl = TextEditingController();
  var focusNode = FocusNode();

  _HomePageState() {
    _loadItems();
  }

  void _saveItem() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(widget.items));
  }

  Future<void> _loadItems() async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');

    if (data != null) {
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        widget.items = result;
      });
    }
    // log("Loaded");
    setState(() {
      widget.loading = false;
    });
  }

  void _addItem() {
    if (newTaskCtrl.text.isEmpty) {
      setState(() {
        focusNode.requestFocus();
        SystemChannels.textInput.invokeMethod('TextInput.show');
      });
      // FocusScope.of(context).requestFocus(focusNode);
      return;
    }
    setState(() {
      widget.items.add(Item(title: newTaskCtrl.text, done: false));
      newTaskCtrl.clear();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      focusNode.nextFocus();
      log(SystemChannels.platform.name);
      _saveItem();
    });
  }

  void _removeItem(int index) {
    setState(() {
      widget.items.removeAt(index);
      _saveItem();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          autofocus: false,
          focusNode: focusNode,
          controller: newTaskCtrl,
          keyboardType: TextInputType.text,
          // maxLength: 20,
          // initialValue: "Nova",
          // textAlign: TextAlign.start,
          decoration: InputDecoration(
              labelText: "Nova Tarefa",
              alignLabelWithHint: true,
              // icon: Icon(
              //   Icons.text_fields,
              //   color: Colors.white,
              // ),
              labelStyle: TextStyle(
                color: Colors.white,
              )),
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        // leading: Icon(Icons.menu),
        actions: [
          // Icon(Icons.ac_unit),
          // Icon(Icons.access_alarm),
        ],
      ),
      body: ListView.builder(
        itemCount: widget.items.length,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = widget.items[index];
          return Dismissible(
            key: Key(item.title + "_" + index.toString()),
            background: Container(
              color: Colors.red.withOpacity(0.9),
              child: Container(
                alignment: Alignment.centerLeft,
                child: Icon(
                  Icons.remove_circle,
                  color: Colors.white,
                ),
              ),
            ),
            onDismissed: (dir) {
              // if (DismissDirection.endToStart == dir) return;
              _removeItem(index);
            },
            child: CheckboxListTile(
              title: Text(item.title),
              value: item.done,
              onChanged: (value) {
                setState(() {
                  item.done = value;
                  _saveItem();
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {_addItem()},
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Tmp Flutter Demo ',
//       theme: ThemeData(
//           // This is the theme of your application.
//           //
//           // Try running your application with "flutter run". You'll see the
//           // application has a blue toolbar. Then, without quitting the app, try
//           // changing the primarySwatch below to Colors.green and then invoke
//           // "hot reload" (press "r" in the console where you ran "flutter run",
//           // or simply save your changes to "hot reload" in a Flutter IDE).
//           // Notice that the counter didn't reset back to zero; the application
//           // is not restarted.
//           // This makes the visual density adapt to the platform that you run
//           primarySwatch: Colors.red,

//           // the app on. For desktop platforms, the controls will be smaller and
//           // closer together (more dense) than on mobile platforms.
//           visualDensity: VisualDensity.standard),
//       home: MyHomePage(
//           tmp: 'abc',
//           title:
//               'Flutter Deeemo Home Page CHANGEDFlutter Deeemo Home Page CHANGEDFlutter Deeemo Home Page CHANGED'),
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title, this.tmp}) : super(key: key);

//   // This widget is the home page of your application. It is stateful, meaning
//   // that it has a State object (defined below) that contains fields that affect
//   // how it looks.

//   // This class is the configuration for the state. It holds the values (in this
//   // case the title) provided by the parent (in this case the App widget) and
//   // used by the build method of the State. Fields in a Widget subclass are
//   // always marked "final".

//   final String title;
//   final String tmp;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   Iterable<Contact> _contacts;

//   @override
//   void initState() {
//     super.initState();
//     _askPermissions();
//   }

//   void _incrementCounter() {
//     setState(() {
//       // This call to setState tells the Flutter framework that something has
//       // changed in this State, which causes it to rerun the build method below
//       // so that the display can reflect the updated values. If we changed
//       // _counter without calling setState(), then the build method would not be
//       // called again, and so nothing would appear to happen.
//       _counter++;
//     });
//   }

//   void _decrementCounter() {
//     setState(() {
//       if (_counter <= 0) {
//         _showAlert();
//         return;
//       }
//       _counter--;
//     });
//   }

//   Future<void> _askPermissions() async {
//     PermissionStatus permissionStatus = await Permission.contacts.request();
//   }

//   Future<void> _checkPermission(Permission p) async {
//     return await p.isGranted;
//   }

//   Future<PermissionStatus> _handlePermission(Permission p) async {
//     if (await p.isGranted)
//       return await p.status;
//     else
//       return await p.request();
//   }

//   Future<void> _getContacts() async {
//     try {
//       PermissionStatus ps = await _handlePermission(Permission.contacts);
//       if (!ps.isGranted) throw new Exception('Contact permission not granted');
//       final Iterable<Contact> contacts = await ContactsService.getContacts();
//       contacts.forEach((element) {
//         if (element.phones.isEmpty) return false;
//         var p = element.phones.elementAt(0);
//         log(p.label + ": " + p.value);
//       });
//       setState(() {
//         _contacts = contacts;
//       });
//     } catch (e) {
//       log(e.toString());
//     }
//   }

//   void _showAlert() {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: new Text("Can't go bellow zero "),
//             actions: <Widget>[
//               new FlatButton(
//                   color: Colors.red,
//                   onLongPress: () {
//                     Navigator.of(context).pop();
//                   },
//                   onPressed: () {},
//                   child: new Text('Close')),
//             ],
//           );
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // This method is rerun every time setState is called, for instance as done
//     // by the _incrementCounter method above.
//     //
//     // The Flutter framework has been optimized to make rerunning build methods
//     // fast, so that you can just rebuild anything that needs updating rather
//     // than having to individually change instances of widgets.
//     return Scaffold(
//         appBar: AppBar(
//             // Here we take the value from the MyHomePage object that was created by
//             // the App.build method, and use it to set our appbar title.

//             title: Text(widget.title)),
//         body: Center(
//           // Center is a layout widget. It takes a single child and positions it
//           // in the middle of the parent.

//           child: Column(
//             // Column is also a layout widget. It takes a list of children and
//             // arranges them vertically. By default, it sizes itself to fit its
//             // children horizontally, and tries to be as tall as its parent.
//             //
//             // Invoke "debug painting" (press "p" in the console, choose the
//             // "Toggle Debug Paint" action from the Flutter Inspector in Android
//             // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
//             // to see the wireframe for each widget.
//             //
//             // Column has various properties to control how it sizes itself and
//             // how it positions its children. Here we use mainAxisAlignment to
//             // center the children vertically; the main axis here is the vertical
//             // axis because Columns are vertical (the cross axis would be
//             // horizontal).
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(widget.tmp),
//               new Container(
//                 child: new Image.asset(
//                   "assets/images/fun.gif",
//                   alignment: Alignment.topRight,
//                   height: 100,
//                 ),
//               ),
//               Text(
//                 'You have pushed the button this many times:',
//               ),
//               Text(
//                 '$_counter',
//                 style: Theme.of(context).textTheme.headline1,
//               ),
//             ],
//           ),
//         ),
//         floatingActionButton: Row(
//           // crossAxisAlignment: CrossAxisAlignment.stretch,
//           mainAxisAlignment: MainAxisAlignment.end,
//           // textDirection: TextDirection.rtl,
//           children: <Widget>[
//             SizedBox(
//                 // width: 10,
//                 ),
//             FloatingActionButton(
//               onPressed: _incrementCounter,
//               tooltip: 'Increment',
//               child: Icon(Icons.add),
//             ),
//             FloatingActionButton(
//                 onPressed: _decrementCounter,
//                 tooltip: "Decrement",
//                 child: Icon(
//                   Icons.remove,
//                 )),
//             FloatingActionButton(
//                 onPressed: _getContacts,
//                 tooltip: "Contacts",
//                 child: Icon(
//                   Icons.contacts,
//                 ))
//           ],
//         ));
//   }
// }
