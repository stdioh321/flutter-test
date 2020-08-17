import 'dart:math';

import 'package:boilerplate/data/mocks.dart';
import 'package:boilerplate/models/todo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class TodoProvider with ChangeNotifier {
  List<Todo> todos = [];
  @override
  void notifyListeners() {
    super.notifyListeners();
    print("notifyListeners TodoProvider");
  }

  int get total {
    return todos.length;
  }

  Todo byIndex(int idx) {
    return todos[idx];
  }

  Todo byId(String id) {
    if (id == null || id.isEmpty) return null;
    return todos.firstWhere((element) => element.id == id, orElse: () {
      return null;
    });
  }

  put(Todo todo) async {
    var instance = Firestore.instance.collection("todo");
    if (todo.id != null && todo.id.isNotEmpty) {
      var doc = await instance.document(todo.id).get();
      if (doc == null || doc.exists == false)
        throw Exception("Id do not exist");
      var doc2 = await instance.document(todo.id);
      var tmp = todo.toJson();
      tmp['update_at'] = FieldValue.serverTimestamp();
      tmp.remove('id');
      await doc2.updateData(tmp);
    } else {
      var tmp = todo.toJson();
      tmp.remove('id');
      var tms = FieldValue.serverTimestamp();
      tmp['created_at'] = tms;
      tmp['updated_at'] = tms;
      await instance.add(tmp);
    }
    await load();
    notifyListeners();
  }

  delete(Todo todo) async {
    var instance = Firestore.instance.collection("todo");
    if ((await instance.document(todo.id).get()).exists) {
      await instance.document(todo.id).delete();
    } else {
      throw Exception("Id do not exist");
    }
    await load();
    notifyListeners();
  }

  load() async {
    QuerySnapshot snap = await Firestore.instance
        .collection("todo")
        // .orderBy('', descending: true)
        .getDocuments();
    todos = [];

    snap.documents.forEach((e) {
      var tmp = Todo.fromJson(e.data);
      tmp.id = e.documentID;
      // print(e.data['update_at']);
      todos.add(tmp);
    });

    notifyListeners();
  }
}
