import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ListApps extends StatefulWidget {
  @override
  _ListAppsState createState() => _ListAppsState();
}

class _ListAppsState extends State<ListApps> {
  List<Application> _apps = [];
  List<Application> apps = [];
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.getApps();
  }

  void getApps() async {
    setState(() {
      this.loading = true;
      this.apps = [];
    });
    try {
      List<Application> apps = await DeviceApps.getInstalledApplications();
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
        child: Text(
          "Nothing",
        ),
      );
    } else {
      return Container(
        child: ListView.builder(
          itemCount: apps.length,
          itemBuilder: (context, index) {
            Application app = apps[index];
            return ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.android,
                  )
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "List Apps",
        ),
      ),
      body: buildBody(),
    );
  }
}
