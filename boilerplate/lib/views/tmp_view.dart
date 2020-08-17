import 'dart:async';
import 'dart:convert';

import 'package:boilerplate/models/gan_hou.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:load/load.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TmpView extends StatefulWidget {
  @override
  _TmpViewState createState() => _TmpViewState();
}

class _TmpViewState extends State<TmpView> {
  var _refreshCtrl = RefreshController(initialRefresh: false);
  int page = 1;
  int perPage = 10;
  int totPage;
  List<GanHou> _items = [];

  @override
  initState() {
    super.initState();
    Timer.run(() {
      _refreshCtrl.requestLoading(needMove: false);
    });
    // _loadData();
    // _refreshCtrl.requestLoading();
  }

  _onLoading() async {
    print("_onLoading");

    await _loadData();
  }

  _onRefresh() async {
    print("_onRefresh");
    page = 1;
    totPage = null;
    _items = [];
    setState(() {});
    await _loadData();
    _refreshCtrl.refreshCompleted();
  }

  _loadData() async {
    print("_loadData");
    try {
      // showLoadingDialog();
      if (totPage != null && (totPage + 1) == page) {
        _refreshCtrl.loadNoData();
        return;
        // return LoadStatus.noMore;
      }
      // if (_refreshCtrl.isLoading == true) {
      //   // _refreshCtrl.lo
      //   return;
      // }
      String url =
          "https://gank.io/api/v2/data/category/GanHuo/type/Android/page/$page/count/$perPage";
      print(url);
      Response resp = await get(url);
      if (resp.statusCode != 200) {
        _refreshCtrl.loadFailed();
        // return LoadStatus.failed;
        throw Exception("Not 200");
      }
      var tmp = jsonDecode(resp.body) as Map<String, dynamic>;
      page += 1;
      totPage = tmp['page_count'];
      // print(tmp['data'][0]['images'][0]);
      var data = tmp['data'] as List;
      print(data);
      _items.addAll(
        data.map((e) {
          return GanHou.fromJson(e);
        }),
      );
      // print(_items);
      _refreshCtrl.loadComplete();
      // return LoadStatus.canLoading;
    } catch (e) {
      _refreshCtrl.loadFailed();
      // return LoadStatus.failed;
    }
    // hideLoadingDialog();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text("TMP"),
    //   ),
    //   body: Column(children: <Widget>[
    //     SizedBox(height: 20.0),
    //     ExpansionTile(
    //       title: Text(
    //         "Title",
    //         style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    //       ),
    //       children: <Widget>[
    //         ExpansionTile(
    //           title: Text(
    //             'Sub title',
    //           ),
    //           children: <Widget>[
    //             ListTile(
    //               title: Text('Data'),
    //               subtitle: Text('subData'),
    //             )
    //           ],
    //         ),
    //         ListTile(
    //           title: Text('DATA'),
    //         )
    //       ],
    //     )
    //   ]),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text("TMP"),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: SmartRefresher(
              controller: _refreshCtrl,
              onLoading: _onLoading,
              onRefresh: _onRefresh,
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  try {
                    print("footer");
                    if (mode == LoadStatus.idle) {
                      body = Text("pull up load");
                    } else if (mode == LoadStatus.loading) {
                      body = CircularProgressIndicator();
                    } else if (mode == LoadStatus.failed) {
                      body = Text("Load Failed!Click retry!");
                    } else if (mode == LoadStatus.canLoading) {
                      body = Text("release to load more");
                    } else {
                      body = Text("No more Data");
                    }
                    return Container(
                      height: 55.0,
                      // width: MediaQuery.of(context).size.width,
                      // color: Colors.red,
                      child: Center(child: body),
                    );
                  } catch (e) {
                    return Container(
                      height: 55.0,
                      child: Center(child: body),
                    );
                  }
                },
              ),
              child: ListView.separated(
                separatorBuilder: (context, index) => Divider(height: 1),
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  var item = _items[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).primaryColor,
                      radius: 30,
                      child: CircleAvatar(
                        backgroundImage: item.images.length > 0
                            ? NetworkImage(item.images[0])
                            : AssetImage("assets/images/image_404.png"),
                        radius: 25,
                      ),
                    ),
                    title: Text(item.author),
                    subtitle: Text(item.type),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      _onSelected(item);
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            height: 200,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  ExpansionTile(
                    title: Text(
                      "Title",
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    children: <Widget>[
                      ExpansionTile(
                        title: Text(
                          'Sub title',
                        ),
                        children: <Widget>[
                          ListTile(
                            title: Text('data'),
                          )
                        ],
                      ),
                      ListTile(
                        title: Text('data'),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1),
            ),
            child: Text("SSS2"),
          ),
        ],
      ),
    );
  }

  _onSelected(GanHou item) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: Text(
            "${item.author}",
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          content: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(),
              Container(
                child: Text("Title: " + item.title),
                alignment: Alignment.centerLeft,
              ),
              Container(
                  child: Text("Published at: " + item.publishedAt),
                  alignment: Alignment.centerLeft),
              Container(
                  child: Text("Category: " + item.category),
                  alignment: Alignment.centerLeft),
              Container(
                  child: Text("Type: " + item.type),
                  alignment: Alignment.centerLeft),
              Container(
                  child: Text("Views: " + item.views.toString()),
                  alignment: Alignment.centerLeft),
              Container(
                  child: Text("Desc: " + item.desc),
                  alignment: Alignment.centerLeft),
              Column(
                children: item.images.length < 1
                    ? [
                        Image.asset("assets/images/image_404.png"),
                      ]
                    : item.images.map((e) {
                        return Container(
                            constraints: BoxConstraints(maxHeight: 200),
                            child: Image.network(e, fit: BoxFit.contain));
                      }).toList(),
              ),
            ],
          )),
          actions: <Widget>[
            // define os botões na base do dialogo
            FlatButton(
              child: Text(
                "Close",
                style: TextStyle(color: Colors.white),
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
  }
}
