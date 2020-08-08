import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qrcode_flutter/qrcode_flutter.dart';
import 'package:share/share.dart';
import 'package:vibration/vibration.dart';

class ReadQrView extends StatefulWidget {
  @override
  _ReadQrViewState createState() => _ReadQrViewState();
}

class _ReadQrViewState extends State<ReadQrView> {
  QRCaptureController _captureController = QRCaptureController();
  bool _isTorch = false;
  String txtQr;
  bool border = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _loadCapture();
  }

  _loadCapture() async {
    _captureController.onCapture((data) async {
      try {
        if (txtQr == data) return;
        txtQr = data;
        // Scaffold.of(context).showSnackBar(
        //   SnackBar(
        //     content: Text(
        //       data,
        //     ),
        //   ),
        // );
        if (await Vibration.hasVibrator()) {
          Vibration.vibrate(duration: 200);
        }
        Fluttertoast.showToast(
          msg: data,
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          webShowClose: true,
          fontSize: 17.0,
        );
        setState(() {});
      } catch (e) {}
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(
      //     "Read Qr Code",
      //   ),
      // ),
      body: Container(
        padding: EdgeInsets.all(
          15,
        ),
        // color: Colors.red,
        child: Column(
          children: [
            Expanded(
              flex: 4,
              child: QRCaptureView(
                controller: _captureController,
              ),
            ),
            Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                child: SingleChildScrollView(
                  child: Container(
                    // height: 100,
                    // color: Colors.red,
                    padding: EdgeInsets.only(left: 50, right: 50),
                    decoration: BoxDecoration(
                      // color: Colors.red,
                      border: border == false
                          ? null
                          : Border(
                              bottom: BorderSide(
                                color: Colors.red,
                                width: 1,
                              ),
                            ),
                    ),
                    alignment: Alignment.center,
                    child: txtQr == null
                        ? Text("")
                        : InkWell(
                            child: Text(
                              txtQr,
                              style: TextStyle(color: Colors.blue),
                            ),
                            onTap: () async {
                              await Share.share(txtQr, subject: "Text");
                            },
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // FloatingActionButton(
                //   onPressed: () {
                //     _captureController.pause();
                //   },
                //   mini: true,
                //   child: Icon(Icons.pause),
                // ),
                // FloatingActionButton(
                //   onPressed: () {
                //     _captureController.resume();
                //   },
                //   mini: true,
                //   child: Icon(Icons.play_arrow),
                // ),
                FloatingActionButton(
                  onPressed: () {
                    try {
                      if (_isTorch) {
                        _captureController.torchMode = CaptureTorchMode.off;
                        _isTorch = false;
                      } else {
                        _captureController.torchMode = CaptureTorchMode.on;
                        _isTorch = true;
                      }
                      setState(() {});
                    } catch (e) {}
                  },
                  mini: true,
                  backgroundColor: _isTorch ? Colors.amber : null,
                  child: Icon(
                    Icons.lightbulb_outline,
                  ),
                )
              ],
            ),
            txtQr == null
                ? SizedBox()
                : FloatingActionButton(
                    child: Icon(
                      Icons.delete,
                    ),
                    mini: true,
                    onPressed: () {
                      txtQr = null;
                      setState(() {});
                    })
          ],
        ),
      ),
    );
  }
}
