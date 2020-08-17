import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';
import 'package:path/path.dart' as p;
import 'package:url_launcher/url_launcher.dart';

class ListFilesView extends StatefulWidget {
  @override
  _ListFilesViewState createState() => _ListFilesViewState();
}

class _ListFilesViewState extends State<ListFilesView> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  var storage = FirebaseStorage.instance;
  String fName;
  bool loading = false;
  var _scaffState = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState

    _handleSignIn();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffState,
        appBar: AppBar(
          title: Text("List Files"),
        ),
        body: LoadingProvider(
          themeData: LoadingThemeData(
              loadingBackgroundColor: Colors.black.withAlpha(0)),
          child: Container(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(),
                RaisedButton.icon(
                  onPressed: () async {
                    try {
                      if (loading == true) return;
                      loading = true;
                      showLoadingDialog();
                      var file = await FilePicker.getFile();
                      if (file != null) {
                        // fName = p.basename(file.path);
                        await _onUploadFile(file);
                        _scaffState.currentState.showSnackBar(SnackBar(
                          content: Text("File Uploaded"),
                          duration: Duration(seconds: 2),
                        ));
                      } else {
                        fName = null;
                      }
                    } catch (e) {
                      fName = null;
                      print(e);
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Sorry...'),
                              content: Text('Unable to upload file'),
                              actions: <Widget>[
                                FlatButton(
                                  child: Text('OK'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            );
                          });
                    }
                    loading = false;
                    hideLoadingDialog();
                    setState(() {});
                  },
                  icon: Icon(Icons.cloud_upload),
                  label: Text("Upload File"),
                ),
                SizedBox(height: 30),
                RaisedButton(
                  onPressed: () async {
                    _onGetFiles();
                  },
                  child: Text("Get File"),
                ),
                SizedBox(height: 30),
                fName == null
                    ? Container()
                    : Container(
                        child: InkWell(
                            onTap: () async {
                              // const url = 'https://flutter.dev';
                              if (await canLaunch(fName)) {
                                await launch(fName);
                              } else {
                                // throw 'Could not launch $url';
                              }
                            },
                            child: InkWell(
                              onTap: () async {
                                if (await canLaunch(fName) == true) {
                                  launch(fName);
                                }
                              },
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      fName,
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  Icon(
                                    Icons.launch,
                                    color: Colors.blue,
                                  )
                                ],
                              ),
                            )),
                      )
              ],
            ),
          ),
        ));
  }

  _onGetFiles() async {
    var storageReference =
        await FirebaseStorage.instance.ref().child("others/somefile");
    // print(storageReference.);
  }

  _handleSignIn() async {
    print("_handleSignIn");
    if (await _googleSignIn.isSignedIn() == false) {
      print("Not Logged");
      var g = await _googleSignIn.signIn();
      print((await g.authentication).accessToken);
    }
  }

  _onUploadFile(File file) async {
    // var storageReference =
    //     FirebaseStorage(storageBucket: "gs://boilerplate-flutter.appspot.com");
    // var app = FirebaseApp(name: "test");
    // var app = await FirebaseApp.configure(
    //   name: "test",
    //   options: FirebaseOptions(
    //       googleAppID: "1:700032425192:android:f8d34d2d19d0c7c4d6bd5d",
    //       projectID: "boilerplate-flutter",
    //       apiKey: "AIzaSyBQTTU82YKc3ZxdTXnW0F-lGUTjJvypBD8",
    //       gcmSenderID: "700032425192"),
    // );

    await _handleSignIn();
    // final GoogleSignInAuthentication googleAuth =
    //     await googleUser.authentication;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    // final FirebaseUser user =
    //     (await _auth.signInWithCredential(credential)).user;
    // print("signed in " + user.displayName);
    var storage = FirebaseStorage.instance;

    String filename = p.basename(file.path);

    // final FirebaseStorage storage = FirebaseStorage.instance;
    // // storageReference = FirebaseStorage.instance.ref().child("others/$filename");
    // // storageReference = FirebaseStorage()

    final StorageUploadTask uploadTask =
        storage.ref().child("others/$filename").putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
    final String url = (await downloadUrl.ref.getDownloadURL());
    print("URL is $url");
    fName = url;
  }
}
