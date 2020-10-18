import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tmp/controllers/Controller.dart';
import 'package:tmp/main.dart';

class ContactPage extends StatefulWidget {
  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final ctrl = Controller();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contact"),
      ),
      body: Container(
        child: Center(
          child: Text("${ctrl?.numClicks}" ?? "Contact"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).pushReplacementNamed("/");
          },
          child: Icon(
            Icons.home,
          )),
    );
  }
}
