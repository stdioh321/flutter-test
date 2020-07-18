import 'dart:math';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.blue),
      routes: {
        '/': (context) => FirstPage(),
        '/second': (context) => SecondPage(),
      },
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Page"),
      ),
      body: Center(
        child: RaisedButton(
          color: Colors.red,
          child: Text(
            "First Page",
            style: TextStyle(
              color: Colors.white,
              fontSize: 50,
              letterSpacing: 5,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pushNamed(
              "/second",
              arguments: MyArgs('Abc'),
            );
          },
        ),
      ),
    );
  }
}

class MyArgs {
  String title;
  MyArgs(this.title);
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => SecondPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var tween = Tween(begin: begin, end: end);
      var offsetAnimation = animation.drive(tween);
      return child;
    },
  );
}

class SecondPage extends StatefulWidget {
  int counter = 0;

  SecondPage() {
    this._startCamera();
  }
  void _startCamera() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

// Obtain a list of the available cameras on the device.
      final cameras = await availableCameras();

// Get a specific camera from the list of available cameras.
      final firstCamera = cameras.first;
      print(firstCamera.sensorOrientation);
      var controller = CameraController(firstCamera, ResolutionPreset.medium);
      await controller.initialize();
      final path =
          join((await getDownloadsDirectory()).path, '${DateTime.now()}.png');
      controller.takePicture(path);
      print(path);
    } catch (e) {
      print(e);
    }
  }

  @override
  _SecondPageState createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  @override
  Widget build(BuildContext context) {
    final MyArgs args = ModalRoute.of(context).settings.arguments;
    print(args.title);
    return Scaffold(
        drawer: Drawer(
          // Add a ListView to the drawer. This ensures the user can scroll
          // through the options in the drawer if there isn't enough vertical
          // space to fit everything.
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(
                  'Drawer Header',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50,
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Item 1'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
              ListTile(
                title: Text('Item 2'),
                onTap: () {
                  // Update the state of the app.
                  // ...
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 30,
                ),
              ),
              Text(
                " Second Page: " + widget.counter.toString(),
              )
            ],
          ),
          backgroundColor:
              widget.counter % 2 == 0 ? Colors.green : Colors.black,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  child: Column(
                    children: [
                      Text('CARD'),
                      Text('CARD'),
                      Text('CARD'),
                      Text(
                        'CARD',
                        style: TextStyle(fontSize: 100, color: Colors.red),
                      ),
                      Text('CARD'),
                      Text('CARD'),
                      Text('CARD'),
                      Text('CARD'),
                      Text('CARD'),
                    ],
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 400.0,
                    aspectRatio: 2,
                    autoPlay: true,
                  ),
                  items: [1, 2, 3, 4, 5].map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          child: Image.network(
                            'https://picsum.photos/200/300?r=' +
                                Random(i).toString(),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Image.network(
                  "https://i.stack.imgur.com/Aysma.png",
                  scale: 2,
                ),
                Image.asset(
                  'assets/images/fun.gif',
                  fit: BoxFit.cover,
                ),
                RaisedButton(
                  child: Text("Second Page"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                RaisedButton(
                  child: Text("Add"),
                  onPressed: () {
                    setState(() {
                      widget.counter++;
                    });
                  },
                ),
                Text(
                  widget.counter.toString(),
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 80,
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AppList'),
      ),
      body: Container(
        child: Container(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Container 1")],
            ),
          ),
        ),
      ),
    );
  }
}
