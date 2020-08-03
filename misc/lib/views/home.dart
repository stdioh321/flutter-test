import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView>
    with SingleTickerProviderStateMixin {
  bool val = false;
  TabController tControler;
  @override
  void initState() {
    super.initState();
    tControler = TabController(
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    // if (val == false) {
    //   return CupertinoApp(

    //   );
    // }
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 200,
            forceElevated: true,
            title: Text('Random'),
            backgroundColor: Colors.orange[200],
            // onStretchTrigger: () {
            //   print("onStretchTrigger");
            // },
            bottom: TabBar(
              tabs: [
                Tab(text: "Tab1"),
                Tab(text: "Tab2"),
              ],
              controller: tControler,
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                "https://i.picsum.photos/id/47/500/300.jpg?hmac=GpRIuQ9UPQQAF5iZh8MN7NyH3G9okvPootIKDdydjwY",
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
            return ListTile(
              title: Text("Someting $index"),
            );
          }, childCount: 30)),
          SliverFillRemaining(
            child: TabBarView(
              children: [
                Container(
                  color: Colors.red,
                  child: Text('Tab 1'),
                ),
                Text('Tab 2'),
              ],
              controller: tControler,
            ),
          ),
          SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                return Container(
                  color: Colors.purple[100 * (index % 9)],
                  child: Text("Grid $index"),
                );
              }, childCount: 30),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              )),
          SliverFixedExtentList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return ListTile(
                  title: Text("Text"),
                  subtitle: Text(
                    "Index: $index",
                  ),
                );
              },
              childCount: 20,
            ),
            itemExtent: 50,
          )
        ],
      ),
    );
  }
}

class GenerateNumber {
  int _count = 1;
  StreamController<int> _controller = StreamController<int>();
  GenerateNumber({int stop, int seconds = 1}) {
    Timer.periodic(Duration(seconds: seconds), (timer) {
      if (stop != null && (_count - 1) == stop) {
        _controller.close();
        return;
      }
      _controller.sink.add(_count);
      _count++;
    });
  }

  Stream<int> get stream => _controller.stream;
}
