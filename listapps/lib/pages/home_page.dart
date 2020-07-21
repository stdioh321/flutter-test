import 'package:device_apps/device_apps.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:listapps/main.dart';
import 'package:listapps/models/joke.dart';
import 'package:listapps/services/api.dart';
import 'package:listapps/services/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Joke joke;
  bool loading = false;
  void getJoke() async {
    // joke = Joke();

    setState(() {
      loading = true;
      joke = null;
    });
    try {
      Joke j = await Api.instance.getJoke();
      // print(j.toJson());
      setState(() {
        joke = j;
      });
    } catch (e) {
      print(e);
    }
    setState(() {
      loading = false;
    });
  }

  Widget buidBody() {
    if (loading) {
      return Center(
        child: Text("Loading",
            style: TextStyle(
              fontSize: 30,
              color: Theme.of(context).primaryColor,
            )),
      );
    } else if (joke != null) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                _launchURL(
                    "https://sv443.net/jokeapi/v2/joke/Any?idRange=${joke.id}-${joke.id}");
              },
              highlightColor: Theme.of(context).primaryColor,
              focusColor: Theme.of(context).primaryColor,
              child: ListTile(
                title: Text(
                  joke.setup != null ? joke.setup : joke.joke,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      // fontSize: 26,
                      ),
                ),
                subtitle: Text(
                  joke.delivery != null ? joke.delivery : "",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    } else
      return Container(
        child: Center(
          child: Text("Nothing"),
        ),
      );
  }

  void _launchURL(String url) async {
    // const url = 'https://flutter.dev';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Apps",
        ),
        backgroundColor: Theme.of(context).primaryColor,
        // centerTitle: false,
      ),
      body: Column(
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            // flex: 1,
            child: Container(
              // color: Colors.red,
              height: 300,
              padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Api: "),
                  InkWell(
                    onTap: () {
                      _launchURL(
                          "https://sv443.net/jokeapi/v2/?ref=apilist.fun");
                    },
                    child: Text(
                      "https://sv443.net/jokeapi/v2/?ref=apilist.fun",
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 20,
            child: buidBody(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getJoke();
        },
        mini: true,
        child: Icon(
          Icons.find_replace,
        ),
      ),
    );
  }
}
