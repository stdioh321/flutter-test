import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';
import 'package:listapps/pages/home_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class ListApps extends StatefulWidget {
  @override
  _ListAppsState createState() => _ListAppsState();
}

class _ListAppsState extends State<ListApps> {
  List<ApplicationWithIcon> _apps = [];
  List<ApplicationWithIcon> apps = [];
  bool loading = false;
  AppBarController appBarController = AppBarController();
  int counter = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getApps();
  }

  void getApps() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    setState(() {
      this.loading = true;
      this.apps = [];
    });
    try {
      List<ApplicationWithIcon> apps =
          (await DeviceApps.getInstalledApplications(includeAppIcons: true))
              .cast<ApplicationWithIcon>();

      apps.sort((a, b) {
        return a.appName.toLowerCase().compareTo(b.appName.toLowerCase());
      });
      this._apps = apps;
      setState(() {
        this.apps = this._apps.toList();
      });
    } catch (e) {
      print(e);
      setState(() {
        this.apps = null;
      });
    }
    setState(() {
      this.loading = false;
    });
  }

  Widget buildBody() {
    if (loading) {
      return Center(
        child: Text(
          "Loading",
        ),
      );
    } else if (this.apps == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Error getting the apps",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            FlatButton(
              onPressed: () {
                getApps();
              },
              color: Colors.red,
              // padding: EdgeInsets.all(15),
              child: Text(
                "Retry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            ),
          ],
        ),
      );
    } else if (this.apps != null && this.apps.length <= 0) {
      return Container(
        padding: EdgeInsets.all(15),
        child: Text(
          "Nothing Found",
          style: TextStyle(
            fontSize: 25,
            color: Colors.red,
          ),
        ),
      );
    } else {
      return Container(
        child: ListView.separated(
          separatorBuilder: (context, index) {
            return Divider(
              color: Theme.of(context).primaryColor,
              height: 3,
            );
          },
          itemCount: apps.length,
          itemBuilder: (context, index) {
            ApplicationWithIcon app = apps[index];
            return ListTile(
              tileColor: index % 2 == 0 ? Colors.grey[100] : null,
              dense: true,
              // selected: true,
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                            app: app,
                          )),
                );
              },
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.memory(
                      app.icon,
                    ),
                  )
                  // Icon(
                  //   Icons.android,
                  //   // color: Theme.of(context).primaryColor,
                  //   color: Colors.green,
                  // )
                ],
              ),
              title: Text(
                app.appName,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    app.packageName,
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    "v${app.versionName}",
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
  }

  void onSearch(String str) {
    // print(str);
    if (_apps.length <= 0) return;
    apps = [];
    setState(() {
      apps = _apps.where((element) {
        if (element.appName.toLowerCase().indexOf(str) > -1) return true;
        if (element.packageName.toLowerCase().indexOf(str) > -1) return true;
        return false;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    // print("build");
    return Scaffold(
      appBar: SearchAppBar(
        primary: Theme.of(context).primaryColor,
        appBarController: appBarController,
        // You could load the bar with search already active
        autoSelected: false,
        searchHint: "Search...",
        mainTextColor: Colors.white,
        onChange: onSearch,

        //Will show when SEARCH MODE wasn't active
        mainAppBar: AppBar(
          title: Text("List Apps"),
          actions: <Widget>[
            Container(
              padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
              child: InkWell(
                child: Icon(
                  Icons.search,
                ),
                onTap: () {
                  //This is where You change to SEARCH MODE. To hide, just
                  //add FALSE as value on the stream
                  // appBarController.stream.
                  appBarController.stream.add(true);
                },
              ),
            ),
          ],
        ),
      ),
      body: buildBody(),
    );
  }
}
