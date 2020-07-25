class Timezone {
  String _abbreviation;
  String _clientIp;
  String _datetime;
  int _dayOfWeek;
  int _dayOfYear;
  bool _dst;
  String _dstFrom;
  int _dstOffset;
  String _dstUntil;
  int _rawOffset;
  String _timezone;
  int _unixtime;
  String _utcDatetime;
  String _utcOffset;
  int _weekNumber;

  Timezone(
      {String abbreviation,
      String clientIp,
      String datetime,
      int dayOfWeek,
      int dayOfYear,
      bool dst,
      String dstFrom,
      int dstOffset,
      String dstUntil,
      int rawOffset,
      String timezone,
      int unixtime,
      String utcDatetime,
      String utcOffset,
      int weekNumber}) {
    this._abbreviation = abbreviation;
    this._clientIp = clientIp;
    this._datetime = datetime;
    this._dayOfWeek = dayOfWeek;
    this._dayOfYear = dayOfYear;
    this._dst = dst;
    this._dstFrom = dstFrom;
    this._dstOffset = dstOffset;
    this._dstUntil = dstUntil;
    this._rawOffset = rawOffset;
    this._timezone = timezone;
    this._unixtime = unixtime;
    this._utcDatetime = utcDatetime;
    this._utcOffset = utcOffset;
    this._weekNumber = weekNumber;
  }

  String get abbreviation => _abbreviation;
  set abbreviation(String abbreviation) => _abbreviation = abbreviation;
  String get clientIp => _clientIp;
  set clientIp(String clientIp) => _clientIp = clientIp;
  String get datetime => _datetime;
  set datetime(String datetime) => _datetime = datetime;
  int get dayOfWeek => _dayOfWeek;
  set dayOfWeek(int dayOfWeek) => _dayOfWeek = dayOfWeek;
  int get dayOfYear => _dayOfYear;
  set dayOfYear(int dayOfYear) => _dayOfYear = dayOfYear;
  bool get dst => _dst;
  set dst(bool dst) => _dst = dst;
  String get dstFrom => _dstFrom;
  set dstFrom(String dstFrom) => _dstFrom = dstFrom;
  int get dstOffset => _dstOffset;
  set dstOffset(int dstOffset) => _dstOffset = dstOffset;
  String get dstUntil => _dstUntil;
  set dstUntil(String dstUntil) => _dstUntil = dstUntil;
  int get rawOffset => _rawOffset;
  set rawOffset(int rawOffset) => _rawOffset = rawOffset;
  String get timezone => _timezone;
  set timezone(String timezone) => _timezone = timezone;
  int get unixtime => _unixtime;
  set unixtime(int unixtime) => _unixtime = unixtime;
  String get utcDatetime => _utcDatetime;
  set utcDatetime(String utcDatetime) => _utcDatetime = utcDatetime;
  String get utcOffset => _utcOffset;
  set utcOffset(String utcOffset) => _utcOffset = utcOffset;
  int get weekNumber => _weekNumber;
  set weekNumber(int weekNumber) => _weekNumber = weekNumber;

  Timezone.fromJson(Map<String, dynamic> json) {
    _abbreviation = json['abbreviation'];
    _clientIp = json['client_ip'];
    _datetime = json['datetime'];
    _dayOfWeek = json['day_of_week'];
    _dayOfYear = json['day_of_year'];
    _dst = json['dst'];
    _dstFrom = json['dst_from'];
    _dstOffset = json['dst_offset'];
    _dstUntil = json['dst_until'];
    _rawOffset = json['raw_offset'];
    _timezone = json['timezone'];
    _unixtime = json['unixtime'];
    _utcDatetime = json['utc_datetime'];
    _utcOffset = json['utc_offset'];
    _weekNumber = json['week_number'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['abbreviation'] = this._abbreviation;
    data['client_ip'] = this._clientIp;
    data['datetime'] = this._datetime;
    data['day_of_week'] = this._dayOfWeek;
    data['day_of_year'] = this._dayOfYear;
    data['dst'] = this._dst;
    data['dst_from'] = this._dstFrom;
    data['dst_offset'] = this._dstOffset;
    data['dst_until'] = this._dstUntil;
    data['raw_offset'] = this._rawOffset;
    data['timezone'] = this._timezone;
    data['unixtime'] = this._unixtime;
    data['utc_datetime'] = this._utcDatetime;
    data['utc_offset'] = this._utcOffset;
    data['week_number'] = this._weekNumber;
    return data;
  }
}
