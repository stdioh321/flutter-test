class GanHou {
  String _sId;
  String _author;
  String _category;
  String _createdAt;
  String _desc;
  List<String> _images;
  int _likeCounts;
  String _publishedAt;
  int _stars;
  String _title;
  String _type;
  String _url;
  int _views;

  GanHou(
      {String sId,
      String author,
      String category,
      String createdAt,
      String desc,
      List<String> images,
      int likeCounts,
      String publishedAt,
      int stars,
      String title,
      String type,
      String url,
      int views}) {
    this._sId = sId;
    this._author = author;
    this._category = category;
    this._createdAt = createdAt;
    this._desc = desc;
    this._images = images;
    this._likeCounts = likeCounts;
    this._publishedAt = publishedAt;
    this._stars = stars;
    this._title = title;
    this._type = type;
    this._url = url;
    this._views = views;
  }

  String get sId => _sId;
  set sId(String sId) => _sId = sId;
  String get author => _author;
  set author(String author) => _author = author;
  String get category => _category;
  set category(String category) => _category = category;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get desc => _desc;
  set desc(String desc) => _desc = desc;
  List<String> get images => _images;
  set images(List<String> images) => _images = images;
  int get likeCounts => _likeCounts;
  set likeCounts(int likeCounts) => _likeCounts = likeCounts;
  String get publishedAt => _publishedAt;
  set publishedAt(String publishedAt) => _publishedAt = publishedAt;
  int get stars => _stars;
  set stars(int stars) => _stars = stars;
  String get title => _title;
  set title(String title) => _title = title;
  String get type => _type;
  set type(String type) => _type = type;
  String get url => _url;
  set url(String url) => _url = url;
  int get views => _views;
  set views(int views) => _views = views;

  GanHou.fromJson(Map<String, dynamic> json) {
    _sId = json['_id'];
    _author = json['author'];
    _category = json['category'];
    _createdAt = json['createdAt'];
    _desc = json['desc'];
    _images = json['images'].cast<String>();
    _likeCounts = json['likeCounts'];
    _publishedAt = json['publishedAt'];
    _stars = json['stars'];
    _title = json['title'];
    _type = json['type'];
    _url = json['url'];
    _views = json['views'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this._sId;
    data['author'] = this._author;
    data['category'] = this._category;
    data['createdAt'] = this._createdAt;
    data['desc'] = this._desc;
    data['images'] = this._images;
    data['likeCounts'] = this._likeCounts;
    data['publishedAt'] = this._publishedAt;
    data['stars'] = this._stars;
    data['title'] = this._title;
    data['type'] = this._type;
    data['url'] = this._url;
    data['views'] = this._views;
    return data;
  }
}
