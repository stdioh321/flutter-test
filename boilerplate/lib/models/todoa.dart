import 'package:cloud_firestore/cloud_firestore.dart';

class TodoA {
  String _id;
  String _uid;
  String _todo;
  bool _done;
  Timestamp _createdAt;
  Timestamp _updatedAt;

  TodoA(
      {String id,
      String uid,
      String todo,
      bool done,
      Timestamp createdAt,
      Timestamp updatedAt}) {
    this._id = id;
    this._uid = uid;
    this._todo = todo;
    this._done = done;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get id => _id;
  set id(String id) => _id = id;

  String get uid => _uid;
  set uid(String uid) => _uid = uid;
  String get todo => _todo;
  set todo(String todo) => _todo = todo;
  bool get done => _done;
  set done(bool done) => _done = done;
  Timestamp get createdAt => _createdAt;
  set createdAt(Timestamp createdAt) => _createdAt = createdAt;
  Timestamp get updatedAt => _updatedAt;
  set updatedAt(Timestamp updatedAt) => _updatedAt = updatedAt;

  TodoA.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _uid = json['uid'];
    _todo = json['todo'];
    _done = json['done'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }
  fromJson(Map<String, dynamic> json) {
    if (json['id'] != null) _id = json['id'];
    if (json['uid'] != null) _uid = json['uid'];
    if (json['todo'] != null) _todo = json['todo'];
    if (json['done'] != null) _done = json['done'];
    if (json['created_at'] != null) _createdAt = json['created_at'];
    if (json['updated_at'] != null) _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['uid'] = this._uid;
    data['todo'] = this._todo;
    data['done'] = this._done;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
