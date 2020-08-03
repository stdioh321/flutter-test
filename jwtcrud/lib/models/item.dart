import 'dart:convert';

class Item {
  int _id;
  String _name;
  String _price;
  String _createdAt;
  String _updatedAt;
  String _idBrand;
  String _idModel;
  String _color;

  Item(
      {int id,
      String name,
      String price,
      String createdAt,
      String updatedAt,
      String idBrand,
      String idModel,
      String color}) {
    this._id = id;
    this._name = name;
    this._price = price;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._idBrand = idBrand;
    this._idModel = idModel;
    this._color = color;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get price => _price;
  set price(String price) => _price = price;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get idBrand => _idBrand;
  set idBrand(String idBrand) => _idBrand = idBrand;
  String get idModel => _idModel;
  set idModel(String idModel) => _idModel = idModel;
  String get color => _color;
  set color(String color) => _color = color;

  Item.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _price = json['price'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _idBrand = json['id_brand'];
    _idModel = json['id_model'];
    _color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['price'] = this._price;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['id_brand'] = this._idBrand;
    data['id_model'] = this._idModel;
    data['color'] = this._color;
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return jsonEncode(this.toJson());
    return super.toString();
  }
}
