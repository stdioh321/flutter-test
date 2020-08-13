import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class ListItemsView extends StatefulWidget {
  @override
  _ListItemsViewState createState() => _ListItemsViewState();
}

class _ListItemsViewState extends State<ListItemsView> {
  List<String> _myList = [];
  List<String> myList = [];
  var appBarController = AppBarController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _myList = List.generate(30, (index) => "String $index");
    myList = [..._myList];
  }

  _onSearch(String txt) {
    myList = _myList.where((e) {
      String curr = e.trim().toLowerCase();
      txt = txt.trim().toLowerCase();
      return curr.indexOf(txt) > -1;
    }).toList();
    setState(() {});
  }

  Future<List<String>> _getALlPosts(String txt) async {
    var myList = List.generate(20, (index) => "String $index");
    return myList
        .where((e) => e.indexOf(txt.trim().toLowerCase()) > -1)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        mainAppBar: AppBar(
          title: Text(
            "List",
          ),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.only(
                right: 15,
              ),
              child: InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  appBarController.stream.add(true);
                },
              ),
            ),
          ],
        ),
        appBarController: appBarController,
        onChange: _onSearch,
      ),
      body: Container(
        child: myList.length == 0
            ? Center(
                child: Text(
                  "Nothing Found",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
              )
            : ListView.separated(
                separatorBuilder: (context, index) => Divider(
                  height: 2,
                ),
                itemBuilder: (context, index) {
                  var item = myList[index];
                  return ListTile(
                    title: Text(
                      item,
                    ),
                  );
                },
                itemCount: myList.length,
              ),
      ),
    );
  }
}
