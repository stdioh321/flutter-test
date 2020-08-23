import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdMobProvider with ChangeNotifier {
  BannerAd bannerAd;
  InterstitialAd interstitialAd;
  bool isBannerOn = false;
  int randInt = Random().nextInt(10000);

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    print("notifyListeners");
  }

  AdMobProvider() {
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-9436128036799685~9366736514");
  }
  void RandInt() {
    this.randInt = Random().nextInt(10000);
    notifyListeners();
  }

  initInterstitialAd() async {
    try {
      var inter = InterstitialAd(
          adUnitId: "ca-app-pub-9436128036799685/7772074502",
          listener: (MobileAdEvent ev) {});
      await inter.load();
      await inter.show();
    } catch (e) {
      print(e);
    }
  }

  Future init() async {
    print("=====================================================");
    print("init AdMob");
    print("=====================================================");
    MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>["6C37F434C42960A6B4A43A0E5B46876C"],
    );
    // if (bannerAd == null)

    bannerAd = BannerAd(
      adUnitId: "ca-app-pub-9436128036799685/5661750633",
      size: AdSize.leaderboard,
      // targetingInfo: targetingInfo,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.loaded) {
          isBannerOn = true;
          print("isBannerOn: ${isBannerOn}");
          notifyListeners();
        } else if (event == MobileAdEvent.failedToLoad) {
          isBannerOn = false;
          notifyListeners();
          // Future.delayed(Duration(seconds: 5), () {
          //   // _loadAdBanner();
          // });
        }
        print("=====================================================");
        print("bannerAd MobileEvent ${event}");
        print("=====================================================");
      },
    );
    // banner.
    await bannerAd.load();
    await bannerAd.show(
      anchorType: AnchorType.bottom,
    );
  }

  Future dispose() async {
    try {
      if (bannerAd != null) {
        await bannerAd.dispose();
        bannerAd = null;
        isBannerOn = false;
        // notifyListeners();
      }
    } catch (e) {}
  }
}
