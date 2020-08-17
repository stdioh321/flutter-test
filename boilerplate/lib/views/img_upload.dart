import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

class ImgUploadView extends StatefulWidget {
  @override
  _ImgUploadViewState createState() => _ImgUploadViewState();
}

class _ImgUploadViewState extends State<ImgUploadView> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  GoogleSignInAccount gAccount;
  List<String> images = [];
  bool isLogged = false;
  bool loading = false;

  _checkLogin() async {
    try {
      if (await googleSignIn.isSignedIn() == true) {
        await _handleSignIn();
      } else
        this.isLogged = false;
    } catch (e) {
      this.isLogged = false;
    }
    setState(() {});
  }

  _handleSignIn() async {
    try {
      gAccount = await googleSignIn.signIn();
      if (this.gAccount == null) {
        throw Exception("Not Login");
      }
      await _loadImage();
      isLogged = true;
    } catch (e) {
      this.gAccount = null;
      isLogged = false;
      images = [];
    }
    setState(() {});
  }

  _handleSignOut() async {
    try {
      await googleSignIn.signOut();
    } catch (e) {}
    this.gAccount = null;
    this.isLogged = false;
    images = [];
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkLogin();
  }

  _buildBody() {
    if (this.isLogged == false) {
      return Center(
          child: RaisedButton(
        color: Colors.blue,
        onPressed: () async {
          _handleSignIn();
        },
        child: Text(
          "Sign In",
          style: TextStyle(color: Colors.white),
        ),
      ));
    } else {
      return ListView(
          children: images
              .map((e) => Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 10),
                    height: 150,
                    child: Image.network(
                      e ?? "unknow",
                      fit: BoxFit.contain,
                    ),
                  ))
              .toList());
    }
  }

  _onUploadImage() async {
    showLoadingDialog();
    if (loading == true) return;
    loading = true;
    try {
      var file = await FilePicker.getFile(type: FileType.image);
      if (file == null) return;
      var storeRef = FirebaseStorage.instance
          .ref()
          .child("user_images/" + Uuid().v4() + p.extension(file.path));
      var task = storeRef.putFile(file);
      var snap = await task.onComplete;
      var url = await snap.ref.getDownloadURL();

      var doc = await Firestore.instance.collection("imgs").add({
        "url": url,
        "uid": gAccount.id,
        "created_at": FieldValue.serverTimestamp()
      });
      await _loadImage();
      // print(doc.path);
    } catch (e) {
      print(e);
    }
    loading = false;
    hideLoadingDialog();
    setState(() {});
  }

  _loadImage() async {
    try {
      if (gAccount == null) return;
      var snap = await Firestore.instance
          .collection("imgs")
          .where('uid', isEqualTo: gAccount.id)

          // .where('url', )
          .getDocuments();
      images = snap.documents
          .where((e) => e.data['url'] != null)
          .map((e) => (e.data['url'] as String))
          .toList();
    } catch (e) {
      print(e);
      images = [];
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Img Upload"),
          actions: isLogged == true
              ? [
                  IconButton(
                    icon: Icon(Icons.exit_to_app),
                    onPressed: _handleSignOut,
                  ),
                ]
              : null,
        ),
        body: LoadingProvider(
          themeData: LoadingThemeData(
              // loadingBackgroundColor: Colors.black.withAlpha(0),

              ),
          child: Container(
            padding: EdgeInsets.all(15),
            child: _buildBody(),
          ),
        ),
        floatingActionButton: isLogged == false
            ? null
            : FloatingActionButton(
                onPressed: _onUploadImage,
                mini: true,
                child: Icon(
                  Icons.cloud_upload,
                ),
              ));
  }
}
