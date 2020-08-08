import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
