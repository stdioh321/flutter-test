import 'dart:math';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:flutter/material.dart';

class AdMobProvider with ChangeNotifier {
  BannerAd bannerAd;
  InterstitialAd interstitialAd;
  MobileAdTargetingInfo targetingInfo;
  bool isBannerOn = false;
  int randInt = Random().nextInt(10000);

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
    super.notifyListeners();
    print("notifyListeners");
  }

  AdMobProvider() {
    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>["6C37F434C42960A6B4A43A0E5B46876C"],
    );
  }

  onBannerListen(MobileAdEvent event) {
    if (event == MobileAdEvent.loaded) {
      isBannerOn = true;
    } else if (event == MobileAdEvent.failedToLoad) {
      isBannerOn = false;
    }
    print("=====================================================");
    print("bannerAd MobileEvent ${event}");
    print("=====================================================");
    notifyListeners();
  }

  void RandInt() {
    this.randInt = Random().nextInt(10000);
    notifyListeners();
  }

  loadInterstitialAd() async {
    try {
      interstitialAd = InterstitialAd(
          adUnitId: "ca-app-pub-9436128036799685/7772074502",
          listener: (MobileAdEvent ev) {});
      await interstitialAd.load();
      await interstitialAd.show();
    } catch (e) {
      print(e);
    }
  }

  loadBannerAd() async {
    try {
      bannerAd = BannerAd(
          adUnitId: "ca-app-pub-9436128036799685/5661750633",
          size: AdSize.banner,
          // targetingInfo: targetingInfo,
          listener: onBannerListen);

      await bannerAd.load();
      await bannerAd.show(
        anchorType: AnchorType.bottom,
      );
    } catch (e) {}
    print("=====================================================");
    print("loadBannerAd");
    print("=====================================================");
  }

  Future disposeBannerAd() async {
    try {
      if (bannerAd != null) {
        await bannerAd.dispose();
        print("=====================================================");
        print("bannerAd.dispose()");
        print("=====================================================");
        isBannerOn = false;
        // notifyListeners();
      }
    } catch (e) {}
  }
}
