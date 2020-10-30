import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ygo/generated/l10n.dart';
import 'package:ygo/routes/routes.dart';
import 'package:ygo/services/prefs.dart';
import 'package:ygo/views/card_details.dart';
import 'package:ygo/views/cards_lists.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _loadBeforeApp();
  runApp(MyApp());
}

_loadBeforeApp() async {
  Prefs.instance.prefs = await SharedPreferences.getInstance();
  Intl.defaultLocale = Prefs.instance.prefs.get("lang") ?? "en";
  // S.load(Locale(Prefs.instance.prefs.get("lang") ?? "en"));
  // S.load(Locale("pt"));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    // print("LANG: " + Prefs.instance.prefs.get("lang"));
    // GlobalMaterialLocalizations.delegates.forEach((element) {
    //   print(element.type);
    // });
    // S.load(Locale(Prefs.instance.prefs.get("lang") ?? "en"));
    Locale currLocale = Locale(S.delegate.supportedLocales
            .any((e) => e.languageCode == Intl.getCurrentLocale())
        ? Intl.getCurrentLocale()
        : "en");
    return MaterialApp(
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate
        // GlobalMaterialLocalizations
      ],
      supportedLocales: S.delegate.supportedLocales,
      locale: currLocale,
// locale: Local,
      // locale: Locale(Prefs.instance.prefs.get("lang") ?? "en"),
      title: 'YgoCards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: CardsList(),
      // routes: {
      //   RoutesList.CARDS_LIST: (context) => CardsList(),
      //   RoutesList.CARD_DETAIL: (context) => CardDetails(),
      // },
    );
  }
}
