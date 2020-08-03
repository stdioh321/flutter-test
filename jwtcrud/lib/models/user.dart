class User {
  int _id;
  String _name;
  String _user;
  String _email;
  String _birthdate;
  String _emailVerifiedAt;
  String _image;
  String _type;
  String _oauthId;
  String _oauthEmail;
  String _createdAt;
  String _updatedAt;
  String _deletedAt;
  String _token;

  User(
      {int id,
      String name,
      String user,
      String email,
      String birthdate,
      String emailVerifiedAt,
      String image,
      String type,
      String oauthId,
      String oauthEmail,
      String createdAt,
      String updatedAt,
      String deletedAt,
      String token}) {
    this._id = id;
    this._name = name;
    this._user = user;
    this._email = email;
    this._birthdate = birthdate;
    this._emailVerifiedAt = emailVerifiedAt;
    this._image = image;
    this._type = type;
    this._oauthId = oauthId;
    this._oauthEmail = oauthEmail;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._deletedAt = deletedAt;
    this._token = token;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get user => _user;
  set user(String user) => _user = user;
  String get email => _email;
  set email(String email) => _email = email;
  String get birthdate => _birthdate;
  set birthdate(String birthdate) => _birthdate = birthdate;
  String get emailVerifiedAt => _emailVerifiedAt;
  set emailVerifiedAt(String emailVerifiedAt) =>
      _emailVerifiedAt = emailVerifiedAt;
  String get image => _image;
  set image(String image) => _image = image;
  String get type => _type;
  set type(String type) => _type = type;
  String get oauthId => _oauthId;
  set oauthId(String oauthId) => _oauthId = oauthId;
  String get oauthEmail => _oauthEmail;
  set oauthEmail(String oauthEmail) => _oauthEmail = oauthEmail;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get deletedAt => _deletedAt;
  set deletedAt(String deletedAt) => _deletedAt = deletedAt;
  String get token => _token;
  set token(String token) => _token = token;

  User.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _user = json['user'];
    _email = json['email'];
    _birthdate = json['birthdate'];
    _emailVerifiedAt = json['email_verified_at'];
    _image = json['image'];
    _type = json['type'];
    _oauthId = json['oauth_id'];
    _oauthEmail = json['oauth_email'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['user'] = this._user;
    data['email'] = this._email;
    data['birthdate'] = this._birthdate;
    data['email_verified_at'] = this._emailVerifiedAt;
    data['image'] = this._image;
    data['type'] = this._type;
    data['oauth_id'] = this._oauthId;
    data['oauth_email'] = this._oauthEmail;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    data['token'] = this._token;
    return data;
  }
}
