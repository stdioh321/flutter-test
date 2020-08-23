import 'package:firebase_admob/firebase_admob.dart';

class AdMob {
  static AdMob _instance;
  BannerAd bannerAd;
  bool isBannerOn = false;
  static AdMob get instance {
    if (_instance == null) _instance = AdMob();
    return _instance;
  }

  Future dispose() async {
    try {
      if (bannerAd != null) {
        await bannerAd.dispose();
        isBannerOn = false;
      }
    } catch (e) {}
  }

  Future init(Function listen) async {
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
        adUnitId: "ca-app-pub-9436128036799685/7951203755",
        size: AdSize.smartBanner,
        // targetingInfo: targetingInfo,
        listener: listen
        // (MobileAdEvent event) {
        //   if (event == MobileAdEvent.loaded) {
        //     isBannerOn = true;
        //   } else if (event == MobileAdEvent.failedToLoad) {
        //     Future.delayed(Duration(seconds: 5), () {
        //       // _loadAdBanner();
        //     });
        //   }
        //   print("=====================================================");
        //   print("MobileEvent ${event}");
        //   print("=====================================================");
        // },
        );
    // banner.
    await bannerAd.load();
    await bannerAd.show(
      anchorType: AnchorType.bottom,
    );
  }
}
