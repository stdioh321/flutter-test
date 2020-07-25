import 'dart:async';

import 'package:flutter/material.dart';

class TestView extends StatefulWidget {
  @override
  _TestViewState createState() => _TestViewState();
}

class _TestViewState extends State<TestView> {
  // final myStream = NumberCreaatro

  Future<int> sumStrem(Stream<int> stream) async {
    var sum = 0;
    await for (var val in stream) {
      sum += val;
    }
    return sum;
  }

  Stream<int> countStream(int to) async* {
    var myList = [1, 1, 2, 2, 3, 4, 5, 6, 7, 8, 9, 1, 2, 3];
    for (int i = 0; i < myList.length; i++) {
      yield myList[i];
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    execExample();
    // sumStrem(countStream(10)).;
  }

  void execExample() {
    // NumberController nc = NumberController(stop: 5);
    // nc.stream.listen((event) {
    //   print(event);
    // }).onDone(() {
    //   print('Done');
    // });
    countNumbers().listen((ev) {
      print(ev);
    });
  }

  Stream countNumbers({int stop = 10}) async* {
    for (int i = 1; i <= stop; i++) {
      await Future.delayed(Duration(seconds: 1));
      print("After $i");
      yield i;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Test"),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(
                  Icons.home,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.access_time,
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: List.generate(
              2,
              (index) => Container(
                    child: Center(
                      child: Text("Random $index"),
                    ),
                  )),
        ),
      ),
    );
  }
}

class NumberController {
  var _count = 1;
  final _controller = StreamController<int>();

  NumberController({int seconds = 1, int stop}) {
    Timer.periodic(Duration(seconds: seconds), (timer) {
      if ((_count - 1) == stop) _controller.sink.close();
      if (!_controller.isClosed) {
        _controller.sink.add(_count);
        _count++;
      }
    });
  }

  Stream<int> get stream => _controller.stream;
}
