class CardModel {
  int _id;
  String _name;
  String _type;
  String _desc;
  int _atk;
  int _def;
  int _level;
  String _race;
  String _attribute;
  String _archetype;
  BanlistInfo _banlistInfo;
  List<CardSets> _cardSets;
  List<CardImages> _cardImages;
  List<CardPrices> _cardPrices;

  CardModel(
      {int id,
      String name,
      String type,
      String desc,
      int atk,
      int def,
      int level,
      String race,
      String attribute,
      String archetype,
      BanlistInfo banlistInfo,
      List<CardSets> cardSets,
      List<CardImages> cardImages,
      List<CardPrices> cardPrices}) {
    this._id = id;
    this._name = name;
    this._type = type;
    this._desc = desc;
    this._atk = atk;
    this._def = def;
    this._level = level;
    this._race = race;
    this._attribute = attribute;
    this._archetype = archetype;
    this._banlistInfo = banlistInfo;
    this._cardSets = cardSets;
    this._cardImages = cardImages;
    this._cardPrices = cardPrices;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get type => _type;
  set type(String type) => _type = type;
  String get desc => _desc;
  set desc(String desc) => _desc = desc;
  int get atk => _atk;
  set atk(int atk) => _atk = atk;
  int get def => _def;
  set def(int def) => _def = def;
  int get level => _level;
  set level(int level) => _level = level;
  String get race => _race;
  set race(String race) => _race = race;
  String get attribute => _attribute;
  set attribute(String attribute) => _attribute = attribute;
  String get archetype => _archetype;
  set archetype(String archetype) => _archetype = archetype;
  BanlistInfo get banlistInfo => _banlistInfo;
  set banlistInfo(BanlistInfo banlistInfo) => _banlistInfo = banlistInfo;
  List<CardSets> get cardSets => _cardSets;
  set cardSets(List<CardSets> cardSets) => _cardSets = cardSets;
  List<CardImages> get cardImages => _cardImages;
  set cardImages(List<CardImages> cardImages) => _cardImages = cardImages;
  List<CardPrices> get cardPrices => _cardPrices;
  set cardPrices(List<CardPrices> cardPrices) => _cardPrices = cardPrices;

  CardModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _type = json['type'];
    _desc = json['desc'];
    _atk = json['atk'];
    _def = json['def'];
    _level = json['level'];
    _race = json['race'];
    _attribute = json['attribute'];
    _archetype = json['archetype'];
    _banlistInfo = json['banlist_info'] != null
        ? new BanlistInfo.fromJson(json['banlist_info'])
        : null;
    if (json['card_sets'] != null) {
      _cardSets = new List<CardSets>();
      json['card_sets'].forEach((v) {
        _cardSets.add(new CardSets.fromJson(v));
      });
    }
    if (json['card_images'] != null) {
      _cardImages = new List<CardImages>();
      json['card_images'].forEach((v) {
        _cardImages.add(new CardImages.fromJson(v));
      });
    }
    if (json['card_prices'] != null) {
      _cardPrices = new List<CardPrices>();
      json['card_prices'].forEach((v) {
        _cardPrices.add(new CardPrices.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['type'] = this._type;
    data['desc'] = this._desc;
    data['atk'] = this._atk;
    data['def'] = this._def;
    data['level'] = this._level;
    data['race'] = this._race;
    data['attribute'] = this._attribute;
    data['archetype'] = this._archetype;
    if (this._banlistInfo != null) {
      data['banlist_info'] = this._banlistInfo.toJson();
    }
    if (this._cardSets != null) {
      data['card_sets'] = this._cardSets.map((v) => v.toJson()).toList();
    }
    if (this._cardImages != null) {
      data['card_images'] = this._cardImages.map((v) => v.toJson()).toList();
    }
    if (this._cardPrices != null) {
      data['card_prices'] = this._cardPrices.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class BanlistInfo {
  String _banTcg;
  String _banOcg;

  BanlistInfo({String banTcg, String banOcg}) {
    this._banTcg = banTcg;
    this._banOcg = banOcg;
  }

  String get banTcg => _banTcg;
  set banTcg(String banTcg) => _banTcg = banTcg;
  String get banOcg => _banOcg;
  set banOcg(String banOcg) => _banOcg = banOcg;

  BanlistInfo.fromJson(Map<String, dynamic> json) {
    _banTcg = json['ban_tcg'];
    _banOcg = json['ban_ocg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['ban_tcg'] = this._banTcg;
    data['ban_ocg'] = this._banOcg;
    return data;
  }
}

class CardSets {
  String _setName;
  String _setCode;
  String _setRarity;
  String _setRarityCode;
  String _setPrice;

  CardSets(
      {String setName,
      String setCode,
      String setRarity,
      String setRarityCode,
      String setPrice}) {
    this._setName = setName;
    this._setCode = setCode;
    this._setRarity = setRarity;
    this._setRarityCode = setRarityCode;
    this._setPrice = setPrice;
  }

  String get setName => _setName;
  set setName(String setName) => _setName = setName;
  String get setCode => _setCode;
  set setCode(String setCode) => _setCode = setCode;
  String get setRarity => _setRarity;
  set setRarity(String setRarity) => _setRarity = setRarity;
  String get setRarityCode => _setRarityCode;
  set setRarityCode(String setRarityCode) => _setRarityCode = setRarityCode;
  String get setPrice => _setPrice;
  set setPrice(String setPrice) => _setPrice = setPrice;

  CardSets.fromJson(Map<String, dynamic> json) {
    _setName = json['set_name'];
    _setCode = json['set_code'];
    _setRarity = json['set_rarity'];
    _setRarityCode = json['set_rarity_code'];
    _setPrice = json['set_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['set_name'] = this._setName;
    data['set_code'] = this._setCode;
    data['set_rarity'] = this._setRarity;
    data['set_rarity_code'] = this._setRarityCode;
    data['set_price'] = this._setPrice;
    return data;
  }
}

class CardImages {
  int _id;
  String _imageUrl;
  String _imageUrlSmall;

  CardImages({int id, String imageUrl, String imageUrlSmall}) {
    this._id = id;
    this._imageUrl = imageUrl;
    this._imageUrlSmall = imageUrlSmall;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get imageUrl => _imageUrl;
  set imageUrl(String imageUrl) => _imageUrl = imageUrl;
  String get imageUrlSmall => _imageUrlSmall;
  set imageUrlSmall(String imageUrlSmall) => _imageUrlSmall = imageUrlSmall;

  CardImages.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _imageUrl = json['image_url'];
    _imageUrlSmall = json['image_url_small'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['image_url'] = this._imageUrl;
    data['image_url_small'] = this._imageUrlSmall;
    return data;
  }
}

class CardPrices {
  String _cardmarketPrice;
  String _tcgplayerPrice;
  String _ebayPrice;
  String _amazonPrice;
  String _coolstuffincPrice;

  CardPrices(
      {String cardmarketPrice,
      String tcgplayerPrice,
      String ebayPrice,
      String amazonPrice,
      String coolstuffincPrice}) {
    this._cardmarketPrice = cardmarketPrice;
    this._tcgplayerPrice = tcgplayerPrice;
    this._ebayPrice = ebayPrice;
    this._amazonPrice = amazonPrice;
    this._coolstuffincPrice = coolstuffincPrice;
  }

  String get cardmarketPrice => _cardmarketPrice;
  set cardmarketPrice(String cardmarketPrice) =>
      _cardmarketPrice = cardmarketPrice;
  String get tcgplayerPrice => _tcgplayerPrice;
  set tcgplayerPrice(String tcgplayerPrice) => _tcgplayerPrice = tcgplayerPrice;
  String get ebayPrice => _ebayPrice;
  set ebayPrice(String ebayPrice) => _ebayPrice = ebayPrice;
  String get amazonPrice => _amazonPrice;
  set amazonPrice(String amazonPrice) => _amazonPrice = amazonPrice;
  String get coolstuffincPrice => _coolstuffincPrice;
  set coolstuffincPrice(String coolstuffincPrice) =>
      _coolstuffincPrice = coolstuffincPrice;

  CardPrices.fromJson(Map<String, dynamic> json) {
    _cardmarketPrice = json['cardmarket_price'];
    _tcgplayerPrice = json['tcgplayer_price'];
    _ebayPrice = json['ebay_price'];
    _amazonPrice = json['amazon_price'];
    _coolstuffincPrice = json['coolstuffinc_price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardmarket_price'] = this._cardmarketPrice;
    data['tcgplayer_price'] = this._tcgplayerPrice;
    data['ebay_price'] = this._ebayPrice;
    data['amazon_price'] = this._amazonPrice;
    data['coolstuffinc_price'] = this._coolstuffincPrice;
    return data;
  }
}
