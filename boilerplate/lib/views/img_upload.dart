import 'dart:io';

import 'package:boilerplate/services/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:load/load.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:uuid/uuid.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImgUploadView extends StatefulWidget {
  @override
  _ImgUploadViewState createState() => _ImgUploadViewState();
}

class _ImgUploadViewState extends State<ImgUploadView> {
  bool _loading = false;
  List<Map<String, dynamic>> images = [];
  // List<int> selectImages = [];

  bool get loading {
    return _loading;
  }

  set loading(bool status) {
    if (status == true) {
      _loading = true;
      showLoadingDialog(tapDismiss: false);
    } else {
      _loading = false;
      hideLoadingDialog();
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    images = [];

    _loadImages();
  }

  _loadImages() async {
    if (loading == true) return;
    loading = true;
    try {
      var snaps = await Firestore.instance.collection("imgs").getDocuments();
      images = snaps.documents.where((e) {
        // print(e.data);
        if (e.data['url'] != null) return true;
        return false;
      }).map((e) {
        var tmp = Img.fromJson(e.data);
        tmp.id = e.documentID;
        var json = {"img": tmp, "selected": false};
        return json;
      }).toList();
    } catch (e) {
      print(e);
      Utils.instance.defaultToast("Unable to load the images", bg: Colors.red);
    }
    loading = false;
    setState(() {});
  }

  _buildBody() {
    if (images.length == 0)
      return Center(
        child: Text("Empty"),
      );
    return Container(
      padding: EdgeInsets.all(15),
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 5,
        mainAxisSpacing: 10,
        children: images.map((e) {
          var currImg = e;
          return Stack(
            children: [
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 5,
                    color: currImg['selected'] == true
                        ? Colors.green
                        : Colors.transparent,
                  ),
                ),
                // color: Colors.grey[200],
                padding: EdgeInsets.all(5),
                child: GestureDetector(
                  onDoubleTap: () {
                    if (e['selected'] == true) {
                      e['selected'] = false;
                    } else {
                      e['selected'] = true;
                    }
                    setState(() {});
                  },
                  onTap: () {
                    var singlePhoto = Container(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          PhotoView(
                            imageProvider: NetworkImage(e['img'].url),
                            enableRotation: true,
                            loadingBuilder: (context, event) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            },
                            // initialScale: 1,
                          ),
                          // Text(
                          //   e['img'].url,
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       backgroundColor: Colors.black.withAlpha(100)),
                          // ),
                        ],
                      ),
                    );

                    // var galleryPhotos = Container(
                    //   child: PhotoViewGallery.builder(
                    //     itemCount: images.length,
                    //     onPageChanged: (index) {
                    //       currIndex = index;
                    //       print(index);
                    //     },
                    //     pageController: pCtrl,
                    //     builder: (context, index) {
                    //       return PhotoViewGalleryPageOptions(
                    //         imageProvider:
                    //             NetworkImage(images[index]['img'].url),
                    //       );
                    //     },
                    //   ),
                    // );
                    int currIndex = images.indexOf(e);
                    var pCtrl = PageController(initialPage: currIndex);
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) {
                        return Scaffold(
                          appBar: AppBar(
                            title: Text("Image"),
                            actions: [],
                          ),
                          body: Container(child: singlePhoto),
                        );
                      },
                    ));
                  },
                  child: Transform.scale(
                    scale: 1,
                    child: FadeInImage(
                      placeholder: AssetImage("assets/images/loading.gif"),
                      image: NetworkImage(e['img'].url),
                      fit: BoxFit.contain,
                      fadeInDuration: Duration(milliseconds: 100),
                      fadeOutDuration: Duration(milliseconds: 100),
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/image_404.png",
                          fit: BoxFit.contain,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Container()
            ],
          );
        }).toList(),
      ),
    );
  }

  _uploadImg() async {
    // setState(() {});
    // return;
    if (loading == true) return;
    loading = true;
    try {
      File f = await FilePicker.getFile(type: FileType.image);
      if (f != null) {
        var ref = FirebaseStorage.instance
            .ref()
            .child("imgs/" + Uuid().v4() + p.extension(f.path));
        var taskSnap = await ref.putFile(f).onComplete;
        var url = await taskSnap.ref.getDownloadURL();
        var tms = FieldValue.serverTimestamp();
        var doc = await Firestore.instance.collection("imgs").add(
          {
            "url": url,
            "created_at": tms,
            "updated_at": tms,
          },
        );
        var tmp = Img.fromJson((await doc.get()).data);
        tmp.id = doc.documentID;
        images.add({"img": tmp, "selected": false});
      }
      // FirebaseStorage.instance.ref().child("imgs").;
    } catch (e) {
      print(e);
      Utils.instance.defaultToast("Unable to upload image", bg: Colors.red);
    }
    loading = false;
    setState(() {});
  }

  _deleteImgs() async {
    if (loading == true) return;

    bool shouldDelete = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Container(
            child: Text("Realy delete?"),
          ),
          actions: [
            RaisedButton(
                child: Text("No"),
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // return false;
                }),
            RaisedButton(
                child: Text("Yes", style: TextStyle(color: Colors.white)),
                color: Colors.red,
                onPressed: () {
                  Navigator.of(context).pop(true);
                  // return true;
                }),
          ],
        );
      },
    );
    if (shouldDelete != true) return;
    loading = true;
    var tmpImages = images.where((e) => e['selected'] == true).toList();
    try {
      // var snap = await Firestore.instance.collection("imgs").getDocuments();
      tmpImages.forEach((e) async {
        var doc =
            await Firestore.instance.collection("imgs").document(e['img'].id);
        await doc.delete();
        var ref = await FirebaseStorage.instance
            .ref()
            .getStorage()
            .getReferenceFromUrl(e['img'].url);
        await ref.delete();
      });
      images.removeWhere((e) => e['selected'] == true);
    } catch (e) {
      print(e);
      Utils.instance.defaultToast("Error deleting images.", bg: Colors.red);
    }
    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Img Upload"),
      ),
      body: LoadingProvider(
        // key: loadingKey,
        themeData: LoadingThemeData(tapDismiss: false),
        child: Container(
          child: _buildBody(),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          images.where((e) => e['selected'] == true).isEmpty
              ? SizedBox()
              : FloatingActionButton(
                  onPressed: _deleteImgs,
                  child: Icon(Icons.delete),
                ),
          SizedBox(
            height: 20,
          ),
          FloatingActionButton(
            onPressed: _uploadImg,
            child: Icon(
              Icons.cloud_upload,
            ),
          )
        ],
      ),
    );
  }
}

class Img {
  String _id;
  String _url;
  Timestamp _createdAt;
  Timestamp _updatedAt;

  Img({String id, String url, Timestamp createdAt, Timestamp updatedAt}) {
    this._id = id;
    this._url = url;
    this._createdAt = createdAt;
    this._updatedAt = updatedAt;
  }

  String get id => _id;
  set id(String id) => _id = id;
  String get url => _url;
  set url(String url) => _url = url;
  Timestamp get createdAt => _createdAt;
  set createdAt(Timestamp createdAt) => _createdAt = createdAt;
  Timestamp get updatedAt => _updatedAt;
  set updatedAt(Timestamp updatedAt) => _updatedAt = updatedAt;

  Img.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _url = json['url'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['url'] = this._url;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
