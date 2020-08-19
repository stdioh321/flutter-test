import 'package:cloud_firestore/cloud_firestore.dart';

class DBFirebase {
  static DBFirebase _instance;

  static DBFirebase get instance {
    if (_instance == null) _instance = DBFirebase();
    return _instance;
  }

  // getDocuments(String path){
  //   Firestore.instance.collection(path).
  // }
}
