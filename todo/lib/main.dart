import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/item.dart';

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

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  List<Item> items = List<Item>();
  bool loading = true;
  HomePage() {
    items = [];
  }

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController newTaskCtrl = TextEditingController();
  FocusNode focusNode = FocusNode();

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
    try {
      if (newTaskCtrl.text.isEmpty) {
        setState(() {
          focusNode.requestFocus();
          if (Platform.isAndroid || Platform.isIOS || !kIsWeb)
            SystemChannels.textInput.invokeMethod('TextInput.show');
          return;
        });
        // FocusScope.of(context).requestFocus(focusNode);

      } else {
        setState(() {
          widget.items.add(Item(title: newTaskCtrl.text, done: false));
          newTaskCtrl.clear();
          SystemChannels.textInput.invokeMethod('TextInput.hide');
          focusNode.nextFocus();
          // log(SystemChannels.platform.name);
          _saveItem();
        });
      }
    } catch (e) {
      print(e);
    }
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
          onFieldSubmitted: (str) {
            _addItem();
          },
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
