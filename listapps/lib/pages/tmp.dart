import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';
import 'package:listapps/provider/admob.dart';
import 'package:provider/provider.dart';

class TmpPage extends StatefulWidget {
  @override
  _TmpPageState createState() => _TmpPageState();
}

class _TmpPageState extends State<TmpPage> {
  AdMobProvider admProvider = null;
  @override
  initState() {
    super.initState();
    _initAdMob();
  }

  Future<void> _initAdMob() async {
    // TODO: Initialize AdMob SDK
    print("AdMob SDK LOADING");
    await FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-9436128036799685~9366736514');
    print("AdMob SDK LOADED");
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    admProvider = admProvider ?? Provider.of<AdMobProvider>(context);
    // print(admProvider);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tmp'),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RaisedButton(
                  child: Text("InterstitialAd"),
                  onPressed: () {
                    print("Clicked");
                    admProvider.loadInterstitialAd();
                  },
                ),
                SizedBox(
                  width: 20,
                ),
                RaisedButton(
                  child: Text("BannerAd"),
                  onPressed: () {
                    print("Clicked");
                    admProvider.loadBannerAd(
                        adUnitId: "ca-app-pub-9436128036799685/4938704595");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
