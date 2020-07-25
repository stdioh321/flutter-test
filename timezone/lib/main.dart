import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/providers/timezones.dart';
import 'package:timezone/routes/AppRoutes.dart';
import 'package:timezone/views/list_timezones.dart';
import 'package:timezone/views/test.dart';
import 'package:timezone/views/timezone-detail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) {
        return Timezones();
      },
      child: MaterialApp(
        title: 'Timezone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // fontFamily: 'IndieFlower',
          primarySwatch: Colors.amber,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        // home: ListTimezones(),
        initialRoute: AppRoutes.LIST_TIMEZONES,
        routes: {
          AppRoutes.LIST_TIMEZONES: (_) => ListTimezones(),
          AppRoutes.TIMEZONE_DETAIL: (_) => TimezoneDetail(),
          AppRoutes.TEST: (_) => TestView(),
        },
      ),
    );
  }
}
