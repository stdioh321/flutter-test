class Country {
  String _name;
  List<String> _topLevelDomain;
  String _alpha2Code;
  String _alpha3Code;
  List<String> _callingCodes;
  String _capital;
  List<String> _altSpellings;
  String _region;
  String _subregion;
  int _population;
  List<double> _latlng;
  String _demonym;
  int _area;
  double _gini;
  List<String> _timezones;
  List<String> _borders;
  String _nativeName;
  String _numericCode;
  List<Currencies> _currencies;
  List<Languages> _languages;
  Translations _translations;
  String _flag;
  List<RegionalBlocs> _regionalBlocs;
  String _cioc;

  Country(
      {String name,
      List<String> topLevelDomain,
      String alpha2Code,
      String alpha3Code,
      List<String> callingCodes,
      String capital,
      List<String> altSpellings,
      String region,
      String subregion,
      int population,
      List<double> latlng,
      String demonym,
      int area,
      double gini,
      List<String> timezones,
      List<String> borders,
      String nativeName,
      String numericCode,
      List<Currencies> currencies,
      List<Languages> languages,
      Translations translations,
      String flag,
      List<RegionalBlocs> regionalBlocs,
      String cioc}) {
    this._name = name;
    this._topLevelDomain = topLevelDomain;
    this._alpha2Code = alpha2Code;
    this._alpha3Code = alpha3Code;
    this._callingCodes = callingCodes;
    this._capital = capital;
    this._altSpellings = altSpellings;
    this._region = region;
    this._subregion = subregion;
    this._population = population;
    this._latlng = latlng;
    this._demonym = demonym;
    this._area = area;
    this._gini = gini;
    this._timezones = timezones;
    this._borders = borders;
    this._nativeName = nativeName;
    this._numericCode = numericCode;
    this._currencies = currencies;
    this._languages = languages;
    this._translations = translations;
    this._flag = flag;
    this._regionalBlocs = regionalBlocs;
    this._cioc = cioc;
  }

  String get name => _name;
  set name(String name) => _name = name;
  List<String> get topLevelDomain => _topLevelDomain;
  set topLevelDomain(List<String> topLevelDomain) =>
      _topLevelDomain = topLevelDomain;
  String get alpha2Code => _alpha2Code;
  set alpha2Code(String alpha2Code) => _alpha2Code = alpha2Code;
  String get alpha3Code => _alpha3Code;
  set alpha3Code(String alpha3Code) => _alpha3Code = alpha3Code;
  List<String> get callingCodes => _callingCodes;
  set callingCodes(List<String> callingCodes) => _callingCodes = callingCodes;
  String get capital => _capital;
  set capital(String capital) => _capital = capital;
  List<String> get altSpellings => _altSpellings;
  set altSpellings(List<String> altSpellings) => _altSpellings = altSpellings;
  String get region => _region;
  set region(String region) => _region = region;
  String get subregion => _subregion;
  set subregion(String subregion) => _subregion = subregion;
  int get population => _population;
  set population(int population) => _population = population;
  List<double> get latlng => _latlng;
  set latlng(List<double> latlng) => _latlng = latlng;
  String get demonym => _demonym;
  set demonym(String demonym) => _demonym = demonym;
  int get area => _area;
  set area(int area) => _area = area;
  double get gini => _gini;
  set gini(double gini) => _gini = gini;
  List<String> get timezones => _timezones;
  set timezones(List<String> timezones) => _timezones = timezones;
  List<String> get borders => _borders;
  set borders(List<String> borders) => _borders = borders;
  String get nativeName => _nativeName;
  set nativeName(String nativeName) => _nativeName = nativeName;
  String get numericCode => _numericCode;
  set numericCode(String numericCode) => _numericCode = numericCode;
  List<Currencies> get currencies => _currencies;
  set currencies(List<Currencies> currencies) => _currencies = currencies;
  List<Languages> get languages => _languages;
  set languages(List<Languages> languages) => _languages = languages;
  Translations get translations => _translations;
  set translations(Translations translations) => _translations = translations;
  String get flag => _flag;
  set flag(String flag) => _flag = flag;
  List<RegionalBlocs> get regionalBlocs => _regionalBlocs;
  set regionalBlocs(List<RegionalBlocs> regionalBlocs) =>
      _regionalBlocs = regionalBlocs;
  String get cioc => _cioc;
  set cioc(String cioc) => _cioc = cioc;

  Country.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _topLevelDomain = json['topLevelDomain'].cast<String>();
    _alpha2Code = json['alpha2Code'];
    _alpha3Code = json['alpha3Code'];
    _callingCodes = json['callingCodes'].cast<String>();
    _capital = json['capital'];
    _altSpellings = json['altSpellings'].cast<String>();
    _region = json['region'];
    _subregion = json['subregion'];

    _population = json['population'];

    _latlng = json['latlng'].cast<double>();

    _demonym = json['demonym'];

    _area = json['area'] != null ? json['area'].toInt() : null;

    _gini = json['gini'];
    _timezones = json['timezones'].cast<String>();
    _borders = json['borders'].cast<String>();
    _nativeName = json['nativeName'];
    _numericCode = json['numericCode'];
    if (json['currencies'] != null) {
      _currencies = new List<Currencies>();
      json['currencies'].forEach((v) {
        _currencies.add(new Currencies.fromJson(v));
      });
    }
    if (json['languages'] != null) {
      _languages = new List<Languages>();
      json['languages'].forEach((v) {
        _languages.add(new Languages.fromJson(v));
      });
    }
    _translations = json['translations'] != null
        ? new Translations.fromJson(json['translations'])
        : null;
    _flag = json['flag'];
    if (json['regionalBlocs'] != null) {
      _regionalBlocs = new List<RegionalBlocs>();
      json['regionalBlocs'].forEach((v) {
        _regionalBlocs.add(new RegionalBlocs.fromJson(v));
      });
    }
    _cioc = json['cioc'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['topLevelDomain'] = this._topLevelDomain;
    data['alpha2Code'] = this._alpha2Code;
    data['alpha3Code'] = this._alpha3Code;
    data['callingCodes'] = this._callingCodes;
    data['capital'] = this._capital;
    data['altSpellings'] = this._altSpellings;
    data['region'] = this._region;
    data['subregion'] = this._subregion;
    data['population'] = this._population;
    data['latlng'] = this._latlng;
    data['demonym'] = this._demonym;
    data['area'] = this._area;
    data['gini'] = this._gini;
    data['timezones'] = this._timezones;
    data['borders'] = this._borders;
    data['nativeName'] = this._nativeName;
    data['numericCode'] = this._numericCode;
    if (this._currencies != null) {
      data['currencies'] = this._currencies.map((v) => v.toJson()).toList();
    }
    if (this._languages != null) {
      data['languages'] = this._languages.map((v) => v.toJson()).toList();
    }
    if (this._translations != null) {
      data['translations'] = this._translations.toJson();
    }
    data['flag'] = this._flag;
    if (this._regionalBlocs != null) {
      data['regionalBlocs'] =
          this._regionalBlocs.map((v) => v.toJson()).toList();
    }
    data['cioc'] = this._cioc;
    return data;
  }
}

