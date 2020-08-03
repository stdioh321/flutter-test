import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timezone/models/timezone.dart';
import 'package:timezone/providers/timezones.dart';
import 'package:timezone/routes/AppRoutes.dart';
import 'package:timezone/services/enums.dart';
import 'package:timezone/views/list_timezones.dart';

class TimezoneDetail extends StatefulWidget {
  @override
  _TimezoneDetailState createState() => _TimezoneDetailState();
}

class _TimezoneDetailState extends State<TimezoneDetail> {
  String location;
  Timezones timezones;
  Timezone tmz;
  Status loading = Status.loading;
  bool animation = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Navigator.of(context).pushNamed(AppRoutes.LIST_TIMEZONES);
    super.dispose();
    print("DISPOSE");
  }

  @override
  didChangeDependencies() {
    super.didChangeDependencies();
    loadLocation();
  }

  loadLocation() async {
    // setState(() {

    // });
    timezones = Provider.of(context);
    try {
      if (location == null)
        location = (ModalRoute.of(context).settings.arguments as String);
      if (tmz == null) {
        loading = Status.loading;
        tmz = await timezones.byLocation(location);
        timezones.notifyListeners();
      }

      loading = Status.ok;
    } catch (e) {
      print(e);
      setState(() {
        loading = Status.error;
      });
    }
  }

  Widget _buidBody() {
    if (loading == Status.loading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (loading == Status.error) {
      return Center(
        child: Text("ERROR"),
      );
    } else {
      Future.delayed(Duration(milliseconds: 500), () {
        if (animation == true) return;
        setState(() {
          animation = true;
        });
      });
      DateTime dt = DateTime.parse(tmz.datetime);
      var match = RegExp(r'([\-\+]\d{2}):(\d{2})$').firstMatch(tmz.utcOffset);
      String offsetHours = "00";
      String offsetMinutes = "00";
      if (match != null) {
        offsetHours = match.group(1);
        offsetMinutes = match.group(2);
      }

      // print(offsetHours);
      // if (offsetHours == null) offsetHours = "00";
      dt = dt.add(
        Duration(
          hours: int.parse(offsetHours),
          minutes: int.parse(offsetMinutes),
        ),
      );
      return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/sky.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            duration: Duration(seconds: 1),
            opacity: animation == false ? 0 : 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  dt.toString().split('.')[0],
                  style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w900,
                    // color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  tmz.timezone,
                  style: TextStyle(
                    fontWeight: FontWeight.w900, fontSize: 20, letterSpacing: 1,

                    // color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    print("BUILD");
    return Scaffold(
      appBar: AppBar(
        title: Text(tmz != null ? tmz.timezone : ""),
      ),
      body: _buidBody(),
    );
  }
}
