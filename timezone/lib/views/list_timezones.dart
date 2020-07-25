import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_search_bar/simple_search_bar.dart';
import 'package:timezone/providers/timezones.dart';
import 'package:timezone/routes/AppRoutes.dart';
import 'package:timezone/views/timezone-detail.dart';

class ListTimezones extends StatefulWidget {
  @override
  _ListTimezonesState createState() => _ListTimezonesState();
}

class _ListTimezonesState extends State<ListTimezones> {
  List<String> timezones = [];
  Timezones provTimezones;
  AppBarController appBarController = AppBarController();
  @override
  void initState() {
    super.initState();
    // this.provTimezones = Provider.of(context);
    // this._timezones = provTimezones.all;
    // this.timezones = _timezones.toList()';
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    this.provTimezones = Provider.of(context);
    timezones = [...this.provTimezones.timezones];
    // print('didChangeDependencies');
  }

  onSearch(String src) {
    if (this.provTimezones.timezones != null && timezones != null) {
      setState(() {
        timezones = this.provTimezones.timezones.where((e) {
          var tmp = e.toLowerCase().trim();
          return tmp.indexOf(src.trim().toLowerCase()) > -1;
        }).toList();
      });
    }
  }

  Widget buildBody() {
    if (this.provTimezones.loading == true) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (this.provTimezones.timezones == null) {
      return Center(
          child: Column(
        children: [
          Text("An error occurred get the timezones."),
          FlatButton(
            onPressed: () {
              this.provTimezones.loadTimezones();
            },
            child: Text(
              "Retry",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          )
        ],
      ));
    } else if (timezones.length == 0) {
      return Container(
        child: Center(
          child: Text(
            "Nothing",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      );
    } else {
      return Container(
          child: ListView.separated(
        separatorBuilder: (context, index) => Divider(
          color: Theme.of(context).primaryColor,
          height: 0,
        ),
        itemBuilder: (context, index) {
          String timezone = timezones[index];
          return ListTile(
            onTap: () {
              appBarController.stream.add(false);
              Future.delayed(Duration(milliseconds: 50), () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) {
                      return TimezoneDetail();
                    },
                    settings: RouteSettings(
                      arguments: timezone,
                    )));
              });
            },
            dense: true,
            tileColor: index % 2 != 0 ? Colors.grey[200] : null,
            leading: Icon(
              Icons.place,
              color: Theme.of(context).primaryColor,
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            title: Text(
              timezone,
            ),
          );
        },
        itemCount: timezones.length,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        // autoSelected: false,

        searchHint: "Search...",
        mainTextColor: Colors.white,
        onChange: onSearch,

        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("Timezone List"),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.only(right: 15),
                child: Icon(
                  Icons.search,
                ),
              ),
              onTap: () {
                //This is where You change to SEARCH MODE. To hide, just
                //add FALSE as value on the stream
                appBarController.stream.add(true);
              },
            ),
          ],
        ),
      ),
      body: buildBody(),
    );
  }
}
