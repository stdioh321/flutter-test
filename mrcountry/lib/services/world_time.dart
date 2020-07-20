import 'package:mrcountry/models/time.dart';
import 'package:mrcountry/services/api.dart';

class WorldTime {
  // Location name for UI
  String location;
  // Time in the location
  DateTime time;
  // Url to the flag of the location
  String originalTime;
  String flag;
  String abbreviation;
  String url;

  WorldTime({
    String location,
    String time,
    String flag,
    String url,
    this.abbreviation,
  }) {
    this.originalTime = time;
    this.location = location;
    this.flag = flag;
    this.url = url;
    String tmpOffset =
        (new RegExp(r"[\-\+]\d{2}:\d{2}$")).firstMatch(time).group(0);
    if (tmpOffset.isNotEmpty)
      tmpOffset = tmpOffset.substring(0, 3);
    else
      tmpOffset = "00";
    this.time = DateTime.parse(time).add(Duration(
      hours: int.parse(tmpOffset),
    ));

    // print(this.time.timeZoneOffset);
    // this.time = time;
  }

  static Future<WorldTime> getWT(String location) async {
    Time t = await Api.instance.getTime(location);

    return WorldTime(
      flag: "https://pngimg.com/uploads/flags/flags_PNG14653.png",
      location: t.timezone,
      url: location,
      time: t.datetime,
    );
  }
}