class Currencies {
  String _code;
  String _name;
  String _symbol;

  Currencies({String code, String name, String symbol}) {
    this._code = code;
    this._name = name;
    this._symbol = symbol;
  }

  String get code => _code;
  set code(String code) => _code = code;
  String get name => _name;
  set name(String name) => _name = name;
  String get symbol => _symbol;
  set symbol(String symbol) => _symbol = symbol;

  Currencies.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _name = json['name'];
    _symbol = json['symbol'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['name'] = this._name;
    data['symbol'] = this._symbol;
    return data;
  }
}

class Languages {
  String _iso6391;
  String _iso6392;
  String _name;
  String _nativeName;

  Languages({String iso6391, String iso6392, String name, String nativeName}) {
    this._iso6391 = iso6391;
    this._iso6392 = iso6392;
    this._name = name;
    this._nativeName = nativeName;
  }

  String get iso6391 => _iso6391;
  set iso6391(String iso6391) => _iso6391 = iso6391;
  String get iso6392 => _iso6392;
  set iso6392(String iso6392) => _iso6392 = iso6392;
  String get name => _name;
  set name(String name) => _name = name;
  String get nativeName => _nativeName;
  set nativeName(String nativeName) => _nativeName = nativeName;

  Languages.fromJson(Map<String, dynamic> json) {
    _iso6391 = json['iso639_1'];
    _iso6392 = json['iso639_2'];
    _name = json['name'];
    _nativeName = json['nativeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['iso639_1'] = this._iso6391;
    data['iso639_2'] = this._iso6392;
    data['name'] = this._name;
    data['nativeName'] = this._nativeName;
    return data;
  }
}

class Translations {
  String _de;
  String _es;
  String _fr;
  String _ja;
  String _it;
  String _br;
  String _pt;
  String _nl;
  String _hr;
  String _fa;

