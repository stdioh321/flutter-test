import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String _id;
  String _todo;
  bool _done;
  Timestamp _createdAt;
  Timestamp _updatedAt;

  Todo(
      {String id,
      String todo,
      bool done,
      Timestamp createdAt,
      Timestamp updatedAt}) {
    this._id = id;
    this._todo = todo;
    this._done = done;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get todo => _todo;
  set todo(String todo) => _todo = todo;
  bool get done => _done;
  set done(bool done) => _done = done;
  Timestamp get createdAt => _createdAt;
  set createdAt(Timestamp createdAt) => _createdAt = createdAt;
  Timestamp get updatedAt => _updatedAt;
  set updatedAt(Timestamp updatedAt) => _updatedAt = updatedAt;

  Todo.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _todo = json['todo'];
    _done = json['done'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['todo'] = this._todo;
    data['done'] = this._done;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
