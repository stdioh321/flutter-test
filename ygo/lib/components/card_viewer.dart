import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:ygo/models/card_model.dart';

class CardViewer extends StatefulWidget {
  // final String url;
  final CardModel card;

  CardViewer({@required this.card});

  @override
  _CardViewerState createState() => _CardViewerState();
}

class _CardViewerState extends State<CardViewer> {
  PageController _pageCtrl = PageController();
  PhotoViewController _photoCtrl;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _photoCtrl = PhotoViewController();

    // _pageCtrl.addListener(() {
    //   print('_pageCtrl.addListener');

    // });
  }

  double currPage() {
    double _page = 0;
    try {
      _page = _pageCtrl.page;
    } catch (e) {
      print('currPage ERROR');
    }
    return _page;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return Scaffold(
          floatingActionButton: _pageCtrl?.page < widget.card.cardImages.length
              ? FloatingActionButton(
                  onPressed: () {
                    try {
                      // print(_pageCtrl.page ?? "Nothing");
                      _pageCtrl.nextPage(
                        curve: Curves.easeInCubic,
                        duration: Duration(milliseconds: 100),
                      );
                    } catch (e) {}
                  },
                  child: Icon(Icons.arrow_forward),
                )
              : SizedBox(),
          appBar: AppBar(
            title: Text(widget.card.name, style: TextStyle(fontSize: 13)),
          ),
          body: GestureDetector(
            onTap: () {
              print(_pageCtrl.page);
            },
            child: Container(
                // child: PhotoView(
                //   enableRotation: true,
                //   imageProvider: NetworkImage(card.cardImages[0].imageUrl),
                // ),
                child: Stack(
              children: [
                PhotoViewGallery.builder(
                  pageController: _pageCtrl,
                  // onPageChanged: ,
                  itemCount: widget.card.cardImages.length ?? 0,
                  loadingBuilder: (context, event) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                  builder: (_, idx) {
                    return PhotoViewGalleryPageOptions(
                      controller: _photoCtrl,
                      tightMode: true,
                      imageProvider: NetworkImage(
                        widget.card.cardImages[idx].imageUrl,
                      ),
                    );
                  },
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Text("HERE: ${currPage()}"),
                ),
              ],
            )),
          ),
        );
      },
    );
  }
}