  Translations(
      {String de,
      String es,
      String fr,
      String ja,
      String it,
      String br,
      String pt,
      String nl,
      String hr,
      String fa}) {
    this._de = de;
    this._es = es;
    this._fr = fr;
    this._ja = ja;
    this._it = it;
    this._br = br;
    this._pt = pt;
    this._nl = nl;
    this._hr = hr;
    this._fa = fa;
  }

  String get de => _de;
  set de(String de) => _de = de;
  String get es => _es;
  set es(String es) => _es = es;
  String get fr => _fr;
  set fr(String fr) => _fr = fr;
  String get ja => _ja;
  set ja(String ja) => _ja = ja;
  String get it => _it;
  set it(String it) => _it = it;
  String get br => _br;
  set br(String br) => _br = br;
  String get pt => _pt;
  set pt(String pt) => _pt = pt;
  String get nl => _nl;
  set nl(String nl) => _nl = nl;
  String get hr => _hr;
  set hr(String hr) => _hr = hr;
  String get fa => _fa;
  set fa(String fa) => _fa = fa;

  Translations.fromJson(Map<String, dynamic> json) {
    _de = json['de'];
    _es = json['es'];
    _fr = json['fr'];
    _ja = json['ja'];
    _it = json['it'];
    _br = json['br'];
    _pt = json['pt'];
    _nl = json['nl'];
    _hr = json['hr'];
    _fa = json['fa'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['de'] = this._de;
    data['es'] = this._es;
    data['fr'] = this._fr;
    data['ja'] = this._ja;
    data['it'] = this._it;
    data['br'] = this._br;
    data['pt'] = this._pt;
    data['nl'] = this._nl;
    data['hr'] = this._hr;
    data['fa'] = this._fa;
    return data;
  }
}

class RegionalBlocs {
  String _acronym;
  String _name;
  List<String> _otherAcronyms;
  List<String> _otherNames;

  RegionalBlocs(
      {String acronym,
      String name,
      List<String> otherAcronyms,
      List<String> otherNames}) {
    this._acronym = acronym;
    this._name = name;
    this._otherAcronyms = otherAcronyms;
    this._otherNames = otherNames;
  }

  String get acronym => _acronym;
  set acronym(String acronym) => _acronym = acronym;
  String get name => _name;
  set name(String name) => _name = name;
  List<String> get otherAcronyms => _otherAcronyms;
  set otherAcronyms(List<String> otherAcronyms) =>
      _otherAcronyms = otherAcronyms;
  List<String> get otherNames => _otherNames;
  set otherNames(List<String> otherNames) => _otherNames = otherNames;

  RegionalBlocs.fromJson(Map<String, dynamic> json) {
    _acronym = json['acronym'];
    _name = json['name'];
    _otherAcronyms = json['otherAcronyms'].cast<String>();
    _otherNames = json['otherNames'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acronym'] = this._acronym;
    data['name'] = this._name;
    data['otherAcronyms'] = this._otherAcronyms;
    data['otherNames'] = this._otherNames;
    return data;
  }
}
