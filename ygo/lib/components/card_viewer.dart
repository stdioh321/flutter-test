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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            child: PhotoViewGallery.builder(
                pageController: _pageCtrl,
                itemCount: widget.card.cardImages.length ?? 0,
                loadingBuilder: (context, event) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
                builder: (_, idx) {
                  return PhotoViewGalleryPageOptions(
                    imageProvider: NetworkImage(
                      widget.card.cardImages[idx].imageUrl,
                    ),
                  );
                })),
      ),
    );
  }
}
