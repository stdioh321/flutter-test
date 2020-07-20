import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:listapps/models/country.dart';
import 'package:websafe_svg/websafe_svg.dart';

class LocationDetailPage extends StatefulWidget {
  Country country;
  LocationDetailPage({this.country});
  @override
  _LocationDetailPageState createState() => _LocationDetailPageState();
}

class _LocationDetailPageState extends State<LocationDetailPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // print(widget.country.name);
  }

  @override
  Widget build(BuildContext context) {
    Widget flag;
    try {
      flag = Container(
        child: WebsafeSvg.network(
          widget.country.flag,
          semanticsLabel: "Flag",
          width: 250,
        ),
      );
    } catch (e) {
      flag = Image.asset(
        "assets/images/flag-404.png",
        width: 250,
        fit: BoxFit.contain,
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Detail"),
      ),
      body: Container(
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(15, 15, 0, 0),
                  child: flag,
                )
              ],
            ),
            ListTile(
              title: Text("Name"),
              subtitle: Text(widget.country.name),
            ),
            ListTile(
                title: Text("Capital"), subtitle: Text(widget.country.capital)),
            ListTile(
                title: Text("Sub-Region"),
                subtitle: Text(widget.country.subregion)),
            ListTile(
                title: Text("Population"),
                subtitle: Text(widget.country.population != null
                    ? widget.country.population.toString()
                    : null)),
            ListTile(
                title: Text("Latitude & Longitude"),
                subtitle: Text(
                    "${widget.country.latlng[0]}/${widget.country.latlng[1]}")),
            ListTile(
                title: Text("Area"), subtitle: Text("${widget.country.area}")),
            ListTile(
                title: Text("Timezone"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: widget.country.timezones.map((e) {
                    DateTime dt = DateTime.now().toUtc();
                    RegExpMatch rem =
                        RegExp(r'[\-\+]\d{2}:\d{2}$').firstMatch(e);
                    // print(e);
                    int dtUtc = 0;
                    if (rem != null) {
                      dtUtc = int.parse(rem.group(0).substring(0, 3));
                      dt = dt.add(Duration(hours: dtUtc));
                    }
                    return Container(
                      child: Text("$e - ${dt.toString()}"),
                    );
                  }).toList(),
                )),
            ListTile(
              title: Text('Native Name'),
              subtitle: Text(widget.country.nativeName),
            )
          ],
        ),
      ),
    );
  }
}
