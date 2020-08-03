import 'package:jwtcrud/models/brand.dart';

class Model {
  int _id;
  String _name;
  String _idBrand;
  String _createdAt;
  String _updatedAt;
  String _deletedAt;
  Brand _brand;

  Model(
      {int id,
      String name,
      String idBrand,
      String createdAt,
      String updatedAt,
      String deletedAt,
      Brand brand}) {
    this._id = id;
    this._name = name;
    this._idBrand = idBrand;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
    this._deletedAt = deletedAt;
    this._brand = brand;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get idBrand => _idBrand;
  set idBrand(String idBrand) => _idBrand = idBrand;
  String get createdAt => _createdAt;
  set createdAt(String createdAt) => _createdAt = createdAt;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;
  String get deletedAt => _deletedAt;
  set deletedAt(String deletedAt) => _deletedAt = deletedAt;
  Brand get brand => _brand;
  set brand(Brand brand) => _brand = brand;

  Model.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _idBrand = json['id_brand'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
    _deletedAt = json['deleted_at'];
    _brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['id_brand'] = this._idBrand;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    data['deleted_at'] = this._deletedAt;
    if (this._brand != null) {
      data['brand'] = this._brand.toJson();
    }
    return data;
  }
}

// class Brand {
//   int _id;
//   String _name;
//   String _createdAt;
//   String _updatedAt;
//   String _deletedAt;

//   Brand(
//       {int id,
//       String name,
//       String createdAt,
//       String updatedAt,
//       String deletedAt}) {
//     this._id = id;
//     this._name = name;
//     this._createdAt = createdAt;
//     this._updatedAt = updatedAt;
//     this._deletedAt = deletedAt;
//   }

//   int get id => _id;
//   set id(int id) => _id = id;
//   String get name => _name;
//   set name(String name) => _name = name;
//   String get createdAt => _createdAt;
//   set createdAt(String createdAt) => _createdAt = createdAt;
//   String get updatedAt => _updatedAt;
//   set updatedAt(String updatedAt) => _updatedAt = updatedAt;
//   String get deletedAt => _deletedAt;
//   set deletedAt(String deletedAt) => _deletedAt = deletedAt;

//   Brand.fromJson(Map<String, dynamic> json) {
//     _id = json['id'];
//     _name = json['name'];
//     _createdAt = json['created_at'];
//     _updatedAt = json['updated_at'];
//     _deletedAt = json['deleted_at'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this._id;
//     data['name'] = this._name;
//     data['created_at'] = this._createdAt;
//     data['updated_at'] = this._updatedAt;
//     data['deleted_at'] = this._deletedAt;
//     return data;
//   }
// }
