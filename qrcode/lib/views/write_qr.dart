import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:share/share.dart';
import 'dart:ui' as ui;

import 'package:share_extend/share_extend.dart';

class WriteQrView extends StatefulWidget {
  @override
  _WriteQrViewState createState() => _WriteQrViewState();
}

class _WriteQrViewState extends State<WriteQrView> {
  String _txt = "";
  var _globalKey = GlobalKey();
  dynamic image;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    _txt = "";
    _removeFocus();
    // print("initState");
  }

  @override
  dispose() {
    super.dispose();
    _removeFocus();
    // print('dispose write');
  }

  _removeFocus() {
    try {
      SystemChannels.textInput.invokeMethod('TextInput.hide');

      FocusScope.of(context).requestFocus(FocusNode());
    } catch (e) {
      print(e);
    }
  }

  QrImage _generateQrImage() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Expanded(
                flex: 2,
                child: RepaintBoundary(
                  key: _globalKey,
                  child: QrImage(
                      backgroundColor: Colors.white,
                      data: _txt,
                      version: QrVersions.auto,
                      gapless: false,
                      errorStateBuilder: (cxt, err) {
                        return Container(
                          child: Center(
                            child: Text(
                              "Uh oh! Something went wrong...",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }
                      // size: 200.0,
                      ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.bottomCenter,
                child: TextFormField(
                  initialValue: _txt,
                  onChanged: (value) {
                    _txt = value;
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    labelText: "Text",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            RenderRepaintBoundary boundary =
                _globalKey.currentContext.findRenderObject();
            // print(boundary);
            ui.Image image = await boundary.toImage(pixelRatio: 3.0);
            ByteData byteData =
                await image.toByteData(format: ui.ImageByteFormat.png);
            var pngBytes = byteData.buffer.asUint8List();
            // var bs64 = base64Encode(pngBytes);
            String dir = (await getTemporaryDirectory()).path;
            print(dir);
            File f = File("$dir/pic.png");
            if (await f.exists()) {
              await f.delete();
            }
            await f.writeAsBytes(pngBytes);
            await ShareExtend.share(f.path, "image");
          } catch (e) {
            print(e);
          }
        },
        mini: true,
        child: Icon(
          Icons.share,
        ),
      ),
    );
  }
}
