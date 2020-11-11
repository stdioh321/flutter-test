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
    _initAdMob();
    targetingInfo = MobileAdTargetingInfo(
      keywords: <String>['flutterio', 'beautiful apps'],
      contentUrl: 'https://flutter.io',
      childDirected: false,
      testDevices: <String>[],
    );
  }
  Future<void> _initAdMob() async {
    // TODO: Initialize AdMob SDK
    print("Initialize AdMob SDK");
    await FirebaseAdMob.instance
        .initialize(appId: 'ca-app-pub-9436128036799685~9366736514');
  }

  onBannerListen(event) {
    try {
      if (event == MobileAdEvent?.loaded) {
        isBannerOn = true;
      } else {
        isBannerOn = false;
      }
      print("=====================================================");
      print("bannerAd MobileEvent ${event}");
      print("=====================================================");
    } catch (e) {
      isBannerOn = false;
    }
    notifyListeners();
  }

  void RandInt() {
    this.randInt = Random().nextInt(10000);
    notifyListeners();
  }

  loadInterstitialAd(
      {String adUnitId: "ca-app-pub-9436128036799685/7772074502"}) async {
    try {
      interstitialAd = InterstitialAd(
        targetingInfo: targetingInfo,
        adUnitId: adUnitId,
        listener: (MobileAdEvent ev) {},
      );
      await interstitialAd.load();
      await interstitialAd.show();
    } catch (e) {
      print(e);
    }
  }

  loadBannerAd(
      {String adUnitId: "ca-app-pub-9436128036799685/7951203755"}) async {
    try {
      bannerAd = BannerAd(
          adUnitId: adUnitId,
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
