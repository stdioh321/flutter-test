class Joke {
  String _category;
  String _type;
  String _setup;
  String _delivery;
  Flags _flags;
  String _joke;
  int _id;
  bool _error;

  Joke(
      {String category,
      String type,
      String setup,
      String delivery,
      Flags flags,
      String joke,
      int id,
      bool error}) {
    this._category = category;
    this._type = type;
    this._setup = setup;
    this._delivery = delivery;
    this._flags = flags;
    this._joke = joke;
    this._id = id;
    this._error = error;
  }

  String get category => _category;
  set category(String category) => _category = category;
  String get type => _type;
  set type(String type) => _type = type;
  String get setup => _setup;
  set setup(String setup) => _setup = setup;
  String get delivery => _delivery;
  set delivery(String delivery) => _delivery = delivery;
  Flags get flags => _flags;
  set flags(Flags flags) => _flags = flags;
  String get joke => _joke;
  set joke(String joke) => _joke = joke;
  int get id => _id;
  set id(int id) => _id = id;
  bool get error => _error;
  set error(bool error) => _error = error;

  Joke.fromJson(Map<String, dynamic> json) {
    _category = json['category'];
    _type = json['type'];
    _setup = json['setup'];
    _delivery = json['delivery'];
    _flags = json['flags'] != null ? new Flags.fromJson(json['flags']) : null;
    _joke = json['joke'];
    _id = json['id'];
    _error = json['error'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this._category;
    data['type'] = this._type;
    data['setup'] = this._setup;
    data['delivery'] = this._delivery;
    if (this._flags != null) {
      data['flags'] = this._flags.toJson();
    }
    data['joke'] = this._joke;
    data['id'] = this._id;
    data['error'] = this._error;
    return data;
  }
}

class Flags {
  bool _nsfw;
  bool _religious;
  bool _political;
  bool _racist;
  bool _sexist;

  Flags({bool nsfw, bool religious, bool political, bool racist, bool sexist}) {
    this._nsfw = nsfw;
    this._religious = religious;
    this._political = political;
    this._racist = racist;
    this._sexist = sexist;
  }

  bool get nsfw => _nsfw;
  set nsfw(bool nsfw) => _nsfw = nsfw;
  bool get religious => _religious;
  set religious(bool religious) => _religious = religious;
  bool get political => _political;
  set political(bool political) => _political = political;
  bool get racist => _racist;
  set racist(bool racist) => _racist = racist;
  bool get sexist => _sexist;
  set sexist(bool sexist) => _sexist = sexist;

  Flags.fromJson(Map<String, dynamic> json) {
    _nsfw = json['nsfw'];
    _religious = json['religious'];
    _political = json['political'];
    _racist = json['racist'];
    _sexist = json['sexist'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nsfw'] = this._nsfw;
    data['religious'] = this._religious;
    data['political'] = this._political;
    data['racist'] = this._racist;
    data['sexist'] = this._sexist;
    return data;
  }
}
