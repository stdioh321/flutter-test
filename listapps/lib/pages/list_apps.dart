import 'dart:convert';

import 'package:device_apps/device_apps.dart';
import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:listapps/pages/home_page.dart';
import 'package:listapps/provider/admob.dart';
import 'package:listapps/services/admob.dart';
import 'package:listapps/services/utils.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class ListApps extends StatefulWidget {
  @override
  _ListAppsState createState() => _ListAppsState();
}

class _ListAppsState extends State<ListApps> {
  List<ApplicationWithIcon> _apps = [];
  List<ApplicationWithIcon> apps = [];
  bool loading = true;
  AppBarController appBarController = AppBarController();
  AdMobProvider adMob;
  int countDisplayAd = 0;
  GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // FirebaseAdMob.instance
    //     .initialize(appId: "ca-app-pub-9436128036799685~9366736514");
    this.loadApps();
    // _handleAds();
    // _loadAdBanner();
  }

  _handleSignIn() async {
    try {
      _handleSignOut();
      var gAccount = await _googleSignIn.signIn();

      Utils.instance
          .displayDialog(ctx: context, content: gAccount.email, title: "");
    } catch (e) {
      print(e);
    }
  }

  _handleSignOut() async {
    try {
      _googleSignIn.signOut();
    } catch (e) {
      print(e);
    }
  }

  void loadApps() async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    if ((await Permission.storage.status).isDenied ||
        (await Permission.storage.status).isPermanentlyDenied) {
      Utils.instance.displayDialog(
        content: "It´s necessary to accept the permission",
        title: "Warning",
        ctx: context,
      );
    }
    setState(() {
      this.loading = true;
      this.apps = [];
    });
    try {
      List<ApplicationWithIcon> tmpApps = [];
      if (Utils.instance.prefs.containsKey('listApps')) {
        List<String> listApps = Utils.instance.prefs.getStringList("listApps");

        tmpApps = listApps.map((e) {
          Map json = jsonDecode(
            e,
            reviver: (key, value) {
              if (key == 'app_icon') {
                return base64Encode((value as List)
                    .map((e) => int.parse(e.toString()))
                    .toList());
              }
              return value;
            },
          );
          return Application(json) as ApplicationWithIcon;
        }).toList();
        storeGetApps().then((value) {
          _apps = value;
        });
      } else {
        tmpApps = await storeGetApps();
      }
      // tmpApps =
      //     (await DeviceApps.getInstalledApplications(includeAppIcons: true))
      //         .cast<ApplicationWithIcon>();

      this._apps = tmpApps;
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

  Future<List<ApplicationWithIcon>> storeGetApps() async {
    List<ApplicationWithIcon> tmpApps =
        (await DeviceApps.getInstalledApplications(includeAppIcons: true))
            .cast<ApplicationWithIcon>();
    tmpApps.sort((a, b) {
      return a.appName.toLowerCase().compareTo(b.appName.toLowerCase());
    });
    var tmpList = tmpApps.map((e) {
      Map<String, dynamic> novoMap = Map<String, dynamic>();
      novoMap['app_name'] = e.appName;
      novoMap['apk_file_path'] = e.apkFilePath;
      novoMap['package_name'] = e.packageName;
      novoMap['version_name'] = e.versionName;
      novoMap['version_code'] = e.versionCode;
      novoMap['data_dir'] = e.dataDir;
      novoMap['install_time'] = e.installTimeMillis;
      novoMap['update_time'] = e.updateTimeMillis;
      novoMap['system_app'] = e.systemApp;
      novoMap['app_icon'] = e.icon;
      return jsonEncode(novoMap);
    }).toList();

    await Utils.instance.prefs.setStringList("listApps", tmpList);
    return tmpApps;
  }

  Widget buildBody() {
    if (loading) {
      return Center(
        child: CircularProgressIndicator(),
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
                loadApps();
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
              dense: false,
              // selected: true,
              trailing: IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  try {
                    ShareExtend.share(
                      app.apkFilePath,
                      "file",
                      subject:
                          "${app.appName}_${app.packageName}_v${app.versionName}.apk",
                      extraText: "APK",
                      sharePanelTitle: "Download the apk",
                    );
                  } catch (e) {
                    print(e);
                  }
                },
              ),
              onTap: () async {
                try {
                  Utils.instance.removeFocus(context);

                  await Provider.of<AdMobProvider>(context, listen: false)
                      .dispose();
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => HomePage(
                        app: app,
                      ),
                    ),
                  );
                  countDisplayAd++;
                  if (countDisplayAd >= 3) {
                    countDisplayAd = 0;
                    await adMob.initInterstitialAd();
                  }
                  await adMob.init();
                } catch (e) {}
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
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    // print(adMob.isBannerOn);
    // if (adMob.bannerAd == null) {
    //   adMob.init();
    // }
  }

  _handleAds() async {
    // try {
    //   AppAds.init();
    //   AppAds.showBanner(
    //       size: AdSize.smartBanner, anchorType: AnchorType.bottom);
    // } catch (e) {
    //   print(e);
    // }
  }

  _loadAdMob() async {
    if (adMob == null) {
      adMob = Provider.of<AdMobProvider>(context);
      adMob.init();
    }
  }

  @override
  Widget build(BuildContext context) {
    print("=============================================================");
    print("build");
    print("=============================================================");
    _loadAdMob();
    return Scaffold(
      bottomNavigationBar: Container(
        height: adMob?.isBannerOn == true ? 100 : 0,
        // child: Text("Anything"),
      ),
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
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: buildBody(),
          ),
          // Container(
          //   height: 100,
          //   child: Text("Text"),
          // ),
        ],
      ),
      // persistentFooterButtons: [
      //   Container(
      //     height: 100,
      //     child: Container(
      //         // child: Text("sss"),
      //         ),
      //   ),
      // ],
      // extendBody: true,

      // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      // floatingActionButton: FloatingActionButton(
      //   // mini: true,
      //   child: Icon(Icons.add_to_photos),
      //   onPressed: () async {
      //     _handleSignIn();
      //   },
      // ),
    );
  }
}
